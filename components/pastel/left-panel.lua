--      ██╗     ███████╗███████╗████████╗    ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ██║     ██╔════╝██╔════╝╚══██╔══╝    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--      ██║     █████╗  █████╗     ██║       ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--      ██║     ██╔══╝  ██╔══╝     ██║       ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--      ███████╗███████╗██║        ██║       ██║     ██║  ██║██║ ╚████║███████╗███████╗
--      ╚══════╝╚══════╝╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

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

-- define module table
local left_panel = {}

local default_panel_width = beautiful.left_panel_width
local docked_panel_width = dpi(8)

-- ===================================================================
-- Bar Creation
-- ===================================================================
function vertical_wibox_config(s)

    -- Create the vertical wibox
    s.dockheight = (55 *  s.workarea.height)/100
    if s.index > 1 and panel.y == 0 then
        panel.y = screen[1].myleftwibox.y
    end

    panel = wibox({
        screen = s,
        x=0,
        y=s.workarea.height/2 - s.dockheight/2,
        -- width = dpi(6),
        width = beautiful.left_panel_width,
        height = s.dockheight,
        -- fg = theme.fg_normal,
        -- bg = barcolor2,
        ontop = true,
        visible = true,
        type = "dock",
--     })
--    panel = awful.wibar({
        shape = default_panel_shape
   })
    -- Add widgets to the vertical wibox
    panel:setup {
        expand = "none",
        layout = wibox.layout.align.vertical,
        nil,
        {
            layout = wibox.layout.fixed.vertical,
            -- add taglist widget
            tag_list.create(s, wibox.layout.fixed.vertical()),
            -- add folders widgets
         {
            separator,
            folder.create(home_dir),
            folder.create(home_dir .. "/Documents"),
            folder.create(home_dir .. "/Downloads"),
            separator,
            folder.create("trash://"),
            layout = wibox.layout.fixed.vertical,
         }
        },
        nil
    }

    tag.connect_signal("property::selected", function(t)
        local s = t.screen or awful.screen.focused()
        panel.width = default_panel_width
        s.layoutb.visible = true
        if not s.docktimer.started then
            s.docktimer:start()
        end
    end)

    panel:connect_signal("mouse::enter", function()
        panel.width = default_panel_width
        s.layoutb.visible = true
    end)

    s.docktimer = gears.timer{ timeout = 2 }
    s.docktimer:connect_signal("timeout", function()
        local s = awful.screen.focused()
        panel.width = docked_panel_width
        s.layoutb.visible = false
        if s.docktimer.started then
            s.docktimer:stop()
        end
    end)

    panel:connect_signal("mouse::leave", function()
        panel.width = docked_panel_width
        s.layoutb.visible = false
    end)
end


left_panel.create = function(s)
 
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.layoutb = wibox.container.margin(s.mylayoutbox, dpi(8), dpi(11), dpi(3), dpi(3))

    gears.timer.delayed_call(vertical_wibox_config, s)
end

return left_panel
