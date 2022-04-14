-- verify lspconfig is available
local ok, configs = pcall(require, "lspconfig.configs")
if not ok then
  return
end

configs.ls_emmet = {
  default_config = {
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
  },
}

return {}
