local awful = require("awful")
local wibox = require("wibox")
local kbdcfg = {}
kbdcfg.cmd = "xkb-switch -n"
kbdcfg.widget = wibox.widget.textbox()

kbdcfg.current = io.popen("xkb-switch"):read("*a")
kbdcfg.widget:set_text(kbdcfg.current)
kbdcfg.switch = function()
	os.execute(kbdcfg.cmd)
	kbdcfg.current = io.popen("xkb-switch"):read("*a")
	kbdcfg.widget:set_text(kbdcfg.current)
end

return kbdcfg
