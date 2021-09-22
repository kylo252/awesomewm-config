local wibox = require("wibox")
local kbdcfg = {}
kbdcfg.cmd = "xkb-switch -n"
local indicator_mode = "textbox"
kbdcfg.widget = wibox.widget.textbox()
-- kbdcfg.widget = wibox.widget.imagebox()

local function set_indicator(mode, layout)
  local indicator
  if mode == "textbox" then
    indicator = string.match(layout, "%((%a+)%)")
    -- indicator = layout
    kbdcfg.widget:set_text(indicator)
  else
    kbdcfg.widget.image = indicator
  end
end

kbdcfg.current = io.popen("xkb-switch"):read("*a")
set_indicator(indicator_mode, kbdcfg.current)
kbdcfg.switch = function()
  os.execute(kbdcfg.cmd)
  kbdcfg.current = io.popen("xkb-switch"):read("*a")
  set_indicator(indicator_mode, kbdcfg.current)
end

return kbdcfg
