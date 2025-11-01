---@class remote.lualine.component.metadata
local M = {}

local util = require "remote.lualine.util"
local add = util.add

local highlighter = util.highlighter
local dir_hl = highlighter.sanitize "WinbarDirectory"
local file_hl = highlighter.sanitize "WinbarFilename"

local dir_section = add(highlighter.sanitize "Winbar", { ds.pad("/", "right") })

M.breadcrumbs = {
  get = function()
    local get_relative_path = function(winid, dirpath)
      local cwd = vim.fs.normalize(vim.uv.cwd())
      local path = ds.replace(dirpath, cwd, "")
      if path == "" then return "" end
      local limit = math.floor(0.4 * vim.fn.winwidth(winid))
      return #path > limit and "..." or path
    end

    local format_sections = function(path, fname)
      local parts = path and vim.split(path, "/") or {}
      local mini_icons = package.loaded["mini.icons"]
      table.insert(parts, fname)
      local segments = ds.tbl_reduce(parts, function(segments, v, k)
        local section
        if #v > 0 then
          local icon, icon_hl = ds.icons.status.Error, "Error"
          local hl = highlighter.sanitize(icon_hl)
          if mini_icons then
            icon, icon_hl = mini_icons.get("file", fname)
          end

          if parts[1] and parts[1]:match "^gh:" then
            if parts[#parts - 1] == "pr" then
              icon = ds.icons.git.PullRequest
            elseif parts[#parts - 1] == "issue" then
              icon = ds.icons.git.Issue
            end
          end

          if #segments == 0 then
            section = k == #parts and add(hl, { ds.pad(icon, "both") }, true) .. add(file_hl, { v })
              or add(dir_hl, { ds.pad(v, "left") })
          else
            section = k == #parts and add(hl, { ds.pad(icon, "right") }, true) .. add(file_hl, { v })
              or add(dir_hl, { v })
          end
          table.insert(segments, section)
        end
        return segments
      end)
      return table.concat(segments, dir_section)
    end

    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
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
    local root = ds.root.get()
    local name = vim.fs.basename(root)
    local result = ds.pad(ds.icons.documents.Project, "right", 2) .. name
    if root == cwd then
      return nil
    else
      return result
    end
  end,
  cond = function() return type(M.root_dir.get()) == "string" end,
}

M.plugin = {
  icons = {
    ["grug-far"] = { "󰥩 ", "Find and Replace" },
    codecompanion = { " ", "AI Assistant" },
    DiffviewFileHistory = { " ", "Commit History" },
    DiffviewFiles = { " ", "Diff Viewer" },
    gitcommit = { " ", "Git Commit" },
    lazy = { " ", "Plugin Manager" },
    loclist = { "", "Location List" },
    mason = { " ", "Package Manager" },
    minifiles = { "󰙅 ", "File Explorer" },
    noice = { "󰍪 ", "Messages" },
    oil = { "󰙅 ", "File Explorer" },
    quickfix = { " ", "Quickfix List" },
    sidekick_terminal = { " ", "AI Assistant" },
    snacks_picker_input = { "󰋱", "Fuzzy Finder" },
    snacks_picker_list = { "󰙅", "File Explorer" },
    snacks_terminal = { " ", "Terminal" },
    terminal = { " ", "Terminal" },
    trouble = { " ", "Quickfix / Location List" },
  },
  get = function()
    local fname = vim.api.nvim_buf_get_name(0)
    if fname:len() < 1 and vim.bo.buftype:len() < 1 then return "..." end
    local ft = vim.bo.filetype == "qf" and vim.fn.win_gettype() or vim.bo.filetype
    local msg = ""
    if M.plugin.icons[ft] ~= nil then
      for _, part in ipairs(M.plugin.icons[ft]) do
        msg = string.format("%s %s", msg, part)
      end
    end
    if #M.plugin.icons[ft] < 2 then msg = msg .. fname:gsub("%%", "%%%%") end
    return msg
  end,
  cond = function() return vim.tbl_contains(vim.tbl_keys(M.plugin.icons), vim.bo.filetype) end,
}

return M
