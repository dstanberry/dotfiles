---@diagnostic disable: inject-field, missing-fields, undefined-field, assign-type-mismatch
local wezterm = require "wezterm" --[[@as wezterm]]
local io = require "io"
local os = require "os"

local M = {}

M.primary_mod = "SHIFT|CTRL"
M.alternate_mod = "SHIFT|ALT"

---@param pane PaneObj
function M.is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find "n?vim"
end

---@param action "resize" | "move"
---@param mods string
---@param key string
---@param direction "Right" | "Left" | "Up" | "Down"
---@param ignore_process? boolean
function M.move_or_resize(action, mods, key, direction, ignore_process)
  local event = "SplitNav_" .. action .. "_" .. direction
  wezterm.on(event, function(win, pane)
    if M.is_nvim(pane) and not ignore_process then
      win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
    else
      if action == "resize" then
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

wezterm.on("edit-scrollback-in-nvim", function(win, pane)
  local text = pane:get_lines_as_escapes(pane:get_dimensions().scrollback_rows)
  local name = os.tmpname()
  local f = io.open(name, "w+")
  if f then
    f:write(text)
    f:flush()
    f:close()
  end
  win:perform_action(
    wezterm.action.SpawnCommandInNewWindow {
      args = { "nvim", "-c", [=["lua require('util.buffer').send_to_term()"]=], name },
    },
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

---@param config WeztermConfig
function M.setup(config)
  config.disable_default_key_bindings = true
  config.keys = {
    -- font
    { mods = M.primary_mod, key = "(", action = wezterm.action.DecreaseFontSize },
    { mods = M.primary_mod, key = ")", action = wezterm.action.IncreaseFontSize },
    -- scrollback
    { mods = M.primary_mod, key = "d", action = wezterm.action.ScrollByPage(0.5) },
    { mods = M.primary_mod, key = "e", action = wezterm.action.EmitEvent "edit-scrollback-in-nvim" },
    { mods = M.primary_mod, key = "f", action = wezterm.action.ScrollByPage(-0.5) },
    { mods = M.primary_mod, key = "t", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
    -- clipboard
    { mods = M.primary_mod, key = "c", action = wezterm.action.CopyTo "Clipboard" },
    { mods = M.primary_mod, key = "v", action = wezterm.action.PasteFrom "Clipboard" },
    -- panes
    { mods = M.primary_mod, key = "-", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { mods = M.primary_mod, key = "/", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
    { mods = M.primary_mod, key = "w", action = wezterm.action.CloseCurrentPane { confirm = false } },
    { mods = M.primary_mod, key = "z", action = wezterm.action.TogglePaneZoomState },
    M.move_or_resize("move", M.primary_mod, "h", "Left"),
    M.move_or_resize("move", M.primary_mod, "j", "Down"),
    M.move_or_resize("move", M.primary_mod, "k", "Up"),
    M.move_or_resize("move", M.primary_mod, "l", "Right"),
    -- TODO: investigate how to make this work
    -- M.move_or_resize("move", "CTRL", "h", "Left"),
    -- M.move_or_resize("move", "CTRL", "j", "Down"),
    -- M.move_or_resize("move", "CTRL", "k", "Up"),
    -- M.move_or_resize("move", "CTRL", "l", "Right"),
    M.move_or_resize("resize", M.alternate_mod, "h", "Right"),
    M.move_or_resize("resize", M.alternate_mod, "j", "Down"),
    M.move_or_resize("resize", M.alternate_mod, "k", "Up"),
    M.move_or_resize("resize", M.alternate_mod, "l", "Left"),
    M.move_or_resize("resize", "ALT", "h", "Right"),
    M.move_or_resize("resize", "ALT", "j", "Down"),
    M.move_or_resize("resize", "ALT", "k", "Up"),
    M.move_or_resize("resize", "ALT", "l", "Left"),
    -- misc
    { mods = M.primary_mod, key = "`", action = wezterm.action.ShowDebugOverlay },
    { mods = M.primary_mod, key = "p", action = wezterm.action.ActivateCommandPalette },
  }
  -- tabs
  if wezterm.target_triple:find "windows" then
    table.insert(
      config.keys,
      { mods = M.primary_mod, key = "1", action = wezterm.action.SpawnTab { DomainName = config.default_domain } }
    )
    table.insert(config.keys, {
      mods = M.primary_mod,
      key = "2",
      action = wezterm.action.SpawnCommandInNewTab {
        domain = { DomainName = "local" },
        args = { "pwsh.exe", "-WorkingDirectory", "~" },
      },
    })
  end
  table.insert(config.keys, { mods = M.primary_mod, key = "e", action = wezterm.action.ActivateTabRelative(-1) })
  table.insert(config.keys, { mods = M.primary_mod, key = "r", action = wezterm.action.ActivateTabRelative(1) })
end

return M
