--      ██████╗  █████╗ ███████╗████████╗███████╗██╗
--      ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║
--      ██████╔╝███████║███████╗   ██║   █████╗  ██║
--      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  ██║
--      ██║     ██║  ██║███████║   ██║   ███████╗███████╗
--      ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")

local pastel = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================


pastel.initialize = function()
   -- Import components
   require("components.pastel.wallpaper")
   require("components.exit-screen")
   require("components.volume-adjust")

   -- Import panels
   local left_panel = require("components.pastel.left-panel")
   local top_panel = require("components.pastel.top-panel")
   local slide_panel = require("components.pastel.slide-panel")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      -- Only add the left panel on the primary screen
      -- if s.index == 1 then
      -- left_panel.create(s)
      -- end
      -- slide_panel.create(s)

      -- Add the top panel to every screen
      top_panel.create(s)
   end)
end

return pastel
