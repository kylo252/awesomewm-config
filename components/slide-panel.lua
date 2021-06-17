

-- ===================================================================
-- Initialization
-- ===================================================================


local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local gears = require("gears")

local slidebar = require('slidebar')
local tag_list = require("widgets.tag-list")
local separator = require("widgets.horizontal-separator")
local folder = require("widgets.folder")
-- local theme = require("custom-theme")
local home_dir = os.getenv("HOME")

local slide_panel = {}
slide_panel.create = function(s)
-- function slidebar_create(s)
 -- Create myslidebar instead of 'mywibox'
    s.myslidebar = slidebar {
    	screen = s,
    -- bg = "#282a36",
        position = "left",
    size = 60,
    size_activator = 5,
    -- show_delay = 0.5,
    hide_delay = 1,
    easing = 2,
    -- delta = 1,
	}
 
    -- Add widgets to the slidebar
    s.myslidebar:setup {
        layout = wibox.layout.align.vertical,
        {
            layout = wibox.layout.fixed.vertical,
            -- add taglist widget
        },
        {    -- add folders widgets
            -- folder.create(home_dir),
            separator,
            separator,
            separator,
            tag_list.create(s, wibox.layout.fixed.vertical()),
            layout = wibox.layout.fixed.vertical,
       },
       {
            folder.create(home_dir),
            folder.create(home_dir .. "/Documents"),
            folder.create(home_dir .. "/Downloads"),
            folder.create("trash://"),
            layout = wibox.layout.fixed.vertical,
       },
    }
end

return slide_panel
