#!/usr/bin/env bash

LAPTOP="eDP-1"
LOG=/tmp/monitor-debug.log
SELF=$(readlink -f "$0")
TOKEN_FILE=/tmp/monitors-refresh.token
REFRESH_LOCK=/tmp/monitors-refresh.lock
QUIET_SECONDS=1.5          # how long without monitor events before refreshing

log() { echo "$(date +%T.%3N) [$$] $*" >> "$LOG"; }
hc()  { log "eval: $1"; local out; out=$(hyprctl eval "$1" 2>&1); [[ -n "$out" && "$out" != "ok" ]] && log "  -> $out"; }

# Connectors the kernel reports as physically connected, excluding built-in panels
connected_externals() {
    local s n
    for s in /sys/class/drm/card*-*/status; do
        [[ -r "$s" ]] || continue
        n=${s%/status}; n=${n##*/}; n=${n#card*-}       # card1-HDMI-A-1 -> HDMI-A-1
        [[ "$n" == eDP* || "$n" == LVDS* || "$n" == DSI* ]] && continue
        [[ "$(<"$s")" == "connected" ]] && echo "$n"
    done
}
external()       { connected_externals | head -1; }
is_external()    { connected_externals | grep -qx "$1"; }
is_placeholder() { [[ "$1" == FALLBACK* || "$1" == HEADLESS* ]]; }

laptop_enabled() { hyprctl monitors -j | jq -e --arg l "$LAPTOP" 'any(.[]; .name == $l)' >/dev/null; }
is_mirroring()   { hyprctl monitors all -j | jq -e 'any(.[]; .mirrorOf != "none" and .mirrorOf != null)' >/dev/null; }

laptop_alone()  { hc "hl.monitor({ output = \"$LAPTOP\", mode = \"preferred\", position = \"0x0\", scale = 1, disabled = false })"; }
laptop_off()    { hc "hl.monitor({ output = \"$LAPTOP\", disabled = true })"; }
laptop_mirror() { hc "hl.monitor({ output = \"$LAPTOP\", mode = \"$(laptop_mode_matching "$1")\", position = \"auto\", scale = 1, mirror = \"$1\", disabled = false })"; }

MIRROR_FORCE_SAME_RES=1

laptop_mode_matching() {
    local ext w h rate mode
    ext=$(hyprctl monitors -j | jq -r --arg n "$1" '.[] | select(.name == $n) | "\(.width) \(.height) \(.refreshRate)"')
    read -r w h rate <<<"$ext"
    rate=${rate:-60}

    mode=$(hyprctl monitors all -j | jq -r --arg l "$LAPTOP" --arg ext "${w}x${h}" --argjson r "$rate" '
        def closest($res):
            [ .[] | select(startswith($res + "@"))
              | { mode: rtrimstr("Hz"),
                  d: ((split("@")[1] | rtrimstr("Hz") | tonumber) - $r | if . < 0 then -. else . end) } ]
            | (min_by(.d) | .mode) // "";
        .[] | select(.name == $l) | .availableModes as $m
        | ($m | closest($ext)) as $same
        | if $same != "" then $same
          else ($m | closest($m[0] | split("@")[0])) end           # first mode = native resolution
    ')

    if [[ -n "$w" && "$mode" != "${w}x${h}@"* && "$MIRROR_FORCE_SAME_RES" == "1" ]]; then
        mode="${w}x${h}@$(printf '%.0f' "$rate")"
        log "  laptop doesn't list ${w}x${h}, forcing it"
    fi
    log "  external ${1} ${w}x${h}@${rate} Hz -> laptop mode ${mode:-preferred}"
    echo "${mode:-preferred}"
}
external_solo() { hc "hl.monitor({ output = \"$1\", mode = \"preferred\", position = \"auto\", scale = 1, disabled = false })"; }

schedule_refresh() {
    local token="$(date +%s%N)-$$-$RANDOM"
    echo "$token" > "$TOKEN_FILE"
    setsid -f "$SELF" refresh-if "$token" </dev/null >/dev/null 2>&1
}

refresh_if() {
    sleep "$QUIET_SECONDS"
    [[ "$(cat "$TOKEN_FILE" 2>/dev/null)" == "$1" ]] || exit 0    # a newer request exists
    refresh
}

# Wait (up to 4s) until at least one real monitor is on, no placeholder monitor,
# and the layout is the same twice in a row.
wait_settled() {
    local i prev="" cur
    for i in {1..20}; do
        cur=$(hyprctl monitors -j | jq -c '[.[] | {name, x, y, width, height, mirrorOf}]')
        if jq -e 'length > 0 and all(.[]; .name | test("^(FALLBACK|HEADLESS)") | not)' <<<"$cur" >/dev/null \
           && [[ "$cur" == "$prev" ]]; then
            return 0
        fi
        prev="$cur"
        sleep 0.2
    done
    log "  layout did not settle in 4s, refreshing anyway"
}

start_bar_and_wallpaper() {
    pgrep -x hyprpaper >/dev/null || setsid -f hyprpaper </dev/null >/dev/null 2>&1
    if ! pgrep -x waybar >/dev/null; then
        if [[ -x "$HOME/.config/waybar/launch.sh" ]]; then
            setsid -f "$HOME/.config/waybar/launch.sh" </dev/null >/dev/null 2>&1
        else
            setsid -f waybar </dev/null >/dev/null 2>&1
        fi
    fi
}

refresh() {
    exec 8>"$REFRESH_LOCK"
    flock 8                                     # one refresh at a time
    wait_settled
    log "refresh: waybar + hyprpaper (monitors: $(hyprctl monitors -j | jq -r '[.[].name] | join(",")'))"
    killall -q hyprpaper waybar
    for _ in {1..10}; do pgrep -x 'waybar|hyprpaper' >/dev/null || break; sleep 0.1; done
    start_bar_and_wallpaper

    # If either dies right after starting, start it again
    local i
    for i in 1 2; do
        sleep 1.5
        if ! pgrep -x waybar >/dev/null || ! pgrep -x hyprpaper >/dev/null; then
            log "  waybar/hyprpaper died after start, starting again"
            wait_settled
            start_bar_and_wallpaper
        fi
    done
}

go_external_only() {
    external_solo "$1"
    sleep 0.3
    laptop_off
}

go_mirror() {
    external_solo "$1"
    sleep 0.3
    laptop_mirror "$1"
}

go_laptop_only() {
    laptop_off
    sleep 0.5
    laptop_alone
    sleep 0.5
    if ! laptop_enabled || is_mirroring; then
        log "laptop not right yet, retrying"
        laptop_alone
    fi
}

apply_startup() {
    local ext; ext=$(external)
    if [[ -n "$ext" ]]; then
        log "startup: external $ext found -> external only"
        go_external_only "$ext"
    else
        log "startup: laptop only"
        go_laptop_only
    fi
    schedule_refresh
}

handle_event() {
    local line="$1" name="${1#*>>}"

    case "$line" in
        monitoradded\>\>*|monitorremoved\>\>*) ;;
        *) return ;;
    esac
    log "event: $line"

    schedule_refresh

    if [[ "$name" == "$LAPTOP" ]] || is_placeholder "$name"; then
        return
    fi

    case "$line" in
        monitoradded\>\>*)
            sleep 0.3
            if ! is_external "$name"; then
                log "  $name not connected per kernel, ignoring"
            elif is_mirroring; then
                log "  mirror mode is on, leaving it"
            elif laptop_enabled; then
                go_external_only "$name"
            else
                log "  laptop already off"
            fi
            ;;
        monitorremoved\>\>*)
            # Wait up to 2s for the kernel to report the connector as disconnected
            local i
            for i in {1..10}; do
                [[ -z "$(external)" ]] && break
                sleep 0.2
            done
            if [[ -n "$(external)" ]]; then
                log "  $(external) still connected, ignoring"
                return
            fi
            # Always re-apply, even if the laptop is on: in mirror mode it is still
            # pointing at the monitor that just went away.
            log "  no external left -> laptop only"
            go_laptop_only
            ;;
    esac
    schedule_refresh
}

watch_events() {
    # Only one watcher at a time: stop any older copy
    local pid
    for pid in $(pgrep -f "monitors.sh watch"); do
        [[ "$pid" != "$$" ]] && kill "$pid" 2>/dev/null && log "stopped old watcher $pid"
    done
    log "watcher started"

    apply_startup
    local sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
    log "watching $sock"
    socat -U - "UNIX-CONNECT:$sock" | while read -r line; do
        handle_event "$line"
    done
    log "event stream ended, watcher exiting"
}

toggle() {
    local ext; ext=$(external)

    if [[ -n "$ext" ]] && is_mirroring; then
        go_external_only "$ext"
    elif [[ -n "$ext" ]] && ! laptop_enabled; then
        go_mirror "$ext"
    elif [[ -n "$ext" ]]; then
        go_external_only "$ext"
    else
        go_laptop_only
    fi
    schedule_refresh
}

case "$1" in
    watch)      watch_events ;;
    toggle)     toggle ;;
    external)   ext=$(external); [[ -n "$ext" ]] && go_external_only "$ext"; schedule_refresh ;;
    refresh)    refresh ;;
    refresh-if) refresh_if "$2" ;;
    *)          echo "usage: $0 {watch|toggle|external|refresh}" >&2; exit 1 ;;
esac
