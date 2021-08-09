

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
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local kbdcfg = require("widgets.keyboards")
local xrandr = require("xrandr")
local sharedtags = require('sharedtags')

-- local xrandr = require("xrandr")
-- local lain          = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")

local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/configuration/" .. "pastel" .. "/"
-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274

-- define module table
local keys = {}

-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================

-- Move given client to given direction
local function move_client(c, direction)
   -- If client is floating, move to edge
   if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
      local workarea = awful.screen.focused().workarea
      if direction == "up" then
         c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
      elseif direction == "down" then
         c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
      elseif direction == "left" then
         c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
      elseif direction == "right" then
         c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
      end
   -- Otherwise swap the client in the tiled layout
   elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
      if direction == "up" or direction == "left" then
         awful.client.swap.byidx(-1, c)
      elseif direction == "down" or direction == "right" then
         awful.client.swap.byidx(1, c)
      end
   else
      awful.client.swap.bydirection(direction, c, nil)
   end
end


-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end


-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end


-- ===================================================================
-- Mouse bindings
-- ===================================================================


-- Mouse buttons on the desktop
keys.desktopbuttons = gears.table.join(
   -- left click on desktop to hide notification
   awful.button({}, 1,
      function ()
         naughty.destroy_all_notifications()
      end
   ),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
)

-- -- Mouse buttons on the client
keys.clientbuttons = gears.table.join(

   -- Raise client
   awful.button({}, 1, function(c) client.focus = c c:raise() end),

--    -- Move and Resize Client
--    awful.button({modkey}, 1, awful.mouse.client.move),
--    awful.button({modkey}, 3, awful.mouse.client.resize)
-- )


    -- awful.button({ }, 1, function (c)
    --     c:emit_signal("request::activate", "mouse_click", {raise = true})
    -- end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
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
    awful.key({ altkey }, "p", function() os.execute(apps.scrot) end,
              {description = "take a screenshot", group = "launcher"}),

    awful.key({ modkey }, "p", function() awful.spawn(apps.screenshot) end,
              {description = "open flameshot", group = "launcher"}),

    awful.key({modkey}, "Return", function() awful.spawn(apps.terminal) end,
            {description = "open a terminal", group = "launcher"}),

    awful.key({modkey}, "i", function() awful.spawn(apps.terminalAlt) end,
            {description = "open alt terminal", group = "launcher"}),

    awful.key({modkey}, "space", function() awful.spawn(apps.launcher) end,
            {description = "rofi launcher", group = "launcher"}),

    awful.key({modkey}, "d", function() awful.spawn(apps.dlauncher) end,
            {description = "rofi drun launcher", group = "launcher"}),

    awful.key({modkey}, "Tab", function() awful.spawn(apps.windowrunner) end,
            {description = "rofi windowcd launcher", group = "launcher"}),

    awful.key({modkey}, "r", function() awful.spawn(apps.quickmenu) end,
            {description = "rofi menu", group = "launcher"}),

    awful.key({ modkey }, "g", function () awful.spawn(apps.browser) end,
            {description = "run browser", group = "launcher"}),

    awful.key({ modkey }, "e", function () awful.spawn(apps.filemanager) end,
            {description = "run file manager", group = "launcher"}),

    awful.key({modkey}, "t", function () awful.spawn(apps.translator) end,
            {description = "run translator", group = "launcher"}),

    awful.key({modkey, "Ctrl"}, "F12", function () awful.spawn(apps.power_manager) end,
            {description = "Power Manager", group = "launcher"}),

   -- =========================================
   -- GENERAL
   -- =========================================

    -- Show/hide wibox
    awful.key({ modkey }, "b",
        function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}
    ),

    -- Reload Awesome
    awful.key({modkey, "Control"}, "r",
       awesome.restart,
       {description = "reload awesome", group = "awesome"}
    ),

    -- Quit Awesome
    awful.key({modkey}, "F4",
       function()
          -- emit signal to show the exit screen
          awesome.emit_signal("show_exit_screen")
       end,
       {description = "toggle exit screen", group = "awesome"}
    ),

    -- Show help
    awful.key({ modkey }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- Non-empty tag browsing
    awful.key({ modkey, altkey }, "Left", function () awful.tag.viewprev() end,
            {description = "view  previous", group = "awesome"}),

    awful.key({ modkey, altkey }, "Right", function () awful.tag.viewnext() end,
            {description = "view  next", group = "awesome"}),

    -- X screen locker
    awful.key({ altkey, "control" }, "l", function () os.execute(scrlocker) end,
              {description = "lock screen", group = "awesome"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "awesome"}),


    -- x change_laoyout
    awful.key({ "Shift" }, "Shift_R", function () kbdcfg.switch() end,
              {description = "switch keyboard layout", group = "awesome"}),

   -- =========================================
   -- CLIENT FOCUSING
   -- =========================================

   -- Focus client by direction (arrow keys)
    awful.key({modkey}, "Down",
       function()
          awful.client.focus.bydirection("down")
          raise_client()
       end,
       {description = "focus down", group = "focus"}
    ),
    awful.key({modkey}, "Up",
       function()
          awful.client.focus.bydirection("up")
          raise_client()
       end,
       {description = "focus up", group = "focus"}
    ),
    awful.key({modkey}, "Left",
       function()
          awful.client.focus.bydirection("left")
          raise_client()
       end,
       {description = "focus left", group = "focus"}
    ),
    awful.key({modkey}, "Right",
       function()
          awful.client.focus.bydirection("right")
          raise_client()
       end,
       {description = "focus right", group = "focus"}
    ),

    -- Focus client by index (cycle through clients)
    awful.key({altkey}, "Tab", function() awful.client.focus.byidx(1) end,
       {description = "focus next by index", group = "focus"}),

    awful.key({altkey, "Shift"}, "Tab", function() awful.client.focus.byidx(-1) end,
       {description = "focus previous by index", group = "focus"}),

   -- Focus screen by index (cycle through screens)
    awful.key({modkey, "Control" }, "t", function() awful.screen.focus_relative(1) end,
        {description = "focus previous by index", group = "focus"}),

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
    awful.key({ modkey, "Control" }, "s",
      function ()
        awful.client.swap(awful.client.getmaster())
      end,
      {description = "move to master", group = "layout"}),
    awful.key({ modkey, altkey}, "s",
      function ()
        awful.client.move_to_screen()
      end,
      {description = "move to screen", group = "layout"}),

   -- Number of columns
   awful.key({altkey, "Shift"}, "j",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({altkey, "Shift"}, "k",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
   ),

    -- On-the-fly useless gaps change
    -- awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
    --     {description = "increment useless gaps", group = "layout"}),
    -- awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
    --     {description = "decrement useless gaps", group = "layout"}),
     awful.key({altkey, "Control"}, "m", function() xrandr.xrandr() end,
         {description = "change monitor layout", group = "layout"}),

     -- select next layout
     awful.key({altkey}, "space", function() awful.layout.inc(1) end,
         {description = "select next layout", group = "layout"}),

     -- select previous layout
     awful.key({altkey, "Shift"}, "space", function() awful.layout.inc(-1) end,
         {description = "select previous layout", group = "layout"})
)


-- ===================================================================
-- Client Key bindings
-- ===================================================================

keys.clientkeys = gears.table.join(

   -- Client resizing
   awful.key({modkey, "Control"}, "Down",
      function(c)
         resize_client(client.focus, "down")
      end
   ),
   awful.key({modkey, "Control"}, "Up",
      function(c)
         resize_client(client.focus, "up")
      end
   ),
   awful.key({modkey, "Control"}, "Left",
      function(c)
         resize_client(client.focus, "left")
      end
   ),
   awful.key({modkey, "Control"}, "Right",
      function(c)
         resize_client(client.focus, "right")
      end
   ),

   -- Move to edge or swap by direction
   awful.key({modkey, "Shift"}, "Down",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "Up",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "Left",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "Right",
      function(c)
         move_client(c, "right")
      end
   ),
   awful.key({modkey, "Shift"}, "j",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "k",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "h",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "l",
      function(c)
         move_client(c, "right")
      end
   ),

   -- toggle fullscreen
   awful.key({altkey, modkey}, "f",
      function(c)
         c.fullscreen = not c.fullscreen
      end,
      {description = "toggle fullscreen", group = "client"}
   ),
    -- restore minimized client
    awful.key({modkey, "Shift"}, "n",
       function()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
             client.focus = c
             c:raise()
          end
       end,
       {description = "restore minimized", group = "client"}
    ),
   -- close client
    awful.key({modkey}, "q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),

    -- Max-Min
    awful.key({modkey}, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({altkey}, "Return",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ altkey, "Shift" }, "Return",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ altkey, "Control"   }, "Return",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

    -- on top
    awful.key({ modkey, altkey }, "t", function (c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),

    awful.key({modkey}, "f",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

   -- =========================================
   -- FUNCTION KEYS
   -- =========================================
    -- change display settings
    -- awful.key({modkey, altkey}, "F11", function() xrandr.xrandr() end,
       -- {description = "Luanch display configuration", group = "hotkeys"}),

   -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
       function()
          awful.spawn("xbacklight -inc 10", false)
       end,
       {description = "+10%", group = "hotkeys"}
    ),
    awful.key({}, "XF86MonBrightnessDown",
       function()
          awful.spawn("xbacklight -dec 10", false)
       end,
       {description = "-10%", group = "hotkeys"}
    ),
    awful.key({}, "XF86PowerOff",
       function()
          -- emit signal to show the exit screen
          awesome.emit_signal("show_exit_screen")
       end,
       {description = "toggle exit screen", group = "hotkeys"}
    ),
    -- ALSA volume control
    awful.key({}, "XF86AudioRaiseVolume",
       function()
          awful.spawn("amixer -D pulse sset Master 5%+", false)
          awesome.emit_signal("volume_change")
       end,
       {description = "volume up", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioLowerVolume",
       function()
          awful.spawn("amixer -D pulse sset Master 5%-", false)
          awesome.emit_signal("volume_change")
       end,
       {description = "volume down", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioMute",
       function()
          awful.spawn("amixer -D pulse set Master 1+ toggle", false)
          awesome.emit_signal("volume_change")
       end,
       {description = "toggle mute", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioNext",
       function()
          awful.spawn("mpc next", false)
       end,
       {description = "next music", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioPrev",
       function()
          awful.spawn("mpc prev", false)
       end,
       {description = "previous music", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioPlay",
       function()
          awful.spawn("mpc toggle", false)
       end,
       {description = "play/pause music", group = "hotkeys"}
    )

)
   -- =========================================
   -- TAG BUTTONS
   -- =========================================

local tag_list = require("widgets.tag-list")
local tagnames = tag_list.names

-- Bind all key numbers to tags
for i = 1, 9 do
   keys.globalkeys = gears.table.join(keys.globalkeys,
      -- View tag
      awful.key({modkey}, "#" .. i + 9,
       function()
          local screen = awful.screen.focused()
          local tag = tagnames[i]
          if tag then
             sharedtags.viewonly(tag, screen)
          end
       end,
       {description = "view tag #"..i, group = "tag"}),
      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
        function ()
            local screen = awful.screen.focused()
            local tag = tagnames[i]
            if tag then
               sharedtags.viewtoggle(tag, screen)
            end
        end,
        {description = "toggle tag #" .. i, group = "tag"}),
      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = tagnames[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
           end
        end,
        {description = "move focused client to tag #"..i, group = "tag"}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = tagnames[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
        {description = "toggle focused client on tag #" .. i, group = "tag"})
   )
end

-- }}}
return keys
