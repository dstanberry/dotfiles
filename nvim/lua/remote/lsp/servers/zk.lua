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

local project_root = function(fname)
  local lspconfig = require "lspconfig.util"
  local root_dirs = { ".zk", "vault" }
  return lspconfig.root_pattern(unpack(root_dirs))(fname) or lspconfig.path.dirname(fname)
end

local execute_command = function(cmd, options, cb)
  if options and vim.tbl_isempty(options) then
    options = nil
  end
  vim.lsp.buf_request(0, "workspace/executeCommand", {
    command = string.format("zk.%s", cmd),
    arguments = {
      project_root(vim.api.nvim_buf_get_name(0)),
      options,
    },
  }, cb)
end

M.index = function(...)
  execute_command("index", ..., function(err, stats)
    assert(not err, tostring(err))
    if stats then
      vim.notify(vim.inspect(stats))
    end
  end)
end

M.new = function(...)
  execute_command("new", ..., function(err, result)
    assert(not err, tostring(err))
    if not (result and result.path) then
      return
    end
    vim.cmd(string.format("edit %s", vim.fn.expand(result.path)))
  end)
end

M.list = function(options, cb)
  execute_command("list", options, function(err, notes)
    assert(not err, tostring(err))
    if not notes then
      return
    end
    cb(notes)
  end)
end

M.tag = {}

M.tag.list = function(options, cb)
  execute_command("tag.list", options, function(err, tags)
    assert(not err, tostring(err))
    if not tags then
      return
    end
    cb(tags)
  end)
end

M.config = {
  cmd = { "zk", "lsp" },
  filetypes = { "markdown" },
  root_dir = project_root,
}

M.on_attach = function(client, bufnr)
  require("remote.lsp").handlers.on_attach(client, bufnr)
  vim.keymap.set("n", "<leader>mi", M.index, { buffer = bufnr })
  vim.keymap.set("n", "<leader>mn", function()
    M.new { title = vim.fn.input "Title: ", dir = "journal" }
  end, { buffer = bufnr })
end

M.setup = function(force)
  local install_cmd = string.format(
    [[
      git clone https://github.com/mickael-menu/zk.git
      cd zk
      make
      mkdir -vp %s/{inbox,journal,resources}
      cp zk $GOPATH/bin/
    ]],
    vim.g.zk_notebook
  )
  util.terminal.install_package("zk", basedir, path, install_cmd, force)
end

return M
