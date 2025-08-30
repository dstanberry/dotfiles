---@class remote.lsp.config
local M = {}

M.config = {
  cmd = { "copilot-language-server", "--stdio" },
  root_dir = function(fname) return ds.root.detectors.pattern(fname, { ".git" })[1] end,
  init_options = {
    editorInfo = { name = "Neovim", version = tostring(vim.version()) },
    editorPluginInfo = { name = "copilot-language-server", version = "*" },
  },
  settings = {
    telemetry = {
      telemetryLevel = "all",
    },
  },
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
      local completion = vim.lsp.inline_completion
      if completion then completion.enable(true) end
      ---@diagnostic disable-next-line: duplicate-set-field
      ds.snippet.ai = function() return completion.get() end
    end
  end,
}

return M
