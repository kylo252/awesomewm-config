local wibox = require("wibox")
local kbdcfg = {}
kbdcfg.cmd = "xkb-switch -n"
kbdcfg.widget = wibox.widget.textbox()

kbdcfg.update_indicator = function(layout)
  layout = type(layout) == "string" and layout or ""
  local variant = string.match(layout, "%((%a+)%)")
  local name = string.match(layout, "%a+")
  -- only indicate unique variants
  local indicator = variant ~= "basic" and layout or name
  kbdcfg.widget:set_text(indicator)
end

local initial_layout = io.popen("xkb-switch"):read("*l")
kbdcfg.update_indicator(initial_layout)

kbdcfg.switch = function()
  os.execute(kbdcfg.cmd)
  local layout = io.popen("xkb-switch"):read("*l")
  kbdcfg.update_indicator(layout)
end

return kbdcfg
