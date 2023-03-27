local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local icons = require "ui.icons"
local util = require "util"
local stl_util = require "remote.lualine.util"
local filetypes = require "remote.lualine.filetypes"

local add = stl_util.add
local highlighter = stl_util.highlighter
local separator = has "win32" and [[\]] or "/"
local text_hl = highlighter.sanitize "Winbar"

local default_options = {
  separator = pad(icons.misc.ChevronRight, "right"),
  maxlen = 60,
}

local get_relpath = function(winid, name, maxlen)
  local path = vim.fn.fnamemodify(name, ":~:.:h:p")
  if path == "" or path == "." then
    return ""
  else
    maxlen = math.min(maxlen, math.floor(0.4 * vim.fn.winwidth(winid)))
    path = path:gsub("/$", "") .. separator
    if #name > maxlen then return "" end
    return path
  end
end

local get_sections = function(path, fname, ext, sep)
  local parts = #path > 0 and vim.split(path, separator) or {}
  local segments = {}
  local section
  table.insert(parts, fname)
  for k, v in ipairs(parts) do
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if #segments == 0 then
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "both") }, true) .. add(text_hl, { v })
        else
          section = add(text_hl, { pad(v, "left") })
        end
      else
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "right") }, true) .. add(text_hl, { v })
        else
          section = add(text_hl, { v })
        end
      end
      table.insert(segments, section)
    end
  end
  return table.concat(segments, sep)
end

return function()
  local opts = default_options
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")

  if util.contains(filetypes.wb_suppressed, ft) then return " " end

  local name = vim.fn.expand(vim.fn.bufname(buf))
  local fname = (name):match(("^.+%s(.+)$"):format(separator))
  local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
  local path = vim.startswith(bufid, "diffview") and "" or get_relpath(winid, name, opts.maxlen)
  local ext = vim.fn.fnamemodify(fname, ":e")
  return get_sections(path, fname, ext, opts.separator)
end
