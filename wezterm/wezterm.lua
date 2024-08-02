---@diagnostic disable: inject-field
local wezterm = require "wezterm" --[[@as wezterm]]
local config = wezterm.config_builder()

require("tabs").setup(config)

config.keys = {
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}
if wezterm.target_triple:find "windows" then
  local launch_menu = {}
  local wsl_domains = wezterm.default_wsl_domains()

  if #wsl_domains > 0 then
    for _, dom in ipairs(wsl_domains) do
      dom.default_cwd = "~"
    end
    config.default_domain = wsl_domains[1].name
  end

  table.insert(launch_menu, {
    label = "PowerShell",
    args = { "pwsh.exe", "-NoLogo" },
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

  config.launch_menu = launch_menu
end

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.automatically_reload_config = true

config.audible_bell = "Disabled"
config.debug_key_events = true
config.max_fps = 144

---@diagnostic disable-next-line: inject-field
config.color_scheme_dirs = { wezterm.home_dir .. "/colors" }
config.color_scheme = "kdark"
wezterm.add_to_config_reload_watch_list(config.color_scheme_dirs[1] .. config.color_scheme .. ".toml")

config.font = wezterm.font_with_fallback {
  { family = "Cartograph CF", weight = "Light" },
  { family = "Symbols Nerd Font" },
  { family = "LegacyComputing" },
}
config.font_shaper = "Harfbuzz"
config.font_size = 10
config.cursor_thickness = 4
config.cell_width = 1.00
config.line_height = 1.20
config.underline_position = -5
config.underline_thickness = 2

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.enable_kitty_keyboard = true
config.adjust_window_size_when_changing_font_size = false

config.window_decorations = "RESIZE"
config.window_padding = {
  left = 2,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "Close"

config.hyperlink_rules = {
  { regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b", format = "$0" },
  { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
  { regex = [[\bfile://\S*\b]], format = "$0" },
  { regex = [[\b[tT](\d+)\b]], format = "https://example.com/tasks/?t=$1" },
  { regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = "https://www.github.com/$1/$3" },
  { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" },
}

return config
