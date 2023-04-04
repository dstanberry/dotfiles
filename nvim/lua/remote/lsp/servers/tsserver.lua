-- verify typescript is available
local ok, typescript = pcall(require, "typescript")
if not ok then return end

local M = {}

local prefs = {
  format = {
    convertTabsToSpaces = true,
    indentSize = 2,
    trimTrailingWhitespace = false,
    semicolons = "insert",
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
  },
}

M.setup = function(config)
  typescript.setup {
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
      fallback = true,
    },
    server = { config },
  }
end

M.config = {
  settings = {
    javascript = prefs,
    typescript = prefs,
  },
}

local lsp_tsserver = vim.api.nvim_create_augroup("lsp_tsserver", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_tsserver,
  callback = function(args)
    if not (args.data and args.data.client_id) then return end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name ~= "tsserver" then return end
    local bufnr = args.buf
    vim.keymap.set("n", "ff", function()
      typescript.actions.organizeImports()
      vim.lsp.buf.format { async = true }
    end, { buffer = bufnr, desc = "typescript: lsp format document" })
    vim.keymap.set(
      "n",
      "<localleader><localleader>s",
      "<cmd>TypescriptRenameFile<cr>",
      { buffer = bufnr, desc = "typescript: rename current file" }
    )
  end,
})

return M
