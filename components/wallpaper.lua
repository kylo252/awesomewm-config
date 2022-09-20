--      ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
--      ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
--      ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
--      ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
--      ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--       ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝

-- ===================================================================
-- Imports
-- ===================================================================

---@diagnostic disable-next-line: undefined-global
local capi = { mouse = mouse, screen = screen, client = client, awesome = awesome, root = root }

local awful = require("awful")
local naughty = require("naughty")
local tag = require("awful.tag")

-- ===================================================================
-- Initialization
-- ===================================================================

local is_blurred = false

local wallpaper_dir = os.getenv("HOME") .. "/Pictures/wallpapers"
local wallpaper = wallpaper_dir .. "/nebula.jpg"
local blurred_wallpaper = wallpaper_dir .. "/blurred-nebula.png"

awful.spawn.with_shell("feh --bg-fill " .. wallpaper)

--- Check if a file or directory exists in this path
local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

-- check if blurred wallpaper needs to be created
if not exists(blurred_wallpaper) then
  naughty.notify({
    preset = naughty.config.presets.normal,
    title = "Wallpaper",
    text = "Generating blurred wallpaper...",
  })
  -- uses image magick to create a blurred version of the wallpaper
  awful.spawn.with_shell("convert -filter Gaussian -blur 0x30 " .. wallpaper .. " " .. blurred_wallpaper)
end

-- ===================================================================
-- Functionality
-- ===================================================================

-- changes to blurred wallpaper
local function blur()
  if not is_blurred then
    awful.spawn.with_shell("feh --bg-fill " .. blurred_wallpaper)
    is_blurred = true
  end
end

-- changes to normal wallpaper
local function unblur()
  if is_blurred then
    awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
    is_blurred = false
  end
end

-- blur / unblur on tag change
tag.connect_signal("property::selected", function(t)
  -- check if tag has any clients
  for _ in pairs(t:clients()) do
    blur()
    return
  end
  -- unblur if tag has no clients
  unblur()
end)

-- check if wallpaper should be blurred on client open
capi.client.connect_signal("manage", function(_)
  blur()
end)

-- check if wallpaper should be unblurred on client close
capi.client.connect_signal("unmanage", function(_)
  local t = awful.screen.focused().selected_tag
  -- check if tag has any clients
  for _ in pairs(t:clients()) do
    return
  end
  -- unblur if tag has no clients
  unblur()
end)
