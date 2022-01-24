--
--
--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local kbdcfg = require("widgets.keyboards")
local sharedtags = require("sharedtags")
local apps = require("apps")
local utils = require("utils")
local tagnames = require("widgets.tag-list").names
local awesome_menus = require("menus")

local hotkeys_popup = require("awful.hotkeys_popup")
-- require("awful.hotkeys_popup.keys")

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

-- local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
-- local cycle_prev = true -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local cyclefocus = require("cyclefocus")
-- define module table
local keys = {}

-- ===================================================================
-- Mouse bindings
-- ===================================================================

-- Mouse buttons on the desktop
keys.desktopbuttons = gears.table.join(
  -- left click on desktop to hide notification
  awful.button({}, 1, function()
    naughty.destroy_all_notifications()
  end),
  -- Extra mouse buttons
  awful.button({}, 3, function()
    awesome_menus.main:toggle()
  end)
)

-- -- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
  -- Raise client
  awful.button({}, 1, function(c)
    if c ~= awful.client.focus then
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),

  -- Move and Resize Client
  awful.button({ modkey }, 1, awful.mouse.client.raise),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================
keys.globalkeys = gears.table.join(
  -- =========================================
  -- LAUNCHER
  -- =========================================

  -- Take a screenshot
  -- https://github.com/lcpz/dots/blob/master/bin/screenshot
  awful.key({ altkey }, "p", function()
    os.execute(apps.scrot)
  end, {
    description = "take a screenshot",
    group = "launcher",
  }),

  awful.key({ modkey }, "p", function()
    awful.spawn(apps.screenshot)
  end, {
    description = "open flameshot",
    group = "launcher",
  }),

  awful.key({ modkey }, "Return", function()
    awful.spawn(apps.terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),

  awful.key({ modkey }, "i", function()
    awful.spawn(apps.terminalAlt)
  end, {
    description = "open alt terminal",
    group = "launcher",
  }),

  awful.key({ modkey }, "space", function()
    awful.spawn(apps.launcher)
  end, {
    description = "rofi launcher",
    group = "launcher",
  }),

  awful.key({ modkey }, "d", function()
    awful.spawn(apps.dlauncher)
  end, {
    description = "rofi drun launcher",
    group = "launcher",
  }),

  awful.key({ modkey }, "r", function()
    awful.spawn(apps.quickmenu)
  end, {
    description = "rofi menu",
    group = "launcher",
  }),

  awful.key({ modkey }, "g", function()
    awful.spawn(apps.brave)
    -- awful.spawn(apps.browser)
  end, {
    description = "run browser",
    group = "launcher",
  }),

  awful.key({ modkey, "Shift" }, "g", function()
    awful.spawn(apps.edge)
    -- awful.spawn(apps.browser_normal)
  end, {
    description = "run browser (normal)",
    group = "launcher",
  }),

  awful.key({ modkey }, "e", function()
    awful.spawn(apps.filemanager)
  end, {
    description = "run file manager",
    group = "launcher",
  }),

  awful.key({ modkey }, "t", function()
    awful.spawn(apps.translator)
  end, {
    description = "run translator",
    group = "launcher",
  }),

  awful.key({ modkey, "Ctrl" }, "F8", function()
    local default_profile = "zsh -c 'autorandr -c default'"
    awful.spawn(default_profile)
  end, {
    description = "switch to autorandr default profile",
    group = "launcher",
  }),

  awful.key({ modkey, "Ctrl" }, "F9", function()
    local projector_profile = "zsh -c 'autorandr -c projector'"
    awful.spawn(projector_profile)
  end, {
    description = "switch to autorandr projector profile",
    group = "launcher",
  }),

  awful.key({ modkey, "Ctrl" }, "F10", function()
    awful.spawn(apps.screen_manager)
  end, {
    description = "run screen manager",
    group = "launcher",
  }),

  awful.key({ modkey, "Ctrl" }, "F12", function()
    awful.spawn(apps.power_manager)
  end, {
    description = "Power Manager",
    group = "launcher",
  }),

  -- =========================================
  -- GENERAL
  -- =========================================

  -- Show/hide wibox
  awful.key({ modkey }, "b", function()
    for s in screen do
      s.mywibox.visible = not s.mywibox.visible
      if s.mybottomwibox then
        s.mybottomwibox.visible = not s.mybottomwibox.visible
      end
    end
  end, {
    description = "toggle wibox",
    group = "awesome",
  }),

  -- Reload Awesome
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

  -- Quit Awesome
  awful.key({ modkey }, "F4", function()
    -- emit signal to show the exit screen
    awesome.emit_signal("show_exit_screen")
  end, {
    description = "toggle exit screen",
    group = "awesome",
  }),

  -- Show help
  awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

  -- Non-empty tag browsing
  awful.key({ modkey, altkey }, "Left", function()
    awful.tag.viewprev()
  end, {
    description = "view  previous",
    group = "awesome",
  }),

  awful.key({ modkey, altkey }, "Right", function()
    awful.tag.viewnext()
  end, {
    description = "view  next",
    group = "awesome",
  }),

  awful.key({ modkey, altkey }, "h", function()
    awful.tag.viewprev()
  end, {
    description = "view  previous",
    group = "awesome",
  }),

  awful.key({ modkey, altkey }, "l", function()
    awful.tag.viewnext()
  end, {
    description = "view  next",
    group = "awesome",
  }),

  -- Dropdown application
  awful.key({ modkey }, "z", function()
    awful.screen.focused().quake:toggle()
  end, {
    description = "dropdown application",
    group = "awesome",
  }),

  -- x change keyboard layout
  awful.key({ "Shift" }, "Shift_R", function()
    kbdcfg.switch()
  end, {
    description = "switch keyboard layout",
    group = "awesome",
  }),

  -- =========================================
  -- CLIENT FOCUSING
  -- =========================================

  -- Focus client by direction (arrow keys)
  awful.key({ modkey }, "Down", function()
    awful.client.focus.bydirection("down")
    utils.raise_client()
  end, {
    description = "focus down",
    group = "focus",
  }),
  awful.key({ modkey }, "Up", function()
    awful.client.focus.bydirection("up")
    utils.raise_client()
  end, {
    description = "focus up",
    group = "focus",
  }),
  awful.key({ modkey }, "Left", function()
    awful.client.focus.bydirection("left")
    utils.raise_client()
  end, {
    description = "focus left",
    group = "focus",
  }),
  awful.key({ modkey }, "Right", function()
    awful.client.focus.bydirection("right")
    utils.raise_client()
  end, {
    description = "focus right",
    group = "focus",
  }),

  -- modkey+Tab: cycle through all clients.
  awful.key({ modkey }, "Tab", function()
    cyclefocus.cycle({ modifier = "Super_L" })
  end),
  -- modkey+Shift+Tab: backwards
  awful.key({ modkey, "Shift" }, "Tab", function()
    cyclefocus.cycle({ modifier = "Super_L" })
  end),

  -- awful.key({ altkey }, "Tab", function()
  --   awful.spawn(apps.windowrunner)
  -- end, {
  --   description = "rofi windowcd launcher",
  --   group = "launcher",
  -- }),

  -- Focus client by index (cycle through clients)

  awful.key({ altkey }, "Tab", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "focus",
  }),

  awful.key({ altkey, "Shift" }, "Tab", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "focus",
  }),

  -- Focus screen by index (cycle through screens)
  awful.key({ modkey, "Control" }, "t", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus previous by index",
    group = "focus",
  }),

  -- =========================================
  -- LAYOUT CONTROL
  -- =========================================

  -- Number of master clients
  -- awful.key({altkey}, "space",
  --    function()
  --       awful.tag.incnmaster( 1, nil, true)
  --    end,
  --    {description = "increase the number of master clients", group = "layout"}
  -- ),
  -- awful.key({altkey, "Shift"}, "space",
  --    function()
  --       awful.tag.incnmaster(-1, nil, true)
  --    end,
  --    {description = "decrease the number of master clients", group = "layout"}
  -- ),
  -- Layout control
  awful.key({ modkey, "Control" }, "s", function()
    awful.client.swap(awful.client.getmaster())
  end, {
    description = "move to master",
    group = "layout",
  }),
  awful.key({ modkey, altkey }, "s", function()
    awful.client.move_to_screen()
  end, {
    description = "move to screen",
    group = "layout",
  }),

  -- Number of columns
  awful.key({ altkey, "Shift" }, "j", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ altkey, "Shift" }, "k", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),

  -- select next layout
  awful.key({ altkey }, "space", function()
    awful.layout.inc(1)
  end, {
    description = "select next layout",
    group = "layout",
  }),

  -- select previous layout
  awful.key({ altkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous layout",
    group = "layout",
  })
)

-- ===================================================================
-- Client Key bindings
-- ===================================================================

keys.clientkeys = gears.table.join(

  -- Client resizing
  awful.key({ modkey, "Control" }, "Down", function(c)
    utils.resize_client(c.focus, "down")
  end),
  awful.key({ modkey, "Control" }, "Up", function(c)
    utils.resize_client(c.focus, "up")
  end),
  awful.key({ modkey, "Control" }, "Left", function(c)
    utils.resize_client(c.focus, "left")
  end),
  awful.key({ modkey, "Control" }, "Right", function(c)
    utils.resize_client(c.focus, "right")
  end),
  awful.key({ modkey, "Control" }, "j", function(c)
    utils.resize_client(c.focus, "down")
  end),
  awful.key({ modkey, "Control" }, "k", function(c)
    utils.resize_client(c.focus, "up")
  end),
  awful.key({ modkey, "Control" }, "h", function(c)
    utils.resize_client(c.focus, "left")
  end),
  awful.key({ modkey, "Control" }, "l", function(c)
    utils.resize_client(c.focus, "right")
  end),

  -- Move to edge or swap by direction
  awful.key({ modkey, "Shift" }, "Down", function(c)
    utils.move_client(c, "down")
  end),
  awful.key({ modkey, "Shift" }, "Up", function(c)
    utils.move_client(c, "up")
  end),
  awful.key({ modkey, "Shift" }, "Left", function(c)
    utils.move_client(c, "left")
  end),
  awful.key({ modkey, "Shift" }, "Right", function(c)
    utils.move_client(c, "right")
  end),
  awful.key({ modkey, "Shift" }, "j", function(c)
    utils.move_client(c, "down")
  end),
  awful.key({ modkey, "Shift" }, "k", function(c)
    utils.move_client(c, "up")
  end),
  awful.key({ modkey, "Shift" }, "h", function(c)
    utils.move_client(c, "left")
  end),
  awful.key({ modkey, "Shift" }, "l", function(c)
    utils.move_client(c, "right")
  end),

  -- toggle fullscreen
  awful.key({ altkey, modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
  end, {
    description = "toggle fullscreen",
    group = "client",
  }),
  -- restore minimized client
  awful.key({ modkey, "Shift" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      client.focus = c
      c:raise()
    end
  end, {
    description = "restore minimized",
    group = "client",
  }),
  -- close client
  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, { description = "close", group = "client" }),

  -- Max-Min
  awful.key({ modkey }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, {
    description = "minimize",
    group = "client",
  }),
  awful.key({ altkey }, "Return", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, {
    description = "(un)maximize",
    group = "client",
  }),
  awful.key({ altkey, "Shift" }, "Return", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, {
    description = "(un)maximize vertically",
    group = "client",
  }),
  awful.key({ altkey, "Control" }, "Return", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, {
    description = "(un)maximize horizontally",
    group = "client",
  }),

  -- on top
  awful.key({ modkey, altkey }, "t", function(c)
    c.ontop = not c.ontop
  end, {
    description = "toggle keep on top",
    group = "client",
  }),

  awful.key({ modkey }, "f", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),

  -- =========================================
  -- FUNCTION KEYS
  -- =========================================
  -- change display settings
  -- awful.key({modkey, altkey}, "F11", function() xrandr.xrandr() end,
  -- {description = "Luanch display configuration", group = "hotkeys"}),

  -- Brightness
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn("xbacklight -inc 10", false)
  end, {
    description = "+10%",
    group = "hotkeys",
  }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("xbacklight -dec 10", false)
  end, {
    description = "-10%",
    group = "hotkeys",
  }),
  awful.key({}, "XF86PowerOff", function()
    -- emit signal to show the exit screen
    awesome.emit_signal("show_exit_screen")
  end, {
    description = "toggle exit screen",
    group = "hotkeys",
  }),
  -- ALSA volume control
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn("amixer -Mq set Master,0 5%+ unmute", false)
    awesome.emit_signal("volume_change")
  end, {
    description = "volume up",
    group = "hotkeys",
  }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn("amixer -Mq set Master,0 5%- unmute", false)
    awesome.emit_signal("volume_change")
  end, {
    description = "volume down",
    group = "hotkeys",
  }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn("amixer -q set Master toggle", false)
    awesome.emit_signal("volume_change")
  end, {
    description = "toggle mute",
    group = "hotkeys",
  }),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn("mpc next", false)
  end, {
    description = "next music",
    group = "hotkeys",
  }),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn("mpc prev", false)
  end, {
    description = "previous music",
    group = "hotkeys",
  }),
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn("mpc toggle", false)
  end, {
    description = "play/pause music",
    group = "hotkeys",
  })
)
-- =========================================
-- TAG BUTTONS
-- =========================================

-- Bind all key numbers to tags
for i = 1, 9 do
  keys.globalkeys = gears.table.join(
    keys.globalkeys,
    -- View tag
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = tagnames[i]
      if tag then
        sharedtags.viewonly(tag, screen)
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = tagnames[i]
      if tag then
        sharedtags.viewtoggle(tag, screen)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = tagnames[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }),
    -- Move client to shared.
    awful.key({ modkey, "Shift" }, "s", function()
      if client.focus then
        local tag = tagnames[8]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to shared tag",
      group = "client",
    }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = tagnames[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, {
      description = "toggle focused client on tag #" .. i,
      group = "tag",
    })
  )
end

-- }}}
return keys
