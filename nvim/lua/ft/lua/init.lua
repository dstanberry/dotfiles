---@class ft.lua
local M = {}

local sep = string.match(package.config, "^[^\n]")

local function include_paths(fname, ext)
  ext = ext or "lua"
  local paths = string.gsub(package.path, "%?", fname)
  paths = string.gmatch(paths, "[^%;]+")
  for path in paths do
    if vim.uv.fs_stat(path) then return path end
  end
end

local function include_rtpaths(fname, ext)
  ext = ext or "lua"
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile, initfile = string.format("%s.%s", fname, ext), string.format("init.%s", ext)
  for _, path in ipairs(rtpaths) do
    local path1 = table.concat({ path, ext, modfile }, sep)
    if vim.uv.fs_stat(path1) then return path1 end
    local path2 = table.concat({ path, ext, fname, initfile }, sep)
    if vim.uv.fs_stat(path2) then return path2 end
  end
end

function M.include_expr(module)
  local fname = module:gsub("%.", sep)
  local f
  f = include_paths(fname, "lua")
  if f then return f end
  f = include_rtpaths(fname, "lua")
  if f then return f end
end

return M
