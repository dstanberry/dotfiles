-- verify typescript-tools is available
local ok, typescript = pcall(require, "typescript-tools")
if not ok then return end

local M = {}

M.defer_setup = true

M.setup = function(config)
  typescript.setup {
    capabilities = config and config.capabilities and config.capabilities,
    flags = config and config.flags and config.flags,
    on_attach = function(client, bufnr)
      if config and config.on_attach then config.on_attach(client, bufnr) end
      vim.api.nvim_create_autocmd("User", {
        pattern = "FormatPre",
        desc = "Typescript: Organize Imports",
        callback = function()
          if vim.api.nvim_get_current_buf() == bufnr then vim.cmd "TSToolsOrganizeImports" end
        end,
      })
    end,
    settings = {
      expose_as_code_actions = { "all" },
      publish_diagnostic_on = "insert_leave",
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
