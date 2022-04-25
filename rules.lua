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
        placement = awful.placement.centered,
        titlebars_enabled = true,
        fullscreen = false,
        floating = true,
        maximized = false,
        switch_to_tags = false,
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
      properties = { floating = true, placement = awful.placement.no_offscreen },
    },
    {
      rule_any = { class = { "Alacritty" } },
      properties = { floating = false },
    },
    {
      rule_any = { class = { "Discord", "Element" } },
      properties = { tag = tagnames[8], floating = false },
    },
    {
      rule_any = { class = { "Code" } },
      properties = { tag = tagnames[3], floating = true },
    },
    {
      rule_any = { role = { "browser" } },
      properties = { floating = false },
    },
    {
      rule_any = { class = { "Microsoft Teams - Preview" } },
      properties = { tag = tagnames[5], floating = false },
    },
    {
      rule_any = { class = { "Evolution" } },
      properties = { tag = tagnames[6], floating = true },
    },
    {
      rule_any = { class = { "PanGPUI" } }, -- GlobalProtect
      properties = { floating = true, placement = awful.placement.top_right },
    },
  }
end

return rules
