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
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local capi = {button = button}
local clickable_container = require('widgets.clickable-container')
local modkey = require('keys').modkey

-- define module table
local tag_list = {}


-- ===================================================================
-- Widget Creation Functions
-- ===================================================================

local theme = require("themes.pastel-theme")
theme.taglist_font                        = "FontAwesome 24"
theme.taglist_fg_focus                    = "#98c379"
theme.taglist_fg_urgent                   = "#CC9393"

awful.util.tagnames  = {
  "",
  "",
  "",
  "",
  "",
  "",
  "",
}

awful.tag(awful.util.tagnames, s, awful.layout.suit.tile)

-- create the tag list widget
tag_list.create = function(s, chosen_layout)
   return awful.widget.taglist(
      s,
      awful.widget.taglist.filter.all,
      awful.util.table.join(
         awful.button({}, 1,
            function(t)
               t:view_only()
            end
         ),
         awful.button({modkey}, 1,
            function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
                  t:view_only()
               end
            end
         ),
         awful.button({}, 3,
            awful.tag.viewtoggle
         ),
         awful.button({modkey}, 3,
            function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
            end
         ),
         awful.button({}, 4,
            function(t)
               awful.tag.viewprev(t.screen)
            end
         ),
         awful.button({}, 5,
            function(t)
               awful.tag.viewnext(t.screen)
            end
         )
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
