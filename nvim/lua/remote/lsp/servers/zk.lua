local ok, zk = pcall(require, "zk")
if not ok then
  return
end

local M = {}

M.setup = function(cfg)
  zk.setup {
    picker = "telescope",
    lsp = { config = cfg },
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  }

  require "ft.markdown.commands"
  require "ft.markdown.keymaps"
end

M.config = {
  -- cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
  cmd = { "cmd.exe", "/C", "zk", "lsp" },
  name = "zk",
}

return M
