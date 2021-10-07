-- vim: ft=lua tw=80
-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

-- Only allow symbols available in all Lua versions
std = "min"

-- The default config may set global variables
-- files["init.lua"].allow_defined_top = true

-- This file itself
files[".luacheckrc"].ignore = {"111", "112", "131"}

-- Global objects defined by the C code
read_globals = {
    "awesome",
    "button",
    "client",
    "dbus",
    "drawable",
    "drawin",
    "key",
    "keygrabber",
    "mousegrabber",
    "root",
    "selection",
    "tag",
    "window",
    -- Global settings.
    "modkey",
}

-- screen may not be read-only, because newer luacheck versions complain about
-- screen[1].tags[1].selected = true.
-- The same happens with the following code:
--   local tags = mouse.screen.tags
--   tags[7].index = 4
-- client may not be read-only due to client.focus.
globals = {
    "screen",
    "mouse",
    "client"
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
ignore = {
  "631", -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
}
