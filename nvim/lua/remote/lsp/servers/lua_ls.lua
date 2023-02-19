-- verify neodev is available
local ok, neodev = pcall(require, "neodev")
if not ok then
  return
end

local M = {}

M.setup = function()
  neodev.setup {
    library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = true,
    },
    -- setup_jsonls = true,
    -- override = function(root_dir, options) end,
  }
end

M.config = {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      completion = {
        showWord = "Disable",
        -- keywordSnippet = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "dump", "has", "profile", "reload", "vim" },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}

return M
