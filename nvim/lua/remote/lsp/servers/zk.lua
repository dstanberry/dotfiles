local ok, zk = pcall(require, "zk")
if not ok then
  return
end

vim.env.ZK_NOTEBOOK_DIR = vim.env.hash_notes and ("%s/zettelkasten/vault"):format(vim.env.hash_notes)
local win_documents_path = ("%s\\Documents"):format(vim.env.HOME)
if has "win32" and vim.fn.empty(vim.fn.glob(win_documents_path)) > 0 then
  if vim.fn.empty(vim.fn.glob "D:\\Documents") == 0 then
    win_documents_path = "D:\\Documents"
  end
  vim.env.ZK_NOTEBOOK_DIR = vim.fn.expand(("%s/_notes/zettelkasten/vault"):format(win_documents_path))
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
