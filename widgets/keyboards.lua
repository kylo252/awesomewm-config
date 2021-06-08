
local awful = require("awful")
local keyboard_layout = require("keyboard_layout")
local kbdcfg = keyboard_layout.kbdcfg({cmd = "setxkbmap -variant", type = "tui"})

kbdcfg.add_primary_layout("Swedish", "SE", "basic")
kbdcfg.add_primary_layout("Hack", "HA", "hack")

kbdcfg.bind()

-- Mouse bindings

-- local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
kbdcfg.widget:buttons(
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch_next() end),
                       awful.button({ }, 3, function () kbdcfg.menu:toggle() end))
)

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ "Mod4" }, "F1", function () kbdcfg.switch_next() end)
)

return kbdcfg.widget

