local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local icons = require "ui.icons"
local util = require "util"
local excludes = require "ui.excludes"
local stl_util = require "remote.lualine.util"

local add = stl_util.add
local highlighter = stl_util.highlighter

local generic_hl = highlighter.sanitize "Winbar"
local fname_hl = highlighter.sanitize "WinbarFilename"

local dap_icons = {
  ["DAP Breakpoints"] = pad(icons.debug.Breakpoints, "right"),
  ["DAP Scopes"] = pad(icons.debug.Scopes, "right"),
  ["DAP Stacks"] = pad(icons.debug.Stacks, "right"),
  ["DAP Watches"] = pad(icons.debug.Watches, "right"),
}

local get_relative_path = function(winid, dirpath)
  local cwd = vim.fs.normalize(vim.loop.cwd())
  local path = util.replace(dirpath, cwd, "")
  if path == "" then return "" end
  local limit = math.floor(0.4 * vim.fn.winwidth(winid))
  return #path > limit and "..." or path
end

local format_sections = function(path, fname, ext)
  local parts = path and vim.split(path, "/") or {}
  table.insert(parts, fname)
  local segments = util.map(function(segments, v, k)
    local section
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if fname:match "DAP" then icon = dap_icons[fname] or icon end
      if #segments == 0 then
        section = (k == #parts and devicons_ok)
            and add(highlighter.sanitize(icon_hl), { pad(icon, "both") }, true) .. add(fname_hl, { v })
          or add(generic_hl, { pad(v, "left") })
      else
        section = (k == #parts and devicons_ok)
            and add(highlighter.sanitize(icon_hl), { pad(icon, "right") }, true) .. add(fname_hl, { v })
          or add(generic_hl, { v })
      end
      table.insert(segments, section)
    end
    return segments
  end, parts)
  return table.concat(segments, pad("/", "right"))
end

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")

  if util.contains(excludes.ft.wb_empty, ft) then return " " end

  local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local dirpath, filename = (filepath):match "^(.+)/(.+)$"
  local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
  local relative_path = vim.startswith(bufid, "diffview") and "" or get_relative_path(winid, dirpath)
  local ext = vim.fn.fnamemodify(filename, ":e")
  return format_sections(relative_path, filename)
end
