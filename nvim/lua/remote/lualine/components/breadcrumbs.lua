local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
local diffview_ok, diffview = pcall(require, "diffview.lib")

local icons = require "ui.icons"
local util = require "remote.lualine.util"
local add = util.add
local highlighter = util.highlighter

local default_options = {
  separator = pad(icons.misc.ChevronRight, "right"),
  maxlen = 60,
}

local separator = has "win32" and [[\]] or "/"
local txt_hl = highlighter.sanitize "Winbar"
local reset_hl = highlighter.reset

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

local get_file_sections = function(path, fname, ext, sep)
  local parts = #path > 0 and vim.split(path, separator) or {}
  local segments = {}
  local section

  table.insert(parts, fname)

  for k, v in ipairs(parts) do
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if #segments == 0 then
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "both") }, true) .. add(txt_hl, { v })
        else
          section = add(txt_hl, { pad(v, "left") })
        end
      else
        if k == #parts and devicons_ok then
          section = add(highlighter.sanitize(icon_hl), { pad(icon, "right") }, true) .. add(txt_hl, { v })
        else
          section = add(txt_hl, { v })
        end
      end
      table.insert(segments, section)
    end
  end
  return table.concat(segments, sep)
end

local get_diff_section = function(bufnr)
  return add(highlighter.sanitize "Title", { vim.api.nvim_buf_get_var(bufnr, "diffview_label") }, true)
end

return function()
  local opts = default_options
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local name = vim.fn.bufname(buf)
  local fname = (name):match(("^.+%s(.+)$"):format(separator))
  local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
  local is_diff = vim.startswith(bufid, "diffview")
  local path = is_diff and "" or get_relpath(winid, name, opts.maxlen)
  local ext = vim.fn.fnamemodify(fname, ":e")
  local file_sections = get_file_sections(path, fname, ext, opts.separator)
  if is_diff and diffview_ok and diffview.get_current_view() then
    local diff_section = get_diff_section(buf)
    return string.format("%s%s%s%s", diff_section, diff_section and "" or " ", file_sections, reset_hl)
  end
  return string.format("%s%s", file_sections, reset_hl)
end
