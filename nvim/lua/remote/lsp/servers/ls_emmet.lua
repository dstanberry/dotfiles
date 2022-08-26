local bin_name = 'ls_emmet'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local M = {}

M.config = {
    cmd = cmd,
    filetypes = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      'javascript.jsx',
      "less",
      "sass",
      "scss",
      "typescript",
      "typescriptreact",
      'typescript.tsx',
      "xml",
    },
    root_dir = function(_)
      return vim.loop.cwd()
    end,
    settings = {},
}

return M
