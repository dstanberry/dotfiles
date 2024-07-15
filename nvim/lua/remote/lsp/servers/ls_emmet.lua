local M = {}

local cmd = { vim.fn.exepath "ls_emmet", "--stdio" }

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = cmd end,
  filetypes = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "less",
    "sass",
    "scss",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "xml",
  },
  root_dir = function(_) return vim.uv.cwd() end,
  settings = {},
  on_attach = function() end,
}

M.register_default_config = true

return M
