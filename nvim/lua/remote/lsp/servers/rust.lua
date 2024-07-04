local M = {}

M.config = {
  default_settings = { require("remote.lsp.servers.rust_analyzer").config.settings },
  server = {
    on_attach = function(_, bufnr)
      local _action = function() vim.cmd.RustLsp "codeAction" end
      vim.keymap.set("n", "ga", _action, { buffer = bufnr, desc = "rust: code action" })

      local _debug = function() vim.cmd.RustLsp "debuggables" end
      vim.keymap.set("n", "da", _debug, { buffer = bufnr, desc = "rust: debug with args" })
    end,
  },
}

M.setup = function(opts) vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {}) end

M.defer_setup = true

return M
