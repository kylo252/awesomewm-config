-- define default apps (global variable so other components can access it)
local gears = require("gears")

local theme_dir = gears.filesystem.get_configuration_dir() .. "themes/pastel"

return {
  terminal = "alacritty",
  terminalAlt = "alacritty --config-file=" .. os.getenv("HOME") .. "/.config/alacritty/alacritty-remote.yml",
  browser = "flatpak run com.github.Eloston.UngoogledChromium --use-gl=desktop --enable-features=VaapiVideoDecoder --enable-features=WebUIDarkMode --force-dark-mode --ignore-gpu-blocklist",
  edge = "flatpak run com.microsoft.Edge --use-gl=desktop --enable-features=VaapiVideoDecoder ",
  brave = "flatpak run com.brave.Browser --use-gl=desktop --enable-features=VaapiVideoDecoder --disable-brave-extension",
  teams = "teams",
  launcher = "rofi -show combi  -display-combi '  ' -theme " .. theme_dir .. "/launcher.rasi",
  dlauncher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. theme_dir .. "/dlauncher.rasi",
  screen_manager = "bash -c ~/.config/rofi/rofi-scripts/monitor_layout.sh",
  quickmenu = "rofi -show drun -theme dmenu -no-disable-history",
  power_manager = "xfce4-power-manager-settings",
  power_menu = "powermenu_t1",
  translator = "alacritty --command trans en:sv -b", --broken
  windowrunner = "rofi -normal-window -modi window -show window -theme alter",
  network_manager = "nm-connection-editor",
  filemanager = "thunar",
  screenshot = "flameshot gui",
  scrot = "~/.local/bin/scrot_launcher",
  one_shot = { -- List of apps to run on start-up
    "picom --experimental-backends --config " .. theme_dir .. "/picom.conf",
    "touchegg",
    "setxkbmap -layout 'us,se' -variant 'basic,basic'",
    "xfce4-power-manager",
    -- "unclutter",
  },
}
