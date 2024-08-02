local wezterm = require "wezterm" --[[@as wezterm]]

local M = {}

---@param tab MuxTabObj
---@param max_width number
function M.set_title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  local is_zoomed = false

  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then title = " " .. title end
  if tab.is_active then
    title = "❐ " .. title

    title = wezterm.truncate_right(title, max_width - 3)
    return "  " .. title .. "  "
  end
end

---@param config WeztermConfig
function M.setup(config)
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_bar_at_bottom = true
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
  config.use_fancy_tab_bar = false

  wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    local title = M.set_title(tab, max_width)
    return title
  end)
end

return M
