local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local util = require "util"
local stl_util = require "remote.lualine.util"
local filetypes = require "remote.lualine.filetypes"

local add = stl_util.add
local highlighter = stl_util.highlighter

local generic_hl = highlighter.sanitize "Winbar"
local fname_hl = highlighter.sanitize "WinbarFilename"

local default_options = {
  separator = pad("/", "right"),
  maxlen = 60,
}

local get_relative_path = function(winid, dirpath, maxlen)
  local cwd = vim.fs.normalize(vim.loop.cwd())
  local relative = util.replace(dirpath, cwd, "")
  if relative == "" then return "" end
  maxlen = math.min(maxlen, math.floor(0.4 * vim.fn.winwidth(winid)))
  if #relative > maxlen then return "..." end
  return relative
end

local format_sections = function(path, fname, ext, sep)
  local parts = #path > 0 and vim.split(path, "/") or {}
  local segments = {}
  local section
  table.insert(parts, fname)
  for k, v in ipairs(parts) do
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if #segments == 0 then
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "both") }, true) .. add(fname_hl, { v })
        else
          section = add(generic_hl, { pad(v, "left") })
        end
      else
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "right") }, true) .. add(fname_hl, { v })
        else
          section = add(generic_hl, { v })
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

  local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local dirpath, filename = (filepath):match("^(.+)/(.+)$")
  local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
  local relative_path = vim.startswith(bufid, "diffview") and "" or get_relative_path(winid, dirpath, opts.maxlen)
  local ext = vim.fn.fnamemodify(filename, ":e")
  return format_sections(relative_path, filename, ext, opts.separator)
end
