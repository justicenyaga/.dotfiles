------------------
---- MONITORS ----
------------------

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1200", position = "1920x0", scale = 1 })

---------------------
---- MY PROGRAMS ----
---------------------

-- Shared with binds.lua via the global table below
local terminal = "kitty"
-- local fileManager = "kitty --session yazi_session"
local fileManager = "pgrep nautilus >/dev/null 2>&1 && killall nautilus && nautilus"
local browser = "zen-browser"
-- local menu     = "pgrep wofi >/dev/null 2>&1 && killall wofi || wofi --show drun"
local menu = "pgrep rofi >/dev/null 2>&1 && killall rofi || ~/.config/rofi/scripts/launcher_t1"

programs = {
	terminal = terminal,
	fileManager = fileManager,
	browser = browser,
	menu = menu,
}

-----------------
---- KEYBINDS ----
-----------------

require("binds")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("xrandr --output HDMI-A-1 --primary")

	hl.exec_cmd(terminal, { workspace = "1 silent" })
	hl.exec_cmd(browser, { workspace = "2 silent" })
	hl.exec_cmd("nautilus", { workspace = "3 silent" })
	-- hl.exec_cmd("/opt/teams-for-linux/teams-for-linux", { workspace = "4 silent" })
	hl.exec_cmd("insomnia", { workspace = "7 silent" })

	hl.exec_cmd("nm-applet")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("~/.config/waybar/launch.sh")
	hl.exec_cmd("/usr/lib/xfce4/notifyd/xfce4-notifyd")
	hl.exec_cmd("/usr/lib/xfce-polkit/xfce-polkit")
	hl.exec_cmd("hyprctl setcursor macOS 28")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("~/.config/hypr/scripts/startup.sh")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	hl.exec_cmd("/usr/lib/evolution-data-server/evolution-alarm-notify")
	hl.exec_cmd("~/.config/hypr/scripts/monitor-switcher.sh")
	hl.exec_cmd("sleep 3 && quickshell -p ~/.config/quickshell/sticky-notes")
	hl.exec_cmd("~/.config/hypr/scripts/teams-away-watch.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("ADW_DISABLE_PORTAL", "1")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("EDITOR", "nvim")

-- steam config - boost perf
hl.env("DXVK_ASYNC", "1")
hl.env("mesa_glthread", "true")
hl.env("ANV_ENABLE_PIPELINE_CACHE", "1")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 2,

		col = {
			active_border = "rgba(0a9cf5ee)",
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = true,
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	cursor = {
		no_hardware_cursors = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Small helper so rules stay one-liners: rule({ match... }, { effects... })
local function rule(match, effects)
	effects.match = match
	return hl.window_rule(effects)
end

rule({ class = ".*" }, { suppress_event = "maximize" })

-- Positioning
rule({ class = "xfce4-notifyd" }, { move = "10 60" })
rule({ class = "org.gnome.Calendar" }, { move = "781 51" })
rule({ class = "com.waybar.notif-center" }, { move = "1472 53" })
rule({ class = "galendae" }, { move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*-0.06))" })
rule({ class = "audio-switcher" }, { move = "(cursor_x-(window_w*0.58)) (cursor_y-(window_h*-0.06))" })
rule({ class = "io.github.kaii_lb.Overskride" }, { move = "1160 53" })

rule({ class = "xfce4-notifyd" }, { monitor = 1, no_initial_focus = true })

-- Floating: class-only
for _, class in ipairs({
	"^(blueman-manager)(.*)$",
	"^(io.github.kaii_lb.Overskride)(.*)$",
	"^(org.pulseaudio.pavucontrol)$",
	"^(nm-connection-editor)$",
	"^(nwg-look)$",
	"^(qt6ct)$",
	"^(Emulator)$",
	"^(kvantummanager)$",
	"^(scrcpy)$",
	"^(xfce-polkit)$",
	"^(org.gnome.gedit)$",
	"^(com.cisco.anyconnect.gui)$",
	"^(notif-center)$",
}) do
	rule({ class = class }, { float = true })
end

-- Floating: class + title
rule({ class = "(thunar)", title = "(File Operation Progress)" }, { float = true })
rule({ class = "(zen)", title = "(Sign in - Google Accounts — Zen Browser)" }, { float = true })
rule({ class = "(google-chrome)", title = "(Untitled - Google Chrome)" }, { float = true })
rule({ class = "^(thunar)$", title = "(Rename)(.*)" }, { float = true })
rule({ class = "^(brave)$", title = ".*wants to open.*" }, { float = true })
rule(
	{ class = "^(zen)$", initial_title = ".*Zen Browser.*", title = ".*Sign in - Google Accounts.*" },
	{ float = true, size = "600 800" }
)
rule({ class = "^(org.gnome.Calendar)$" }, { float = true, size = "360 600" })

-- Centering: class-only
for _, class in ipairs({
	"(Code)",
	"(obsidian)",
	"(Docker Desktop)",
	"(org.gnome.gedit)",
	"(Brave)",
	"(brave-browser)",
	"(brave)",
	"(zen)",
	"^(com.cisco.anyconnect.gui)$",
	"(steam)",
}) do
	rule({ class = class }, { center = true })
end

-- Centering: class + title
rule({ class = "(google-chrome)", title = "(Save File)" }, { center = true })
rule({ class = "(google-chrome)", title = "(Untitled - Google Chrome)" }, { center = true })
rule({ class = "(file-roller)", title = "(Extract)" }, { center = true })
rule({ class = "(Electron)", title = "(Location)" }, { center = true })
rule({ class = "^(thunar)$", title = "(Rename)(.*)" }, { center = true })

-- Workspace assignment
local workspaces = {
	{ "^(kitty)$", 1 },
	{ "^(org.wezfurlong.wezterm)$", 1 },
	{ "^(zen)$", 2 },
	{ "^(google-chrome)$", 2 },
	{ "^(thunar)$", 3 },
	{ "^(org.gnome.Nautilus)$", 3 },
	{ "^(teams-for-linux)$", 4 },
	{ "^(outlook-for-linux)$", 5 },
	{ "^(MongoDB Compass)$", 6 },
	{ "^(DBeaver)$", 6 },
	{ "^(DbVisualizer)$", 6 },
	{ "^(Postman)$", 7 },
	{ "^(insomnia)$", 7 },
	{ "^(mpv)$", 8 },
	{ "^(Spotify)$", 9 },
	{ "^(com.cisco.anyconnect.gui)$", 10 },
	{ "^(steam)$", 9 },
}
for _, w in ipairs(workspaces) do
	rule({ class = w[1] }, { workspace = tostring(w[2]) })
end
