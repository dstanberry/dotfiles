local cmd = { "lua-language-server" }

local function get_cmd()
  if ds.has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

local M = {}

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
        showWord = "Disable",
        -- keywordSnippet = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "ds" },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        paramType = true,
        setType = false,
        arrayIndex = "Disable",
        paramName = "Disable",
        semicolon = "Disable",
      },
      workspace = {
        checkThirdParty = false,
        library = {},
      },
    },
  },
}

return M
