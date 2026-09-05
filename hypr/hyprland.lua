local reload = "defaultwal"
local terminal = "alacritty"
local fileManager = "nemo ~/Downloads/"
local menu = "rofi -show drun -theme ~/.config/rofi/config.rasi"
local spotify = "/home/teenarp2026/.spicetify/spicetify watch -s"
local openBrowser = "firefox"
local pause_notif = ""
local wallpaperchanger = "wallpaperch-hyprland"
local clipmenu = "clipmenu"
local lenovo_system = "rofi-system.sh"
local soundVolumeUp = "pactl set-sink-volume 0 +1% "
local soundVolumeDown = "pactl set-sink-volume 0 -1% "
local soundMuteToggle = "pactl set-sink-mute 0 toggle"
local brightnessUp = "brillo -q -A 10 && ~/.config/sxhkd/brightness"
local brightnessDown = "brillo -q -U 10 && ~/.config/sxhkd/brightness"
local mediaPlayPause = "playerctl -i kdeconnect,firefox play-pause"
local mediaStop = "playerctl -i kdeconnect,firefox stop"
local mediaPrev = "playerctl -i kdeconnect,firefox previous"
local mediaNext = "playerctl -i kdeconnect,firefox next"
local micMuteToggle = "pactl set-source-mute @DEFAULT_SOURCE@ toggle && get-mic.sh"
local emoji_picker = "$(export BEMOJI_PICKER_CMD=\"rofi -dmenu -theme /home/teenarp2026/.config/rofi/emoji.rasi\" && bemoji -t)"
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local shift = "SHIFT"
local mainMod_shift = "SUPER + SHIFT"
local altshift = "ALT + SHIFT"
local colors = dofile(os.getenv("HOME") .. "/.cache/wal/colors-hyprland.lua")

--###############
--## MONITORS ###
--###############
-- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({
    output = "eDP-1",
    mode = "modeline 368.76 1920 2073 2288 2656 1080 1081 1084 1157 -HSync +Vsync",
    position = "auto",
    scale = "1",
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@100",
    position = "auto",
    scale = "1",
    mirror = "eDP-1",
})

hl.workspace_rule({
    workspace = "1",
    monitor = "eDP-1",
    decorate = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "eDP-1",
    decorate = true,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "eDP-1",
    decorate = true,
})

hl.workspace_rule({
    workspace = "4",
    monitor = "eDP-1",
    decorate = true,
})

hl.workspace_rule({
    workspace = "5",
    monitor = "eDP-1",
    decorate = true,
})
hl.workspace_rule({
    workspace = "6",
    monitor = "eDP-1",
    decorate = true,
})
hl.workspace_rule({
    workspace = "7",
    monitor = "eDP-1",
    decorate = true,
})
hl.workspace_rule({
    workspace = "8",
    monitor = "eDP-1",
    decorate = true,
})
hl.workspace_rule({
    workspace = "9",
    monitor = "eDP-1",
    decorate = true,
})
hl.workspace_rule({
    workspace = "10",
    monitor = "eDP-1",
    decorate = true,
})

--2>&1 > ~/somelog.txt
--##################
--## MY PROGRAMS ###
--##################

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- $openVSCode = code

--############################
--## ENVIRONMENT VARIABLES ###
--############################

-- See https://wiki.hyprland.org/Configuring/Environment-variables/

hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
--env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1

hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

hl.curve("myBezier", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2.5,
    bezier = "myBezier",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 2.5,
    bezier = "myBezier",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2.5,
    bezier = "myBezier",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2.5,
    bezier = "myBezier",
    style = "slidefade 20%",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
hl.gesture({
    fingers = 3,
    direction = "up",
    action = "fullscreen",
})

hl.device({
    name = "synaptics-tm3276-022",
    sensitivity = 0.2,
})

hl.device({
    name = "logitech-g304-1",
    sensitivity = 0.0,
})

hl.bind("Xf86AudioRaiseVolume", hl.dsp.exec_cmd(soundVolumeUp), { repeating = true })
hl.bind("Xf86AudioLowerVolume", hl.dsp.exec_cmd(soundVolumeDown), { repeating = true })
hl.bind("Xf86AudioMute", hl.dsp.exec_cmd(soundMuteToggle))
hl.bind("Xf86AudioMicMute", hl.dsp.exec_cmd(micMuteToggle))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(mediaPlayPause))
hl.bind("Xf86AudioStop", hl.dsp.exec_cmd(mediaStop))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(mediaPrev))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(mediaNext))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(pause_notif))
hl.bind("Xf86Favorites", hl.dsp.submap("mediacontrols"))
hl.define_submap("mediacontrols", function()
    hl.bind("Home", hl.dsp.exec_cmd(mediaPlayPause .. " && wtype \"e\""), { ignore_mods = true })
    hl.bind("End", hl.dsp.exec_cmd(mediaStop .. " && wtype \"e\""), { ignore_mods = true })
    hl.bind("Insert", hl.dsp.exec_cmd(mediaPrev .. " && wtype \"e\""), { ignore_mods = true })
    hl.bind("Delete", hl.dsp.exec_cmd(mediaNext .. " && wtype \"e\""), { ignore_mods = true })
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind("ALT + V", hl.dsp.exec_cmd("alacritty --class clipse -e 'clipse'"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightnessUp), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightnessDown), { repeating = true })
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("XF86wakeup", hl.dsp.exec_cmd("~/.config/hypr/gamemode.sh"))
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd("notify-send.sh -t 1000 --replace=10 \"Dunst\" \"Notifications off\" && sleep 1s && dunstctl set-paused true"))
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("dunstctl set-paused false && notify-send.sh -t 1000 --replace=10 \"Dunst\" \"Notifications on\""))

hl.bind(mainMod .. " + l", hl.dsp.exec_cmd("hyprlock"), { locked = true })

hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("glava-pywal-start"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(openBrowser))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("$openVSCode"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wallpaperchanger))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(lenovo_system))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("$emoji-picker"))

hl.bind("ALT + X", hl.dsp.window.close())
hl.bind(altshift .. " + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind("ALT + D", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + A", hl.dsp.global("quickshell:toggleLauncher"))
hl.bind(mainMod_shift .. " + M", hl.dsp.global("quickshell:toggleMorphTune"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod_shift .. " + A", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod_shift .. " + Z", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod_shift .. " + S", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod_shift .. " + X", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("~/.config/rofi/power.sh"))
hl.bind(mainMod .. " + left", hl.dsp.focus({ workspace = -1 }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

hl.bind("print", hl.dsp.pass({ window = "^(com\\.obsproject\\.Studio)$" }))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ workspace = -1 }))

hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.window_rule({
    match = {
        class = "blueberry.py",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "clipse",
    },
    float = true,
    size = "622 652",
    stay_focused = true,
    move = "(monitor_w*0.5-(window_w*0.5)) (monitor_h*0.5-(window_h*0.5))",
})

hl.window_rule({
    match = {
        class = "GLava",
    },
    xray = true,
})

hl.window_rule({
    match = {
        class = "firefox",
    },
    workspace = "2",
})

hl.window_rule({
    match = {
        class = "spotify",
    },
    workspace = "5",
})

hl.window_rule({
    match = {
        class = "vlc",
    },
    workspace = "4",
})

hl.window_rule({
    match = {
        class = "Code",
    },
    workspace = "3",
})

hl.window_rule({
    match = {
        class = "spotify",
    },
    opacity = "0.8 0.6",
})

hl.layer_rule({
    match = { namespace = "cava-bg" },
    xray = true
})

hl.layer_rule({
    match = { namespace = "hyprpicker" },
    no_anim = true
})

hl.layer_rule({
    match = {namespace = "rofi",},blur = true,
})

hl.layer_rule({
    match = { namespace = "quickshell.*" },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "GLava" },
    order = -1,
})

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
    --####################
    --## LOOK AND FEEL ###
    --####################
    -- Refer to https://wiki.hyprland.org/Configuring/Variables/
    -- https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 0,
        -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col = {
        inactive_border = {
              colors = {
                  colors.color2,
                  colors.color10,
              },
              angle = 45,
          },
        active_border = colors.color6,
        },
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,
        -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false,
        layout = "dwindle",
    },
    -- https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
        rounding = 8,
        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_strength = 0.1,
        dim_around = 0.2,
        -- https://wiki.hyprland.org/Configuring/Variables/#blur
        shadow = {
            enabled = true,
            range = 10,
            render_power = 9,
            offset = "5 5",
            scale = 1.5,
            color = "rgba(1a1a1aa0)",
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 3,
            new_optimizations = false,
            contrast = 1,
            brightness = 1,
            vibrancy = 0.2800,
        },
    },
    debug = {
        disable_logs = false,
        enable_stdout_logs = true,
    },
    -- https://wiki.hyprland.org/Configuring/Variables/#animations
    --animations {
    --    enabled = true
    --    animation = windows, 1, 5, myBezier
    --  animation = windowsOut, 1, 9, myBezier
    --    animation = border, 1, 10, myBezier
    --    animation = borderangle, 1, 8, myBezier
    --    animation = fade, 1, 7, myBezier
    --    animation = workspaces, 1, 6, myBezier
    --}
    animations = {
        enabled = true,
    },
    -- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = true, -- You probably want this
    },
    -- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    -- https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
        force_default_wallpaper = 1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true,
        disable_splash_rendering = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
    binds = {
        allow_workspace_cycles = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    --############
    --## INPUT ###
    --############
    -- https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        numlock_by_default = true,
        follow_mouse = 1,
        scroll_button = 274,
        force_no_accel = false,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            drag_lock = true,
            clickfinger_behavior = true,
            tap_and_drag = true,
        },
    },
    -- https://wiki.hyprland.org/Configuring/Variables/#gestures
    --    workspace_swipe = true
    --    workspace_swipe_fingers = 3
    --    workspace_swipe_min_fingers = 3
    --    workspace_swipe_distance = 6550
    --    workspace_swipe_forever = true
    --}
    -- Example per-device config
    -- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
    --###################
    --## KEYBINDINGSS ###
    --###################
    -- See https://wiki.hyprland.org/Configuring/Keywords/
    -- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    -- Move focus with mainMod + arrow keys
    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    -- Example special workspace (scratchpad)
    --bind = $mainMod, S, togglespecialworkspace, magic
    --bind = $mainMod SHIFT, S, movetoworkspace, special:magic
    -- Scroll through existing workspaces with mainMod + scroll
    -- Move/resize windows with mainMod + LMB/RMB and dragging
    -- trigger when the switch is turning on
    --bindl=,switch:Lid Switch, exec, hyprlock
    --bindl=,switch:on:[Lid Switch], exec, hyprctl keyword monitor "eDP-1, disable"
    -- trigger when the switch is turning off
    --bindl=,switch:off:[Lid Switch], exec, hyprctl keyword monitor "eDP-1, 1920x1080@120, 0x0, 1"
    --#############################
    --## WINDOWS AND WORKSPACES ###
    --#############################
    -- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    -- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
})

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("qs -n -p ~/.config/quickshell/")
    hl.exec_cmd("clipse -listen")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("fusuma -c ~/.config/fusuma/config1.yml")
    hl.exec_cmd("lxpolkit")
    hl.exec_cmd("glava-pywal-start")
    hl.exec_cmd("kdeconnectd")
end)


