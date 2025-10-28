---@class remote.lsp.config
local M = {}

M.config = {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
  init_options = { clangdFileStatus = true },
}

return function() return M end
