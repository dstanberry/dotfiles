local add = require("ui.statusline.helper").add
local highlighter = require "ui.statusline.highlighter"
local icons = require "ui.icons"

local M = {}

local txt_hl = highlighter.sanitize "Winbar"
local reset_hl = highlighter.reset

local function get_ft_name(ft)
  local name = ft
  local split = vim.split(ft, "_", { plain = true })
  if #split == 1 then
    split = vim.split(ft, "-", { plain = true })
    if #split == 2 then name = (split[2]):upper() end
  elseif #split == 2 then
    name = (split[2]):gsub("^%l", string.upper)
  end
  return "DAP " .. name
end

local function statusline_label(options) return get_ft_name(options.filetype) end

local function winbar_label(options)
  local name = get_ft_name(options.filetype)
  local icon = icons.misc.Square
  icon = add(txt_hl, { pad(icons.debug[vim.split(name, " ")[2]], "left") }, true)
  name = add(txt_hl, { name })
  return string.format("%s %s%s", icon, name, reset_hl)
end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = statusline_label, highlight = "mode" },
  },
  right = {},
}

M.winbar = {
  right = {
    { component = winbar_label },
  },
}

M.filetypes = {
  -- "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
}

return M
