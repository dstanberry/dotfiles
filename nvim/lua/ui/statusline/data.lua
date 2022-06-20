local has_plenary, Job = pcall(require, "plenary.job")
local icons = require "ui.icons"

local GIT_ENABLED = setting_enabled "git"

local paste = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = pad(icons.misc.Clipboard, "right")
  end
  return result
end

local path_separator = function()
  return has "win32" and [[\]] or "/"
end

local M = {}

M.readonly = function(bufnr)
  local ro = vim.api.nvim_buf_get_option(bufnr, "readonly")
  local modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")
  if not modifiable or ro then
    return pad(icons.misc.Lock, "right")
  else
    return ""
  end
end

M.modified = function(bufnr)
  local mod = vim.api.nvim_buf_get_option(bufnr, "modified")
  if mod then
    return icons.misc.FilledCircle
  else
    return ""
  end
end

M.filename = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local fname = vim.fn.fnamemodify(name, ":t")
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if ft == "TelescopePrompt" then
    return ""
  end
  if fname == "" then
    return "[No Name]"
  end
  return fname
end

M.file_icon = function(fn, ft)
  local ok, icon = pcall(function()
    return require("nvim-web-devicons").get_icon(fn, ft, { default = true })
  end)
  return ok and icon or ""
end

M.filetype = function(bufnr)
  local fn = M.filename(bufnr)
  if fn == "[No Name]" then
    return "[text]"
  end
  return vim.api.nvim_buf_get_option(bufnr, "filetype")
end

M.filepath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  return vim.fn.fnamemodify(name, "%:p")
end

M.relpath = function(bufnr, maxlen)
  local name = vim.fn.bufname(bufnr)
  local path = vim.fn.fnamemodify(name, ":~:.:h:p")
  maxlen = maxlen or 60
  if path == "" or path == "." then
    return ""
  else
    maxlen = math.min(maxlen, math.floor(0.8 * vim.fn.winwidth(0)))
    path = path:gsub("/$", "") .. path_separator()
    if (#path + #M.filename(bufnr)) > maxlen then
      path = vim.fn.pathshorten(path)
    end
    return path
  end
end

M.file_format = function(bufnr)
  local out = ""
  local format = vim.api.nvim_buf_get_option(bufnr, "fileformat")
  if format == "unix" then
    out = "lf"
  end
  if format == "dos" then
    out = "crlf"
  end
  return out
end

M.file_encoding = function(bufnr)
  local out = "utf-8"
  local encoding = vim.api.nvim_buf_get_option(bufnr, "fileencoding")
  if #encoding > 0 then
    return encoding
  end
  return out
end

M.mode = function()
  return icons.misc.VerticalBarBold
end

M.buffer = function(bufnr)
  local icon = pad(icons.misc.Orbit, "right")
  for i, b in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr == b then
      return icon, i
    end
  end
end

M.git_branch = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local icon = pad(icons.git.Branch, "right")
  local ok, branch
  if GIT_ENABLED then
    if has_plenary then
      local j = Job:new {
        command = "git",
        args = { "branch", "--show-current" },
        cwd = vim.fn.fnamemodify(name, ":h"),
      }
      ok, branch = pcall(function()
        return vim.trim(j:sync()[1])
      end)
      if not ok then
        icon, branch = M.buffer(bufnr)
      end
    else
      branch = vim.trim(vim.fn.system "git branch --show-current")
      if not branch or #branch == 0 then
        icon, branch = M.buffer(bufnr)
      end
    end
  end
  if not (ok or branch) then
    icon, branch = M.buffer(bufnr)
  end
  local p = paste()
  if #p > 0 then
    icon = p
  end
  return icon .. branch
end

M.cursor_position = function()
  return "%l:%c"
end

return M
