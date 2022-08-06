local telescope = require "remote.telescope"

vim.keymap.set("n", "<localleader><localleader>", telescope.find_nvim)
vim.keymap.set("n", "<leader><leader>", telescope.project_files)
vim.keymap.set("n", "<leader>f/", telescope.grep_last_search)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fe", telescope.file_browser)
vim.keymap.set("n", "<leader>ff", telescope.current_buffer)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fgg", telescope.rg.live_grep_with_shortcuts)
vim.keymap.set("n", "<leader>fk", telescope.help_tags)
vim.keymap.set("n", "<leader>fp", telescope.find_plugins)

vim.keymap.set("n", "<localleader>wd", telescope.lsp_document_symbols)
vim.keymap.set("n", "<localleader>ws", telescope.lsp_dynamic_workspace_symbols)
vim.keymap.set("n", "<leader>wd", telescope.diagnostics)
vim.keymap.set("n", "<leader>ws", telescope.lsp_workspace_symbols)
vim.keymap.set("n", "<leader>wr", telescope.lsp_references)
