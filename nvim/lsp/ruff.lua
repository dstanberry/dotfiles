return {
  _server_capabilities = {
    hoverProvider = false,
    documentFormattingProvider = false,
  },
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "warn",
    },
  },
}
