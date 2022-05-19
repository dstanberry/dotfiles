-- verify aerial is available
local ok, aerial = pcall(require, "aerial")
if not ok then
  return
end

local hi = require "ui.statusline.highlight"
local add = require("ui.statusline.helper").add

local M = {}

M.focus = function()
  if vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
    return ""
  end

  local symbols = aerial.get_location(true)
  local parts = {}
  local depth = #symbols
  local separator = "> "
  local section

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    if #parts == 0 then
      section = add(hi.custom2, { " " .. symbol.icon }) .. add(hi.custom0, { symbol.name })
    else
      section = add(hi.custom2, { symbol.icon }) .. add(hi.custom0, { symbol.name })
    end
    table.insert(parts, section)
  end

  return table.concat(parts, separator) .. hi.reset
end

M.setup = function()
  vim.opt.winbar = [[%{%v:lua.require("ui.statusline.winbar").focus()%}]]
end

return M
