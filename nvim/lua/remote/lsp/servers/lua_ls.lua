-- verify neodev is available
local ok, neodev = pcall(require, "neodev")
if not ok then return end

local cmd = { "lua-language-server" }
local function get_cmd()
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
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
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
  settings = {
    Lua = {
      completion = {
        showWord = "Disable",
        -- keywordSnippet = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "dump", "has", "profile", "reload" },
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
