-- verify lspconfig is available
local ok, configs = pcall(require, "lspconfig/configs")
if not ok then
  return
end

configs.ls_emmet = {
  default_config = {
    cmd = { "ls_emmet", "--stdio" },
    filetypes = {
      "css",
      "haml",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "pug",
      "sass",
      "scss",
      "slim",
      "sss",
      "stylus",
      "typescript",
      "typescriptreact",
      "xml",
      "xsl",
    },
    root_dir = function(_)
      return vim.loop.cwd()
    end,
    settings = {},
  },
}

local M = {}

M.config = {}

return M
