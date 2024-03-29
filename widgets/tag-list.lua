--      ████████╗ █████╗  ██████╗     ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝     ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗    ██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║    ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝    ███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚═╝╚══════╝   ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================

local gears = require("gears")
local awful = require("awful")
local sharedtags = require("sharedtags")

local dpi = require("beautiful").xresources.apply_dpi

-- define module table
local tag_list = {}

-- ===================================================================
-- Widget Creation Functions
-- ===================================================================

local theme = require("themes.pastel.theme")

tag_list.names = sharedtags({
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
  { name = "", layout = awful.layout.suit.tile },
})

-- create the tag list widget
tag_list.create = function(s, chosen_layout)
  return awful.widget.taglist(
    s,
    awful.widget.taglist.filter.all,
    awful.util.table.join(
      awful.button({}, 1, function(t)
        t:view_only()
      end),
      awful.button({}, 3, awful.tag.viewtoggle)
    ),
    {
      font = theme.taglist_font,
      shape = gears.shape.rectangle,
      spacing = dpi(10),
      bg_focus = theme.bg_normal,
      fg_focus = theme.taglist_fg_focus,
      bg_urgent = theme.bg_normal,
      fg_urgent = theme.taglist_fg_urgent,
      bg_occupied = theme.bg_normal,
      fg_occupied = theme.fg_normal,
    },
    chosen_layout
  )
end

return tag_list
