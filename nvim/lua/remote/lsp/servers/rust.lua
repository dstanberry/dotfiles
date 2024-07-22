local M = {}

M.config = {
  default_settings = {
    ["rust-analyzer"] = {
      assist = { importGranularity = "module", importPrefix = "by_self" },
      cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
      checkOnSave = { enable = true, command = "clippy" },
      experimental = { procAttrMacros = true },
      hoverActions = { references = true },
      inlayHints = { enable = true },
      lens = { enable = true, methodReferences = true, references = true },
      procMacro = { enable = true },
    },
  },
  server = {
    on_attach = function(_, bufnr)
      local _action = function() vim.cmd.RustLsp "codeAction" end
      vim.keymap.set("n", "ga", _action, { buffer = bufnr, desc = "rust: code action" })

      local _debug = function() vim.cmd.RustLsp "debuggables" end
      vim.keymap.set("n", "da", _debug, { buffer = bufnr, desc = "rust: debug with args" })
    end,
  },
}

M.defer_setup = true

M.setup = function(opts) vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {}) end

return M
