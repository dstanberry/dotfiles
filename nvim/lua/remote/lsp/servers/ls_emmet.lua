local cmd = { "ls_emmet", "--stdio" }
local function get_cmd()
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

local M = {}

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
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
  root_dir = function(_) return vim.loop.cwd() end,
  settings = {},
}

M.register_default_config = true

return M
