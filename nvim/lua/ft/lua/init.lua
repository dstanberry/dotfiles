local dir_separator = function()
  if package.config then
    return string.match(package.config, "^[^\n]")
  elseif has "win32" then
    return "\\"
  else
    return "/"
  end
end

local include_paths = function(fname, ext)
  ext = ext or "lua"
  local paths = string.gsub(package.path, "%?", fname)
  paths = string.gmatch(paths, "[^%;]+")
  for path in paths do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local include_rtpaths = function(fname, ext)
  ext = ext or "lua"
  local sep = dir_separator()
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile, initfile = string.format("%s.%s", fname, ext), string.format("init.%s", ext)
  for _, path in ipairs(rtpaths) do
    local path1 = table.concat({ path, ext, modfile }, sep)
    if vim.fn.filereadable(path1) == 1 then
      return path1
    end
    local path2 = table.concat({ path, ext, fname, initfile }, sep)
    if vim.fn.filereadable(path2) == 1 then
      return path2
    end
  end
end

local M = {}

M.include_expr = function(module)
  local sep = string.match(package.config, "^[^\n]")
  local fname = vim.fn.substitute(module, "\\.", sep, "g")
  local f
  f = include_paths(fname, "lua")
  if f then
    return f
  end
  f = include_rtpaths(fname, "lua")
  if f then
    return f
  end
end

return M
