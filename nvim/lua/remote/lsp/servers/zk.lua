local util = require "util"

local M = {}

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "zk")

local win_documents_path = ("%s/Documents"):format(vim.env.HOME)
if has "win32" and vim.fn.empty(vim.fn.glob(win_documents_path)) > 0 then
  if vim.fn.empty(vim.fn.glob "D:\\Documents") == 0 then
    win_documents_path = "D:\\Documents"
  end
end

vim.g.zk_notebook = vim.env.hash_notes and ("%s/zettelkasten/vault"):format(vim.env.hash_notes)
  or ("%s/_notes/zettelkasten/vault"):format(win_documents_path)

M.config = {
  cmd = { "zk", "lsp" },
  filetypes = { "markdown" },
  root_dir = function()
    -- lspconfig.util.root_pattern ".zk"
    return vim.loop.cwd()
  end,
}

M.on_attach = function(_, bufnr)
  vim.keymap.set("n", "<leader>mi", M.index, { buffer = bufnr })
  vim.keymap.set("n", "<leader>mn", function()
    M.new { title = vim.fn.input "Title: ", dir = "journal" }
  end, { buffer = bufnr })
end

M.index = function()
  vim.lsp.buf.execute_command {
    command = "zk.index",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
end

M.new = function(...)
  vim.lsp.buf_request(0, "workspace/executeCommand", {
    command = "zk.new",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      ...,
    },
  }, function(_, _, result)
    if not (result and result.path) then
      return
    end
    vim.cmd(string.format("edit %s", result.path))
  end)
end

M.setup = function(force)
  local install_cmd = string.format(
    [[
      git clone https://github.com/mickael-menu/zk.git
      cd zk
      make
      mkdir -vp %s/{inbox,journal,literature,permanent}
      cp zk $GOPATH/bin/
    ]],
    vim.g.zk_notebook
  )
  util.terminal.install_package("zk", basedir, path, install_cmd, force)
end

return M
