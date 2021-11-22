-- define default apps (global variable so other components can access it)
local gears = require("gears")

local theme_config_dir = gears.filesystem.get_configuration_dir() .. "themes/pastel"
-- local rofi_theme = theme_config_dir .. "/theme.rasi"
local rofi_theme = theme_config_dir .. "/theme.rasi"
local rofi_launcher_theme = theme_config_dir .. "/launcher-theme.rasi"

return {
  terminal = "alacritty",
  terminalAlt = "alacritty --config-file=" .. os.getenv("HOME") .. "/.config/alacritty/alacritty-remote.yml",
  browser = os.getenv("HOME")
    .. "/.nix-profile/bin/chromium --enable-features=WebUIDarkMode --force-dark-mode --enable-native-gpu-memory-buffers %U --incognito",
  browser_normal = os.getenv("HOME")
    .. "/.nix-profile/bin/chromium --enable-features=WebUIDarkMode --force-dark-mode --enable-native-gpu-memory-buffers %U",
  edge = "microsoft-edge --use-gl=desktop --enable-features=VaapiVideoDecoder",
  brave = "brave-browser --use-gl=desktop --enable-features=VaapiVideoDecoder --incognito",
  teams = "teams",
  launcher = "rofi -show combi  -display-combi '  ' -theme " .. rofi_theme,
  -- dlauncher = "rofi -normal-window -modi drun -show drun -theme " .. theme_config_dir .. "rofi.rasi",
  screen_manager = "bash -c ~/.config/rofi/rofi-scripts/monitor_layout.sh",
  quickmenu = "rofi -show drun -theme dmenu ",
  dlauncher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. rofi_launcher_theme,
  power_manager = os.getenv("HOME") .. "/.config/rofi/powermenu/powermenu.sh",
  translator = "alacritty --command trans en:sv -b", --broken
  windowrunner = "rofi -normal-window -modi window -show window -theme alter",
  filemanager = "pcmanfm",
  screenshot = "flameshot gui",
  scrot = "~/.local/bin/scrot_launcher",
  one_shot = { -- List of apps to run on start-up
    "picom --experimental-backends",
    "setxkbmap -layout 'se,se' -variant 'hack,basic'",
    "unclutter",
  },
}
