local ok, gps = pcall(require, "nvim-gps")

local hi = require "ui.statusline.highlight"
local add = require("ui.statusline.helper").add

local M = {}

gps.setup {
  icons = {
    ["class-name"] = " ",
    ["function-name"] = " ",
    ["method-name"] = " ",
    ["container-name"] = " ",
    ["tag-name"] = " ",
  },
}

M.focus = function()
  if not ok or vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
    return ""
  end

  if not gps.is_available() then
    return ""
  end

  local symbols = gps.get_data()
  local parts = {}
  local depth = #symbols
  local separator = "› "
  local section

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    if #parts == 0 then
      section = add(hi.custom2, { " " .. symbol.icon }, true) .. add(hi.custom0, { symbol.text })
    else
      section = add(hi.custom2, { symbol.icon }, true) .. add(hi.custom0, { symbol.text })
    end
    table.insert(parts, section)
  end

  return table.concat(parts, separator) .. hi.reset
end

M.setup = function()
  vim.opt.winbar = [[%{%v:lua.require("ui.statusline.winbar").focus()%}]]
end

M.focus()

return M
