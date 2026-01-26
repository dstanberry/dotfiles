return {
  _server_capabilities = { hoverProvider = false },
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function()
    local handlers = require "remote.lsp.handlers"

    ds.format.register(handlers.formatter { name = "eslint: lsp", primary = false, priority = 200, filter = "eslint" })
  end,
}
