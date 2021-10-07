local Job = require "plenary.job"

-- paste mode identifier
local paste = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = "  "
  end
  return result
end

local M = {}

-- readonly indicator
M.get_readonly = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local ro = vim.api.nvim_buf_get_option(name, "readonly")
  local mod = vim.api.nvim_buf_get_option(name, "modifiable")
  if (ro and not mod) or not mod then
    return " "
  elseif ro then
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
  local fn = M.filename(bufnr)
  local icon = require("nvim-web-devicons").get_icon(fn, ft)
  return string.format("%s %s", icon, ft)
end

-- print filepath
M.filepath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  return vim.fn.fnamemodify(name, "%:p")
end

-- print filepath relative to current directory
M.relpath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local path = vim.fn.fnamemodify(name, ":~:.:h:p")
  if path == "" or path == "." then
    return ""
  else
    local maxlen = math.min(35, math.floor(0.6 * vim.fn.winwidth(0)))
    path = path:gsub("/$", "") .. "/"
    if (#path + #M.filename(bufnr)) > maxlen then
      path = vim.fn.pathshorten(path)
    end
    return path
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

-- print buffer count with icon
M.buffer = function(bufnr)
  local icon = "  "
  for i, b in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr == b then
      return icon .. i
    end
  end
end

-- print git branch with icon (fallback to buffer count)
M.git_branch = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local j = Job:new {
    command = "git",
    args = { "branch", "--show-current" },
    cwd = vim.fn.fnamemodify(name, ":h"),
  }
  local ok, branch = pcall(function()
    return vim.trim(j:sync()[1])
  end)
  if not ok then
    return M.buffer(bufnr)
  end
  local icon = "  "
  local p = paste()
  if #p > 0 then
    icon = p
  end
  return icon .. branch
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
