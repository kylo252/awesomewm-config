-- define default apps (global variable so other components can access it)
return {
  terminal = "alacritty",
  terminalAlt = "alacritty --config-file=" .. os.getenv("HOME") .. "/.config/alacritty/alacritty-remote.yml",
  browser = os.getenv("HOME") .. "/.nix-profile/bin/chromium --enable-features=WebUIDarkMode --force-dark-mode --enable-native-gpu-memory-buffers %U --incognito",
  browser_normal = os.getenv("HOME") .. "/.nix-profile/bin/chromium --enable-features=WebUIDarkMode --force-dark-mode --enable-native-gpu-memory-buffers %U",
  edge = "microsoft-edge",
  teams = "teams",
  launcher = "rofi -show combi  -display-combi '  '",
  -- dlauncher = "rofi -normal-window -modi drun -show drun -theme " .. theme_config_dir .. "rofi.rasi",
  screen_manager =  "bash -c ~/.config/rofi/rofi-scripts/monitor_layout.sh",
  autorandr = "zsh -c 'autorandr -c default'",
  quickmenu = "rofi -show drun -theme dmenu ",
  dlauncher = "rofi -no-lazy-grab -show drun -modi drun -theme sidetab-adapta",
  power_manager = os.getenv("HOME") .. "/.config/rofi/powermenu/powermenu.sh",
  translator =  "alacritty --command trans en:sv -b", --broken
  windowrunner = "rofi -normal-window -modi window -show window -theme alter",
  filemanager = "pcmanfm",
  screenshot = "flameshot gui",
  scrot = "~/.local/bin/scrot_launcher"
}
