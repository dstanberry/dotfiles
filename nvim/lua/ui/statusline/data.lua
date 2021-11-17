local Job = require "plenary.job"

local paste = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = " "
  end
  return result
end

local M = {}

M.readonly = function(bufnr)
  local ro = vim.api.nvim_buf_get_option(bufnr, "readonly")
  local modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")
  if not modifiable then
    return " "
  elseif ro then
    return " "
  else
    return ""
  end
end

M.modified = function(bufnr)
  local mod = vim.api.nvim_buf_get_option(bufnr, "modified")
  if mod then
    return "●"
  else
    return ""
  end
end

M.filename = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local fname = vim.fn.fnamemodify(name, ":t")
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
  local ext = vim.fn.fnamemodify(fn, ":e")
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local type = #ext > 0 and ext or ft
  local icon = M.file_icon(fn, type)
  return string.format("%s %s", icon, ft)
end

M.filepath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  return vim.fn.fnamemodify(name, "%:p")
end

M.relpath = function(bufnr)
  local name = vim.fn.bufname(bufnr)
  local path = vim.fn.fnamemodify(name, ":~:.:h:p")
  if path == "" or path == "." then
    return ""
  else
    local maxlen = math.min(40, math.floor(0.6 * vim.fn.winwidth(0)))
    path = path:gsub("/$", "") .. "/"
    if (#path + #M.filename(bufnr)) > maxlen then
      path = vim.fn.pathshorten(path)
    end
    return path
  end
end

M.metadata = function(bufnr)
  local lhs = ""
  local rhs = ""
  local format = vim.api.nvim_buf_get_option(bufnr, "fileformat")
  local encoding = vim.api.nvim_buf_get_option(bufnr, "fileencoding")
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

M.mode = function()
  return "▊"
end

M.buffer = function(bufnr)
  local icon = " "
  for i, b in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr == b then
      return icon .. i
    end
  end
end

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
  local icon = " "
  local p = paste()
  if #p > 0 then
    icon = p
  end
  return icon .. branch
end

M.line_number = function()
  return "ℓ %l"
end

M.column_number = function()
  return "с %c"
end

return M
