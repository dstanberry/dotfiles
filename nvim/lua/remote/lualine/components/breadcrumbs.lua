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
  ["DAP Breakpoints"] = ds.pad(icons.debug.Breakpoint, "right"),
  ["DAP Console"] = ds.pad(icons.debug.REPL, "right"),
  ["DAP Scopes"] = ds.pad(icons.debug.Scopes, "right"),
  ["DAP Stacks"] = ds.pad(icons.debug.Stacks, "right"),
  ["DAP Watches"] = ds.pad(icons.debug.Watches, "right"),
}

local get_relative_path = function(winid, dirpath)
  local cwd = vim.fs.normalize(vim.uv.cwd())
  local path = util.replace(dirpath, cwd, "")
  if path == "" then return "" end
  local limit = math.floor(0.4 * vim.fn.winwidth(winid))
  return #path > limit and "..." or path
end

local format_sections = function(path, fname, ext)
  local parts = path and vim.split(path, "/") or {}
  table.insert(parts, fname)
  local segments = util.reduce(parts, function(segments, v, k)
    local section
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      -- NOTE: octo.nvim
      if parts[1] and parts[1]:match "octo:" then
        if parts[#parts - 1] == "pull" then
          icon = icons.git.PullRequest
        else
          icon = icons.debug.Bug
        end
      end
      -- NOTE: nvim-dap
      if fname and fname:match "DAP" then icon = dap_icons[fname] or icon end
      if #segments == 0 then
        section = (k == #parts and devicons_ok)
            and add(highlighter.sanitize(icon_hl), { ds.pad(icon, "both") }, true) .. add(fname_hl, { v })
          or add(generic_hl, { ds.pad(v, "left") })
      else
        section = (k == #parts and devicons_ok)
            and add(highlighter.sanitize(icon_hl), { ds.pad(icon, "right") }, true) .. add(fname_hl, { v })
          or add(generic_hl, { v })
      end
      table.insert(segments, section)
    end
    return segments
  end)
  return table.concat(segments, ds.pad("/", "right"))
end

return function()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

  if util.contains(excludes.ft.wb_empty, ft) then return " " end

  local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local dirpath, filename = (filepath):match "^(.+)/(.+)$"
  local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
  local relative_path = vim.startswith(bufid, "diffview") and "" or get_relative_path(winid, dirpath)
  local ext = vim.fs.basename(filename):match "[^.]+$"
  return format_sections(relative_path, filename, ext)
end
