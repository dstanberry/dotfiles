---------------------------------------------------------------
-- => Statusline Utilities
---------------------------------------------------------------
-- initialize modules table
local util = {}

-- readonly indicator
util.get_readonly = function()
  if vim.bo.readonly or not vim.bo.modifiable then
    return " "
  else
    return ""
  end
end

-- modified indicator
util.get_modified = function()
  if vim.bo.modified then
    return "●"
  else
    return ""
  end
end

-- print filename with extension
util.filename = function()
  local name = vim.fn.expand "%:t"
  if name == "" then
    return "[No Name]"
  end
  return name
end

-- print filetype with icon
util.filetype = function()
  local ft = vim.bo.filetype
  if #ft > 0 then
    local fn = util.filename()
    local icon = require("nvim-web-devicons").get_icon(fn, ft) or ""
    return string.format("%s %s", icon, ft)
  else
    return ""
  end
end

-- print filepath
util.filepath = function()
  return vim.fn.expand("%:p")
end

-- print filepath relative to current directory
util.relpath = function()
  local basename = vim.fn.fnamemodify(vim.fn.expand "%:h", ":p:~:.")
  if basename == "" or basename == "." then
    return ""
  else
    return basename:gsub("/$", "") .. "/"
  end
end

-- print non-standard fileformat and encoding
util.metadata = function()
  local lhs = ""
  local rhs = ""
  local format = vim.bo.fileformat
  local encoding = vim.bo.fileencoding
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
util.git_branch = function()
  local result = "  "
  if vim.fn.exists "g:loaded_fugitive" then
    local branch = vim.fn["FugitiveHead"]()
    if #branch > 0 then
      result = "  " .. branch
    end
  end
  return result
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
