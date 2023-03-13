local ok, zk = pcall(require, "zk")
if not ok then return end

-- local cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
local cmd = { "zk", "lsp" }
local function get_cmd()
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
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
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
  name = "zk",
}

M.defer_setup = true

return M
