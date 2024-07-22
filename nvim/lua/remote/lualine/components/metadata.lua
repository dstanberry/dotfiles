---@class remote.lualine.component.metadata
local M = {}

local util = require "remote.lualine.util"
local add = util.add
local highlighter = util.highlighter
local default_hl = highlighter.sanitize "Winbar"
local fname_hl = highlighter.sanitize "WinbarFilename"

M.breadcrumbs = {
  get = function()
    local dap_icons = {
      ["DAP Breakpoints"] = ds.pad(ds.icons.debug.Breakpoint, "right"),
      ["DAP Console"] = ds.pad(ds.icons.debug.REPL, "right"),
      ["DAP Scopes"] = ds.pad(ds.icons.debug.Scopes, "right"),
      ["DAP Stacks"] = ds.pad(ds.icons.debug.Stacks, "right"),
      ["DAP Watches"] = ds.pad(ds.icons.debug.Watches, "right"),
    }

    local get_relative_path = function(winid, dirpath)
      local cwd = vim.fs.normalize(vim.uv.cwd())
      local path = ds.replace(dirpath, cwd, "")
      if path == "" then return "" end
      local limit = math.floor(0.4 * vim.fn.winwidth(winid))
      return #path > limit and "..." or path
    end

    local format_sections = function(path, fname)
      local parts = path and vim.split(path, "/") or {}
      table.insert(parts, fname)
      local segments = ds.reduce(parts, function(segments, v, k)
        local section
        if #v > 0 then
          local icon, icon_hl = require("mini.icons").get("file", fname)
          -- NOTE: octo.nvim
          if parts[1] and parts[1]:match "^octo:" then
            if parts[#parts - 1] == "pull" then
              icon = ds.icons.git.PullRequest
            elseif parts[#parts - 1] == "issue" then
              icon = ds.icons.git.Issue
            end
          end
          -- NOTE: oil.nvim
          if parts[1] and parts[1]:match "^oil:" then
            icon, icon_hl = require("mini.icons").get("directory", path)
          end
          -- NOTE: nvim-dap
          if fname and fname:match "^DAP" then icon = dap_icons[fname] or icon end
          if #segments == 0 then
            section = k == #parts
                and add(highlighter.sanitize(icon_hl), { ds.pad(icon, "both") }, true) .. add(fname_hl, { v })
              or add(default_hl, { ds.pad(v, "left") })
          else
            section = k == #parts
                and add(highlighter.sanitize(icon_hl), { ds.pad(icon, "right") }, true) .. add(fname_hl, { v })
              or add(default_hl, { v })
          end
          table.insert(segments, section)
        end
        return segments
      end)
      return table.concat(segments, ds.pad("/", "right"))
    end

    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

    if ds.contains(ds.excludes.ft.wb_empty, ft) then return " " end

    local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
    local dirpath, filename = (filepath):match "^(.+)/(.+)$"
    local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
    local relative_path = vim.startswith(bufid, "diffview") and "" or get_relative_path(winid, dirpath)
    return format_sections(relative_path, filename)
  end,
}

M.indentation = {
  get = function()
    if vim.bo.expandtab then
      return ("spaces: %s"):format(vim.bo.shiftwidth)
    else
      return ("tabs: %s"):format(vim.bo.tabstop)
    end
  end,
}

M.root_dir = {
  get = function()
    local cwd = vim.uv.cwd()
    local root = ds.buffer.get_root()
    local name = vim.fs.basename(root)
    local result = ds.pad(ds.icons.documents.MultipleFolders, "right", 2) .. name
    if root == cwd then
      return nil
    else
      return result
    end
  end,
}

return M
