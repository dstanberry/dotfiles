local ok, zk = pcall(require, "zk")
if not ok then return end

local zkl = require "zk.lsp"

require "ft.markdown.commands"
require "ft.markdown.keymaps"

-- local cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" }
local cmd = { "zk", "lsp" }
local function get_cmd()
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

local M = {}

M.defer_setup = true

M.setup = function(cfg)
  zk.setup {
    picker = "telescope",
    lsp = { config = cfg },
    auto_attach = {
      enabled = false,
      filetypes = { "markdown" },
    },
  }
  local lsp_zk = vim.api.nvim_create_augroup("lsp_zk", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_zk,
    pattern = "*.md",
    callback = function(args)
      -- HACK: hijack marksman lsp setup to also add zk to the mix
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == "marksman" then zkl.buf_add(args.buf) end
    end,
  })
end

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
  name = "zk",
  root_dir = vim.env.ZK_NOTEBOOK_DIR,
}

return M
