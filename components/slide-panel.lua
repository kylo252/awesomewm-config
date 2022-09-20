-- ===================================================================
-- Initialization
-- ===================================================================
local wibox = require("wibox")

local slidebar = require("slidebar")
local folder = require("widgets.folder")
-- local theme = require("custom-theme")
local home_dir = os.getenv("HOME")

local slide_panel = {}
slide_panel.create = function(s)
  -- function slidebar_create(s)
  -- Create myslidebar instead of 'mywibox'
  s.dockheight = (25 * s.workarea.height) / 100

  s.myslidebar = slidebar({
    screen = s,
    -- bg = "#282a36",
    position = "left",
    size = 60,
    size_activator = 5,
    -- show_delay = 0.5,
    hide_delay = 1,
    easing = 2,
    height_activator = s.dockheight,
    -- screen_height = s.dockheight,
    -- x=0,
    y = s.workarea.height / 2 - s.dockheight / 2,

    -- delta = 1,
  })

  -- Add widgets to the slidebar

  s.myslidebar:setup({
    layout = wibox.layout.align.vertical,
    {
      folder.create(home_dir),
      folder.create(home_dir .. "/Documents"),
      folder.create(home_dir .. "/Downloads"),
      folder.create("trash://"),
      layout = wibox.layout.fixed.vertical,
    },
  })
end

return slide_panel
