--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

---@diagnostic disable-next-line: undefined-global
local capi = { mouse = mouse, screen = screen, client = client, awesome = awesome, root = root }

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local task_list = require("widgets.task-list")
local tag_list = require("widgets.tag-list")

-- define module table
local top_panel = {}

-- ===================================================================
-- Bar Creation
-- ===================================================================

local spr = wibox.widget.textbox("   ")

top_panel.create = function(s)
  local panel = awful.wibar({
    screen = s,
    position = "top",
    ontop = true,
    -- height = beautiful.top_panel_height,
    height = dpi(30),
    width = s.geometry.width,
  })

  panel:setup({
    expand = "",
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      spr,
      tag_list.create(s),
      spr,
      task_list.create(s),
      spr,
    },
    { layout = wibox.layout.align.horizontal },
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.container.margin(wibox.widget.systray(), dpi(5), dpi(5), dpi(5), dpi(5)),
      require("widgets.keyboards"),
      require("widgets.bluetooth"),
      require("widgets.network")(),
      require("widgets.volume").get_indicator(),
      require("widgets.battery"),
      wibox.container.margin(require("widgets.layout-box"), dpi(5), dpi(5), dpi(5), dpi(5)),
      wibox.container.margin(require("widgets.calendar").create(s), dpi(5), dpi(5), dpi(5), dpi(5)),
    },
  })

  -- ===================================================================
  -- Functionality
  -- ===================================================================

  -- hide panel when client is fullscreen
  local function change_panel_visibility(client)
    if client.screen == s then
      panel.ontop = not client.fullscreen
    end
  end

  -- connect panel visibility function to relevant signals
  capi.client.connect_signal("property::fullscreen", change_panel_visibility)
  capi.client.connect_signal("focus", change_panel_visibility)
end

return top_panel
