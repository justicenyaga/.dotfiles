---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local terminal = programs.terminal
local fileManager = programs.fileManager
local menu = programs.menu

local function bind(keys, dispatcher, opts)
	return hl.bind(keys, dispatcher, opts)
end

local function exec(keys, cmd, opts)
	return hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- Core
exec(mainMod .. " + Return", terminal)
bind(mainMod .. " + Q", hl.dsp.window.close())
exec(mainMod .. " + SHIFT + Q", "wlogout -b 2")
bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager, { workspace = "3" }))
bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
exec(mainMod .. " + D", menu)
bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
exec(mainMod .. " + SHIFT + B", "~/.config/waybar/launch.sh")
exec(mainMod .. " + SHIFT + P", "killall hyprpaper && hyprpaper")
exec(mainMod .. " + semicolon", "emote")
exec(mainMod .. " + ALT + L", "hyprlock")
exec(mainMod .. " + T", "~/.config/hypr/scripts/toggle_touchpad.sh")
exec(mainMod .. " + ALT + K", "~/.config/hypr/scripts/keyboard-layout.sh")
exec(mainMod .. " + N", "~/.config/quickshell/sticky-notes/notes.sh")
exec(mainMod .. " + B", "pkill -x overskride || overskride")

-- Laptop display on / off
bind(mainMod .. " + SHIFT + M", function()
	hl.monitor({ output = "eDP-1", mode = "1920x1200", position = "1920x0", scale = 1 })
end)
bind(mainMod .. " + ALT + M", function()
	hl.monitor({ output = "eDP-1", disabled = true })
end)

-- Media (mpc variants kept commented as in the old config)
-- exec(mainMod .. " + SHIFT + space",  "mpc toggle")
-- exec(mainMod .. " + SHIFT + comma",  "mpc prev")
-- exec(mainMod .. " + SHIFT + period", "mpc next")
exec(mainMod .. " + SHIFT + space", "playerctl play-pause")
exec(mainMod .. " + SHIFT + comma", "playerctl previous")
exec(mainMod .. " + SHIFT + period", "playerctl next")
exec(mainMod .. " + comma", "mpc volume -5")
exec(mainMod .. " + period", "mpc volume +5")

-- Clipboard
-- Main clipboard history
exec(
	mainMod .. " + V",
	[[pgrep wofi >/dev/null 2>&1 && killall wofi || cliphist list | wofi -S dmenu -p "Clipboard History" -i -W 40% -H 40% | cliphist decode | wl-copy]]
)
-- Delete specific clipboard entry
exec(
	mainMod .. " + SHIFT + V",
	[[pgrep wofi >/dev/null 2>&1 && killall wofi || cliphist list | wofi -S dmenu -p "Delete Clipboard Entry" -i -W 50% -H 60% | cliphist delete]]
)
-- Clear entire clipboard history
exec(mainMod .. " + ALT + V", [[cliphist wipe && notify-send "Clipboard history cleared"]])

-- Screenshots
exec(mainMod .. " + Print", [[hyprshot -o $(xdg-user-dir PICTURES)/screenshots -m window]])
exec("Print", [[hyprshot -o $(xdg-user-dir PICTURES)/screenshots -m output]])
exec("SHIFT + Print", [[hyprshot -o $(xdg-user-dir PICTURES)/screenshots -m region]])

-- Brightness
exec("XF86MonBrightnessUp", "brightnessctl set 10%+", { locked = true, repeating = true })
exec("XF86MonBrightnessDown", "brightnessctl set 10%-", { locked = true, repeating = true })

-- Volume and media control
exec("XF86AudioRaiseVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true })
exec("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { locked = true, repeating = true })
exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true })
exec("XF86AudioPlay", "playerctl play-pause", { locked = true })
exec("XF86AudioPrev", "playerctl previous", { locked = true })
exec("XF86AudioNext", "playerctl next", { locked = true })

-- Move focus with mainMod + arrow keys
bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + vim keys
bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Resize windows
bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
