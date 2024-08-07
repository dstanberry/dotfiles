---@diagnostic disable: inject-field, missing-fields, undefined-field, assign-type-mismatch
local wezterm = require "wezterm" --[[@as wezterm]]

local M = {}

M.primary_mod = "SHIFT|CTRL"
M.alternate_mod = "ALT|CTRL"

local action = wezterm.action

---@param pane PaneObj
function M.is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find "n?vim"
end

---@param resize_or_move "resize" | "move"
---@param mods string
---@param key string
---@param direction "Right" | "Left" | "Up" | "Down"
---@param ignore_process? boolean
function M.split_or_resize(resize_or_move, mods, key, direction, ignore_process)
  local event = "SplitNav_" .. resize_or_move .. "_" .. direction
  wezterm.on(event, function(win, pane)
    if M.is_nvim(pane) and not ignore_process then
      win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
    else
      if resize_or_move == "resize" then
        win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
      else
        local panes = pane:tab():panes_with_info()
        local is_zoomed = false
        for _, p in ipairs(panes) do
          if p.is_zoomed then is_zoomed = true end
        end
        wezterm.log_info("is_zoomed: " .. tostring(is_zoomed))
        if is_zoomed then
          direction = direction == "Up" or direction == "Right" and "Next" or "Prev"
          wezterm.log_info("dir: " .. direction)
        end
        win:perform_action({ ActivatePaneDirection = direction }, pane)
        win:perform_action({ SetPaneZoomState = is_zoomed }, pane)
      end
    end
  end)
  return {
    key = key,
    mods = mods,
    action = wezterm.action.EmitEvent(event),
  }
end

---@param config WeztermConfig
function M.setup(config)
  config.disable_default_key_bindings = true
  config.keys = {
    -- font
    { mods = M.primary_mod, key = "(", action = action.DecreaseFontSize },
    { mods = M.primary_mod, key = ")", action = action.IncreaseFontSize },
    -- scrollback
    { mods = M.primary_mod, key = "f", action = action.ScrollByPage(-0.5) },
    { mods = M.primary_mod, key = "d", action = action.ScrollByPage(0.5) },
    { mods = M.primary_mod, key = "t", action = action.SpawnTab "CurrentPaneDomain" },
    -- clipboard
    { mods = M.primary_mod, key = "c", action = action.CopyTo "Clipboard" },
    { mods = M.primary_mod, key = "v", action = action.PasteFrom "Clipboard" },
    -- panes
    { mods = M.primary_mod, key = "-", action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { mods = M.primary_mod, key = "/", action = action.SplitVertical { domain = "CurrentPaneDomain" } },
    { mods = M.primary_mod, key = "w", action = action.CloseCurrentPane { confirm = false } },
    { mods = M.primary_mod, key = "z", action = action.TogglePaneZoomState },
    { mods = M.primary_mod, key = "d", action = action.ActivatePaneDirection "Previous" },
    { mods = M.primary_mod, key = "f", action = action.ActivatePaneDirection "Next" },
    M.split_or_resize("move", M.primary_mod, "h", "Left"),
    M.split_or_resize("move", M.primary_mod, "j", "Down"),
    M.split_or_resize("move", M.primary_mod, "k", "Up"),
    M.split_or_resize("move", M.primary_mod, "l", "Right"),
    M.split_or_resize("move", "CTRL", "h", "Left"),
    M.split_or_resize("move", "CTRL", "j", "Down"),
    M.split_or_resize("move", "CTRL", "k", "Up"),
    M.split_or_resize("move", "CTRL", "l", "Right"),
    M.split_or_resize("resize", M.alternate_mod, "h", "Right"),
    M.split_or_resize("resize", M.alternate_mod, "j", "Down"),
    M.split_or_resize("resize", M.alternate_mod, "k", "Up"),
    M.split_or_resize("resize", M.alternate_mod, "l", "Left"),
    M.split_or_resize("resize", "ALT", "h", "Right"),
    M.split_or_resize("resize", "ALT", "j", "Down"),
    M.split_or_resize("resize", "ALT", "k", "Up"),
    M.split_or_resize("resize", "ALT", "l", "Left"),
    -- misc
    { mods = M.primary_mod, key = "p", action = action.ActivateCommandPalette },
    { mods = M.primary_mod, key = "`", action = action.ShowDebugOverlay },
  }
  -- tabs
  if wezterm.target_triple:find "windows" then
    table.insert(
      config.keys,
      { mods = "SHIFT|CTRL", key = "1", action = wezterm.action.SpawnTab { DomainName = config.default_domain } }
    )
    table.insert(config.keys, {
      mods = "SHIFT|CTRL",
      key = "2",
      action = wezterm.action.SpawnCommandInNewTab {
        domain = { DomainName = "local" },
        args = { "pwsh.exe", "-WorkingDirectory", "~" },
      },
    })
  end
end

return M
