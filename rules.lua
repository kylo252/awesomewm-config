--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}

local tag_list = require("widgets.tag-list")
local tagnames = tag_list.names

-- ===================================================================
-- Rules
-- ===================================================================

-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
  return {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.centerd,
        titlebars_enabled = true,
        fullscreen = false,
        floating = true,
        maximized = false,
      },
    },
    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA",
          "copyq",
        },
        class = {
          "Nm-connection-editor",
          "arandr",
          "blueman-manager",
          "gpick",
          "kruler",
          "messagewin", -- kalarm.
          "sxiv",
          "wpa_gui",
          "veromix",
          "xtightvncviewer",
        },
        name = {
          "Event Tester",
          "Steam Guard - Computer Authorization Required",
        },
        role = {
          "pop-up",
          "GtkFileChooserDialog",
        },
        type = {
          "dialog",
        },
      },
      properties = { floating = true },
    },
    {
      rule_any = { class = { "Alacritty" } },
      properties = { floating = false },
    },
    {
      rule_any = { class = { "Discord", "Element" } },
      properties = { tag = tagnames[8], floating = false, titlebars_enabled = true },
    },
    {
      rule_any = { class = { "Code" } },
      properties = { tag = tagnames[3], floating = true, placement = awful.placement.centered },
    },
    {
      rule_any = { class = { "Chromium-browser" } },
      properties = { floating = false },
    },
    {
      rule_any = { class = { "Microsoft-edge-beta" } },
      properties = { floating = false },
    },
    {
      rule_any = { class = { "Microsoft Teams - Preview" } },
      properties = { tag = tagnames[5], floating = false },
    },
    {
      rule_any = { class = { "Evolution" } },
      properties = { tag = tagnames[6], floating = false },
    },
    {
      rule_any = { name = { "rofi" } },
      properties = { floating = true },
    },

    -- Visualizer
    {
      rule_any = { name = { "cava" } },
      properties = {
        floating = true,
        maximized_horizontal = true,
        sticky = true,
        ontop = false,
        skip_taskbar = true,
        below = true,
        focusable = false,
        height = screen_height * 0.40,
        opacity = 0.6,
      },
      callback = function(c)
        decorations.hide(c)
        awful.placement.bottom(c)
      end,
    },

    -- File chooser dialog
    {
      rule_any = { role = { "GtkFileChooserDialog" } },
      properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.65 },
    },

    -- Pavucontrol & Bluetooth Devices
    {
      rule_any = { class = { "Pavucontrol" }, name = { "Bluetooth Devices" } },
      properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.45 },
    },
  }
end

-- return module table
return rules
