local data = require "ui.statusline.data"
local hi = require "ui.statusline.highlight"
local views = require "ui.statusline.views"
local add = require("ui.statusline.helper").add
local icons = require "ui.icons"
local navic = require "remote.navic"

local M = {}

local separator = pad(icons.misc.ChevronRight, "right")

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
        section = add(hi.winbar, { pad(s, "left") })
      else
        section = add(hi.winbar, { s })
      end
      table.insert(segments, section)
    end
  end

  return table.concat(segments, separator)
end

local get_symbols = function()
  if not navic.is_available() then
    return ""
  end

  local symbols = navic.get_data()

  if symbols == nil then
    return ""
  end

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
      section = add(hi.winbar, { separator }, true)
        .. add(hi.winbar_icon, { symbol.icon }, true)
        .. add(hi.winbar, { symbol.name })
    else
      section = add(hi.winbar_icon, { symbol.icon }, true) .. add(hi.winbar, { symbol.name })
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
  vim.api.nvim_create_augroup("winbar", { clear = true })

  -- disabled until https://github.com/neovim/neovim/issues/19458 is resolved upstream
  --   vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost" }, {
  --     group = "winbar",
  --     callback = function()
  --       if
  --         vim.bo.filetype == ""
  --         or vim.tbl_contains(views.basic, vim.bo.filetype)
  --         or vim.tbl_contains(views.plugins, vim.bo.filetype)
  --       then
  --         vim.opt_local.winbar = ""
  --         return
  --       end
  --       vim.opt_local.winbar = [[%{%v:lua.require("ui.statusline.winbar").focus()%}]]
  --     end,
  --   })
end

return M
