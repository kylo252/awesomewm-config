--      ██╗   ██╗ ██████╗ ██╗     ██╗   ██╗███╗   ███╗███████╗
--      ██║   ██║██╔═══██╗██║     ██║   ██║████╗ ████║██╔════╝
--      ██║   ██║██║   ██║██║     ██║   ██║██╔████╔██║█████╗
--      ╚██╗ ██╔╝██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══╝
--       ╚████╔╝ ╚██████╔╝███████╗╚██████╔╝██║ ╚═╝ ██║███████╗
--        ╚═══╝   ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(56)
local offsety = dpi(300)
local screen = awful.screen.focused()
local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/volume/"
local clickable_container = require("widgets.clickable-container")

-- ===================================================================
-- Appearance & Functionality
-- ===================================================================
local M = {}

local volume_icon = wibox.widget({
  widget = wibox.widget.imagebox,
})

-- create the volume_adjust component
local volume_adjust = wibox({
  screen = awful.screen.focused(),
  x = screen.geometry.width - offsetx,
  y = (screen.geometry.height / 2) - (offsety / 2),
  width = dpi(48),
  height = offsety,
  shape = gears.shape.rounded_rect,
  visible = false,
  ontop = true,
})

local volume_bar = wibox.widget({
  widget = wibox.widget.progressbar,
  shape = gears.shape.rounded_bar,
  color = "#efefef",
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = 0,
})

local volume_widget = wibox.widget({
  {
    id = "icon",
    widget = wibox.widget.imagebox,
    resize = true,
  },
  layout = wibox.layout.fixed.horizontal,
})

local widget_button = clickable_container(wibox.container.margin(volume_widget, dpi(5), dpi(5), dpi(5), dpi(5)))
widget_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
  awful.spawn("pavucontrol")
end)))

function M.get_indicator()
  local indicator = icon_dir .. "volume.png"
  volume_widget.icon:set_image(indicator)
  return widget_button
end

function M.setup()
  volume_adjust:setup({
    layout = wibox.layout.align.vertical,
    {
      wibox.container.margin(volume_bar, dpi(14), dpi(20), dpi(20), dpi(20)),
      forced_height = offsety * 0.75,
      direction = "east",
      layout = wibox.container.rotate,
    },
    wibox.container.margin(volume_icon),
  })

  -- create a 4 second timer to hide the volume adjust
  -- component whenever the timer is started
  local hide_volume_adjust = gears.timer({
    timeout = 4,
    autostart = true,
    callback = function()
      volume_adjust.visible = false
    end,
  })

  -- show volume-adjust when "volume_change" signal is emitted
  awesome.connect_signal("volume_change", function()
    -- set new volume value
    awful.spawn.easy_async_with_shell(
      "amixer get Master | tail -n 1 | awk -F ' ' '{print $5}' | tr -d '[]%'",
      -- "amixer sget Master | grep 'Right:' | awk -F '[][]' '{print $2}'| sed 's/[^0-9]//g'",
      function(stdout)
        local volume_level = tonumber(stdout)
        volume_bar.value = volume_level
        if volume_level > 40 then
          volume_icon:set_image(icon_dir .. "volume.png")
        elseif volume_level > 0 then
          volume_icon:set_image(icon_dir .. "volume-low.png")
        else
          volume_icon:set_image(icon_dir .. "volume-off.png")
        end
      end,
      false
    )

    -- make volume_adjust component visible
    if volume_adjust.visible then
      hide_volume_adjust:again()
    else
      volume_adjust.visible = true
      hide_volume_adjust:start()
    end
  end)
end

return M
