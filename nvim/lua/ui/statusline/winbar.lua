local has_devicons, devicons = pcall(require, "nvim-web-devicons")

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

  local path = data.relpath { winid = win_id, buffer = bufnr, maxlen = 60, truncate = true }
  local fname = data.filename(bufnr)
  local ext = vim.fn.fnamemodify(fname, ":e")
  local fsep = has "win32" and [[\]] or "/"
  local parts = #path > 0 and vim.split(path, fsep) or {}
  local segments = {}
  local section

  table.insert(parts, fname)

  for k, v in ipairs(parts) do
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if #segments == 0 then
        if k == #parts and has_devicons then
          section = add(hi.winbar_icon(icon_hl), { pad(icon, "both") }, true) .. add(hi.winbar, { v })
        else
          section = add(hi.winbar, { pad(v, "left") })
        end
      else
        if k == #parts and has_devicons then
          section = add(hi.winbar_icon(icon_hl), { pad(icon, "right") }, true) .. add(hi.winbar, { v })
        else
          section = add(hi.winbar, { v })
        end
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
        .. add(hi.winbar_icon(("NavicIcons%s"):format(symbol.type)), { symbol.icon }, true)
        .. add(hi.winbar, { symbol.name })
    else
      section = add(hi.winbar_icon(("NavicIcons%s"):format(symbol.type)), { symbol.icon }, true)
        .. add(hi.winbar, { symbol.name })
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
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost" }, {
    group = "winbar",
    callback = function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft, bt = vim.bo[buf].filetype, vim.bo[buf].buftype
        local is_diff = vim.wo[win].diff
        if
          not is_diff
          and not vim.tbl_contains(views.basic, ft)
          and not vim.tbl_contains(views.plugins, ft)
          and vim.fn.win_gettype(win) == ""
          and bt == ""
          and ft ~= ""
        then
          vim.wo[win].winbar = [[%{%v:lua.require("ui.statusline.winbar").focus()%}]]
        elseif is_diff or vim.tbl_contains(views.basic, ft) or vim.tbl_contains(views.plugins, ft) then
          vim.wo[win].winbar = nil
        end
      end
    end,
  })
end

return M
