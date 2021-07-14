---------------------------------------------------------------
-- => Statusline Utilities
---------------------------------------------------------------
-- load statusline utilities
local Job = require "plenary.job"

-- initialize modules table
local util = {}

-- readonly indicator
util.get_readonly = function(bufnr)
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
util.get_modified = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local mod = vim.api.nvim_buf_get_option(name, "modified")
  if mod then
    return "●"
  else
    return ""
  end
end

-- print filename with extension
util.filename = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local fname = vim.fn.fnamemodify(name, ":t")
  if fname == "" then
    return "[No Name]"
  end
  return fname
end

-- print filetype with icon
util.filetype = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local ft = vim.api.nvim_buf_get_option(name, "filetype")
  if #ft > 0 then
    local fn = util.filename(bufnr)
    local icon = require("nvim-web-devicons").get_icon(fn, ft) or ""
    return string.format("%s %s", icon, ft)
  else
    return ""
  end
end

-- print filepath
util.filepath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  return vim.fn.fnamemodify(name, "%:p")
end

-- print filepath relative to current directory
util.relpath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local basename = vim.fn.fnamemodify(name, ":h:p:~:.")
  if basename == "" or basename == "." then
    return ""
  else
    return basename:gsub("/$", "") .. "/"
  end
end

-- print non-standard fileformat and encoding
util.metadata = function(bufnr)
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
util.mode = function()
  return "▊"
end

-- print git branch with icon
util.git_branch = function(bufnr)
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
util.paste = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = "  "
  end
  return result
end

-- print lsp diagnostic count
util.get_lsp_diagnostics = function(bufnr)
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
util.line_number = function()
  return "ℓ %l"
end

-- print column numbering
util.column_number = function()
  return "с %c"
end

return util
