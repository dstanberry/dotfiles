local ok, zk = pcall(require, "zk")
if not ok then
  return
end

local M = {}

vim.g.zk_notebook = vim.env.hash_notes and ("%s/zettelkasten/vault"):format(vim.env.hash_notes)
local win_documents_path = ("%s/Documents"):format(vim.env.HOME)
if has "win32" and vim.fn.empty(vim.fn.glob(win_documents_path)) > 0 then
  if vim.fn.empty(vim.fn.glob "D:\\Documents") == 0 then
    win_documents_path = "D:\\Documents"
  end
  vim.g.zk_notebook = ("%s/_notes/zettelkasten/vault"):format(win_documents_path)
end

M.config = {
  -- cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
  cmd = { "zk", "lsp" },
  name = "zk",
}

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

return M
