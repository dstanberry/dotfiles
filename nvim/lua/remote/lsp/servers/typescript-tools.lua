-- verify typescript-tools is available
local ok, typescript = pcall(require, "typescript-tools")
if not ok then return end

local M = {}

M.defer_setup = true

M.setup = function(config)
  typescript.setup {
    capabilities = config.capabilities,
    flags = config.flags,
    on_attach = function(client, bufnr)
      config.on_attach(client, bufnr)
      vim.keymap.set("n", "ff", function()
        vim.cmd "TSToolsOrganizeImports"
        vim.lsp.buf.format { async = true }
      end, { buffer = bufnr, desc = "typescript: lsp format document" })
    end,
    settings = {
      tsserver_file_preferences = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      },
      tsserver_format_preferences = {
        convertTabsToSpaces = true,
        indentSize = 2,
        trimTrailingWhitespace = false,
        semicolons = "insert",
      },
    },
  }
end

return M
