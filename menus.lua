-- {{{ Menu
local freedesktop = require("freedesktop")
local beautiful = require("beautiful")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.autofocus")

local awesome_menus = {}

local apps = require("apps")

awesome_menus.drop = {
  {
    "Hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "Manual", string.format("%s -e man awesome", apps.terminal) },
  { "Edit config", string.format("%s -e %s %s", apps.terminal, apps.editor, awesome.conffile) },
  { "Restart", awesome.restart },
  {
    "Quit",
    function()
      awesome.quit()
    end,
  },
}

awesome_menus.main = freedesktop.menu.build({
  before = {
    { "Awesome", awesome_menus.drop, beautiful.awesome_icon },
    -- other triads can be put here
  },
  after = {
    { "Open terminal", apps.terminal },
    -- other triads can be put here
  },
})

-- hide menu when mouse leaves it
awesome_menus.main.wibox:connect_signal("mouse::leave", function()
  awesome_menus.main:hide()
end)

-- }}}
return awesome_menus
