--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

---@diagnostic disable-next-line: undefined-global
local capi = { awesome = awesome, client = client, mouse = mouse, root = root, screen = screen }

-- Standard awesome libraries
local apps = require("apps")
local awful = require("awful")

local gears = require("gears")
local utils = require("utils")

-- ===================================================================
-- User Configuration
-- ===================================================================

local themes = {
  "pastel", -- 1
  "powerarrow", -- 2
}

-- change this number to use the corresponding theme
local theme = themes[1]
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "themes/" .. theme

-- ===================================================================
-- Initialization
-- ===================================================================
-- Initialize components
-- local slide_panel = require("components.slide-panel")
require("components.notifications")
local top_panel = require("components.top-panel")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
capi.screen.connect_signal("property::geometry", utils.set_wallpaper)

-- Run all the apps listed in run_on_start_up
local one_shot_apps = apps["one_shot"]
for _, app in ipairs(one_shot_apps) do
  utils.run_once(app)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(theme_config_dir .. "/theme.lua")

-- Set up each screen (add tags & panels)
awful.screen.connect_for_each_screen(function(s)
  -- Only add the left panel on the primary screen
  -- if s.index == 1 then
  --   slide_panel.create(s)
  -- end

  -- Add the top panel to every screen
  top_panel.create(s)
  utils.set_wallpaper(s)
end)

-- Import Keybinds
local keys = require("keys")
capi.root.keys(keys.globalkeys)
capi.root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.magnifier,
}

-- Signal function to execute when a new client appears.
capi.client.connect_signal("manage", function(c)
  -- Set the window as a slave (put it at the end of others instead of setting it as master)
  if not capi.awesome.startup then
    awful.client.setslave(c)
  end

  if capi.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================

-- -- Autofocus a new client when previously focused one is closed
require("awful.autofocus")
--
-- -- -- Focus clients under mouse
-- client.connect_signal("mouse::enter", function(c)
--   c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================

-- Reload config when screen geometry changes
capi.screen.connect_signal("property::geometry", capi.awesome.restart)

capi.client.connect_signal("focus", function(c)
  local clients = awful.client.tiled(c.screen)
  if clients and #clients > 1 then
    c.border_color = beautiful.border_focus
  else
    c.border_color = beautiful.border_normal
  end
end)

capi.client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================
awful.screen.set_auto_dpi_enabled(false)

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
