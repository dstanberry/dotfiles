---------------------------------------------------------------
-- => Statusline Utilities
---------------------------------------------------------------
-- load statusline utilities
local Job = require "plenary.job"

-- initialize modules table
local M = {}

-- readonly indicator
M.get_readonly = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local ro = vim.api.nvim_buf_get_option(name, "readonly")
  local mod = vim.api.nvim_buf_get_option(name, "modifiable")
  if ro and not mod then
    return " "
  else
    return ""
  end
end

-- modified indicator
M.get_modified = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local mod = vim.api.nvim_buf_get_option(name, "modified")
  if mod then
    return "●"
  else
    return ""
  end
end

-- print filename with extension
M.filename = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local fname = vim.fn.fnamemodify(name, ":t")
  if fname == "" then
    return "[No Name]"
  end
  return fname
end

-- print filetype with icon
M.filetype = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local ft = vim.api.nvim_buf_get_option(name, "filetype")
  if #ft > 0 then
    local fn = M.filename(bufnr)
    local icon = require("nvim-web-devicons").get_icon(fn, ft) or ""
    return string.format("%s %s", icon, ft)
  else
    return ""
  end
end

-- print filepath
M.filepath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  return vim.fn.fnamemodify(name, "%:p")
end

-- print filepath relative to current directory
M.relpath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local basename = vim.fn.fnamemodify(name, ":~:.:h:p")
  if basename == "" or basename == "." then
    return ""
  else
    return basename:gsub("/$", "") .. "/"
  end
end

-- print non-standard fileformat and encoding
M.metadata = function(bufnr)
  local lhs = ""
  local rhs = ""
  local name = vim.fn.bufname(bufnr)
  local format = vim.api.nvim_buf_get_option(name, "fileformat")
  local encoding = vim.api.nvim_buf_get_option(name, "fileencoding")
  if #format > 0 and format ~= "unix" then
    lhs = format
  end
  if #encoding > 0 and encoding ~= "utf-8" then
    rhs = encoding
  end
  if #lhs > 0 and #rhs > 0 then
    return vim.fn.join({ lhs, rhs }, " | ")
  else
    return string.format("%s%s", lhs, rhs)
  end
end

-- print mode identifier
M.mode = function()
  return "▊"
end

-- print git branch with icon
M.git_branch = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local result = "  "
  local j = Job:new {
    command = "git",
    args = { "branch", "--show-current" },
    cwd = vim.fn.fnamemodify(name, ":h"),
  }
  local ok, branch = pcall(function()
    return vim.trim(j:sync()[1])
  end)
  if ok then
    result = "  " .. branch
    return result
  end
end

-- paste mode identifier
M.paste = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = "  "
  end
  return result
end

-- print lsp diagnostic count
M.get_lsp_client_count = function(bufnr)
 local clients = vim.lsp.buf_get_clients(bufnr)
 return #clients
end
-- print lsp diagnostic count
M.get_lsp_diagnostics = function(bufnr)
  local result = {}
  local levels = {
    errors = "Error",
    warnings = "Warning",
    info = "Information",
    hints = "Hint",
  }
  for k, level in pairs(levels) do
    result[k] = vim.lsp.diagnostic.get_count(bufnr, level)
  end
  return result
end

-- print line numbering
M.line_number = function()
  return "ℓ %l"
end

-- print column numbering
M.column_number = function()
  return "с %c"
end

return M
