local wezterm = require "wezterm"

local launch_menu = {}
local default_prog = { "zsh" }
local term = "xterm-256color"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  default_prog = { "pwsh.exe", "-NoLogo" }
  table.insert(launch_menu, {
    label = "PowerShell",
    args = default_prog,
  })
  for _, vs in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files")) do
    local year = vs:gsub("Microsoft Visual Studio/", "")
    table.insert(launch_menu, {
      label = ("Developer Powershell for VS %s"):format(year),
      args = {
        "cmd.exe",
        "/k",
        ("C:/Program Files (x86)/%s/BuildTools/VC/Auxiliary/Build/vcvars64.bat"):format(vs),
      },
    })
  end
  local has_wsl, wsl_list, _ = wezterm.run_child_process { "wsl.exe", "-l" }
  if has_wsl then
    -- enforce utf8 | https://github.com/microsoft/WSL/issues/4607
    wsl_list = wezterm.utf16_to_utf8(wsl_list)
    default_prog = { "wsl.exe" }
    term = "wezterm"
    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
      if idx > 1 then
        local distro = line:gsub(" %(Default%)", "")
        local cmd = { label = distro, args = { "wsl.exe", "--distribution", distro } }
        table.insert(launch_menu, cmd)
      end
    end
  end
end

return {
  audible_bell = "Disabled",
  debug_key_events = true,
  max_fps = 144,

  automatically_reload_config = true,
  default_prog = default_prog,
  launch_menu = launch_menu,

  -- term = term,
  color_scheme_dirs = { "$HOME/.config/wezterm/colors" },
  color_scheme = "kdark",
  font = wezterm.font_with_fallback {
    { family = "CartographCF Nerd Font", weight = "Regular" },
  },
  font_shaper = "Harfbuzz",
  font_size = 10,
  cell_width = 1.00,
  line_height = 1.20,
  underline_position = -5,
  underline_thickness = 2,

  scrollback_lines = 3500,
  enable_scroll_bar = true,
  enable_kitty_keyboard = true,
  adjust_window_size_when_changing_font_size = false,

  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,
  show_tab_index_in_tab_bar = false,
  use_fancy_tab_bar = true,

  window_decorations = "RESIZE",
  window_padding = {
    left = 2,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_close_confirmation = "NeverPrompt",
  exit_behavior = "Close",

  hyperlink_rules = {
    { regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b", format = "$0" },
    { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
    { regex = [[\bfile://\S*\b]], format = "$0" },
    { regex = [[\b[tT](\d+)\b]], format = "https://example.com/tasks/?t=$1" },
    { regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = "https://www.github.com/$1/$3" },
  },

  keys = {
    {
      key = "w",
      mods = "CMD|SHIFT",
      action = wezterm.action.CloseCurrentTab { confirm = false },
    },
    {
      key = "w",
      mods = "CMD|SHIFT",
      action = wezterm.action.CloseCurrentPane { confirm = false },
    },
  },
}
