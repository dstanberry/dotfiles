local ok, gps = pcall(require, "nvim-gps")

local hi = require "ui.statusline.highlight"
local add = require("ui.statusline.helper").add
local data = require "ui.statusline.data"

local M = {}

if ok then
  gps.setup {
    icons = {
      ["class-name"] = " ",
      ["function-name"] = " ",
      ["method-name"] = " ",
      ["container-name"] = " ",
      ["tag-name"] = " ",
    },
  }
end

local separator = "› "

local get_filepath = function()
  if vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
    return ""
  end

  local win_id = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(win_id)

  local path = data.relpath(bufnr, 200)
  local fname = data.filename(bufnr)
  local fsep = has "win32" and [[\]] or "/"
  local parts = vim.split(path, fsep)
  local segments = {}
  local section

  table.insert(parts, fname)

  for _, s in ipairs(parts) do
    if #s > 0 then
      if #segments == 0 then
        section = add(hi.custom0, { " " .. s })
      else
        section = add(hi.custom0, { s })
      end
      table.insert(segments, section)
    end
  end

  return table.concat(segments, separator)
end

local get_symbols = function()
  if not ok or (gps and not gps.is_available()) then
    return ""
  end

  local symbols = gps.get_data()
  local segments = {}
  local depth = #symbols
  local section

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    if #segments == 0 then
      section = add(hi.custom0, { separator }, true)
        .. add(hi.custom2, { symbol.icon }, true)
        .. add(hi.custom0, { symbol.text })
    else
      section = add(hi.custom2, { symbol.icon }, true) .. add(hi.custom0, { symbol.text })
    end
    table.insert(segments, section)
  end

  return table.concat(segments, separator)
end

M.focus = function()
  local relpath = get_filepath()
  local symbols = get_symbols()
  local sep = symbols and "" or " "

  return string.format("%s%s%s%s", relpath, sep, symbols, hi.reset)
end

M.setup = function()
  vim.opt.winbar = [[%{%v:lua.require("ui.statusline.winbar").focus()%}]]
end

return M
