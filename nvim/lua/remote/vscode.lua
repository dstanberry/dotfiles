if not vim.g.vscode then return {} end

vim.g.snacks_animate = false

local enabled = {
  "dial.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "ts-comments.nvim",
}

local Config = require "lazy.core.config"
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.tbl_contains(enabled, plugin.name) or plugin.vscode end

-- keep undo/redo lists in sync with vscode
vim.keymap.set("n", "<c-r>", [[<cmd>lua require('vscode').action('redo')<cr>]])
vim.keymap.set("n", "u", [[<cmd>lua require('vscode').action('undo')<cr>]])
-- editor layout
vim.keymap.set("n", "<c-left>", [[<cmd>lua require('vscode').action('workbench.action.decreaseViewSize')<cr>]])
vim.keymap.set("n", "<c-right>", [[<cmd>lua require('vscode').action('workbench.action.increaseViewSize')<cr>]])
vim.keymap.set("n", "<c-backspace>", [[<cmd>lua require('vscode').action('editor.action.fontZoomOut')<cr>]])
vim.keymap.set("n", "<c-delete>", [[<cmd>lua require('vscode').action('editor.action.fontZoomIn')<cr>]])
-- editor naviagtion
vim.keymap.set("n", "<left>", [[<cmd>lua require('vscode').action('workbench.action.previousEditor')<cr>]])
vim.keymap.set("n", "<right>", [[<cmd>lua require('vscode').action('workbench.action.nextEditor')<cr>]])
vim.keymap.set("n", "<leader>wt", [[<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<cr>]])
-- file navigation
vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
vim.keymap.set("n", "<localleader>fg", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
-- lsp
vim.keymap.set("n", "ff", function() vim.lsp.buf.format { async = true } end)
vim.keymap.set("n", "g<leader>", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gh", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gk", vim.lsp.buf.hover)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gw", function() vim.lsp.buf.workspace_symbol "" end)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
