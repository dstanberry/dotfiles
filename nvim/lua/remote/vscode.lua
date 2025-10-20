if not vim.g.vscode then return {} end

local Config = require "lazy.core.config"
local vscode = require "vscode"

vim.g.snacks_animate = false

local enabled = {
  "dial.nvim",
  "flash.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "ts-comments.nvim",
}

Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.tbl_contains(enabled, plugin.name) or plugin.vscode end

-- editor layout
vim.keymap.set("n", "<c-left>", function() vscode.action "workbench.action.decreaseViewSize" end)
vim.keymap.set("n", "<c-right>", function() vscode.action "workbench.action.increaseViewSize" end)
vim.keymap.set("n", "<c-backspace>", function() vscode.action "editor.action.fontZoomOut" end)
vim.keymap.set("n", "<c-delete>", function() vscode.action "editor.action.fontZoomIn" end)

-- editor navigation
vim.keymap.set("n", "<left>", function() vscode.call "workbench.action.previousEditorInGroup" end)
vim.keymap.set("n", "<right>", function() vscode.call "workbench.action.nextEditorInGroup" end)
vim.keymap.set("n", "<leader>wt", function() vscode.action "workbench.action.terminal.toggleTerminal" end)
vim.keymap.set("n", "<bs>q", "<cmd>quit!<cr>", { desc = "close current window" })
vim.keymap.set("n", "<bs>Q", "<cmd>quitall!<cr>", { desc = "close application" })
vim.keymap.set("n", "<bs>z", "<cmd>tabclose<cr>", { silent = false, desc = "delete current buffer" })

-- (fuzzy) finder
vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
vim.keymap.set("n", "<localleader>fg", function() vscode.action "workbench.action.findInFiles" end)

--git
vim.keymap.set("n", "<leader>gg", function() vscode.action "workbench.view.scm" end)
vim.keymap.set("n", "<localleader>go", function() vscode.action "issue.openGithubPermalink" end)
vim.keymap.set("n", "<localleader>gy", function() vscode.action "issue.copyGithubPermalink" end)

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

-- terminal
vim.keymap.set("n", "<leader>wt", function() vscode.call "workbench.action.terminal.toggleTerminal" end)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
