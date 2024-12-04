---@diagnostic disable: inject-field
local wezterm = require "wezterm" --[[@as wezterm]]
local tabs = require "tabs"
local keys = require "keys"
local config = wezterm.config_builder()

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
}
config.font_size = 10
config.default_cursor_style = "SteadyBlock"
config.cursor_thickness = 1
config.cell_width = 1.00
config.line_height = 1.07
config.underline_position = -5
config.underline_thickness = 2
config.command_palette_font_size = 12

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.enable_kitty_keyboard = true
config.adjust_window_size_when_changing_font_size = false

config.window_decorations = "RESIZE"
config.window_padding = {
  left = 2,
  right = 0,
  top = 10,
  bottom = 1,
}

if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  config.command_palette_font_size = 14
  config.font_size = 14
  config.line_height = 1.05
end

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

config.alternate_buffer_wheel_scroll_speed = 1
config.bypass_mouse_reporting_modifiers = "SHIFT"
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    action = wezterm.action.CompleteSelection "ClipboardAndPrimarySelection",
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor "ClipboardAndPrimarySelection",
  },
}

tabs.setup(config)
keys.setup(config)

return config
