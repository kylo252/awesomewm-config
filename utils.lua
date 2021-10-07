local M = {}
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================

-- Move given client to given direction
function M.move_client(c, direction)
  -- If client is floating, move to edge
  if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
    local workarea = awful.screen.focused().workarea
    if direction == "up" then
      c:geometry({ nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil })
    elseif direction == "down" then
      c:geometry({
        nil,
        y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2,
        nil,
        nil,
      })
    elseif direction == "left" then
      c:geometry({ x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil })
    elseif direction == "right" then
      c:geometry({
        x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2,
        nil,
        nil,
        nil,
      })
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

function M.resize_client(c, direction)
  -- Resize client in given direction
  local floating_resize_amount = dpi(20)
  local tiling_resize_factor = 0.05
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
function M.raise_client()
  if client.focus then
    client.focus:raise()
  end
end

function M.run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.easy_async_with_shell(
    string.format("pgrep -u $USER -x %s > /dev/null || %s", findme, cmd),
    function(stderr)
      -- Debugger
      if not stderr or stderr == "" or not debug_mode then
        return
      end
      naughty.notification({
        app_name = "Start-up Applications",
        title = "<b>Oof! Error detected when starting an application!</b>",
        message = stderr:gsub("%\n", ""),
        timeout = 20,
        icon = require("beautiful").awesome_icon,
      })
    end
  )
end

function M.set_wallpaper(s)
  -- Wallpaper
  local wallpaper = os.getenv("HOME") .. "/Pictures/wallpapers/nebula.jpg"

  -- If wallpaper is a function, call it with the screen
  if type(wallpaper) == "function" then
    wallpaper = wallpaper(s)
  end
  gears.wallpaper.maximized(wallpaper, s, true)
end

return M
