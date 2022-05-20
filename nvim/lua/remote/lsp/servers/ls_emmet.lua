local M = {}

M.config = {
    cmd = { "ls_emmet", "--stdio" },
    filetypes = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "typescript",
      "typescriptreact",
      "xml",
    },
    root_dir = function(_)
      return vim.loop.cwd()
    end,
    settings = {},
}

return M
