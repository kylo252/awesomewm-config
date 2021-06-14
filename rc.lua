--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")

-- ===================================================================
-- User Configuration
-- ===================================================================

local themes = {
  "pastel", -- 1
  "mirage" -- 2
}

-- change this number to use the corresponding theme
local theme = themes[1]
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "configuration/" .. theme .. "/"

-- define default apps (global variable so other components can access it)
apps = {
  terminal = "alacritty",
  terminalAlt = "alacritty --config-file=" .. os.getenv("HOME") .. "/.config/alacritty/alacritty-remote.yml",
  browser = os.getenv("HOME") .. "/.nix-profile/bin/chromium --enable-features=WebUIDarkMode --force-dark-mode --enable-native-gpu-memory-buffers %U --incognito",
  edge = "microsoft-edge",
  teams = "teams",
  launcher = "rofi -show combi", -- -display-combi '  '",
  -- dlauncher = "rofi -normal-window -modi drun -show drun -theme " .. theme_config_dir .. "rofi.rasi",
  quickmenu = "rofi -show run -theme dmenu ",
  dlauncher = os.getenv("HOME") .. "/.config/rofi/launchers/slate/launcher.sh",
  power_manager = os.getenv("HOME") .. "/.config/rofi/powermenu/powermenu.sh",
  -- translator = "bash -c ~/.local/bin/rofi_trans",
  translator = os.getenv("HOME") .. "/.local/bin/rofi_trans",
  -- translator = os.getenv("HOME") .. "/.config/rofi/rofi-translate/rofi_trans",
  windowrunner = "rofi -normal-window -modi window -show window -theme " .. theme_config_dir .. "rofi.rasi",
  filemanager = "pcmanfm",
  screenshot = "flameshot gui"
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
network_interfaces = {wlan = 'wlp58s0', lan = 'enp0s31f6'}

-- List of apps to run on start-up
local run_on_start_up = {
  "picom --config " .. theme_config_dir .. "picom.conf",
  "feh --bg-fill " .. os.getenv("HOME") ..  "/Pictures/wallpapers/nebula.jpg",
  "autorandr -c",
  "imwheel -b \"4 5\" -kill",
  "redshift",
  "unclutter"
}

-- ===================================================================
-- Initialization
-- ===================================================================

-- Import notification appearance
require("components.notifications")

local run_once = function(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
      findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.easy_async_with_shell(
    string.format('pgrep -u $USER -x %s > /dev/null || %s', findme, cmd),
    function(stderr)
      -- Debugger
      if not stderr or stderr == '' or not debug_mode then
        return
      end
      naughty.notification({
        app_name = 'Start-up Applications',
        title = '<b>Oof! Error detected when starting an application!</b>',
        message = stderr:gsub('%\n', ''),
        timeout = 20,
        icon = require('beautiful').awesome_icon
      })
    end
  )
end

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
  run_once(app)
  -- local findme = app
  -- local firstspace = app:find(" ")
  -- if firstspace then findme = app:sub(0, firstspace - 1) end
  -- -- pipe commands to bash to allow command to be shell agnostic
  -- awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -c", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
  awful.layout.suit.tile, awful.layout.suit.tile.left, awful.layout.suit.tile.bottom, awful.layout.suit.tile.top,
  awful.layout.suit.magnifier
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the window as a slave (put it at the end of others instead of setting it as master)
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================

-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
