local telescope = require "remote.telescope"

-- standard
vim.keymap.set("n", "<leader><leader>", telescope.project_files)
vim.keymap.set("n", "<leader>f/", telescope.grep_last_search)
vim.keymap.set("n", "<leader>fe", telescope.file_browser)
vim.keymap.set("n", "<leader>ff", telescope.current_buffer)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fk", telescope.help_tags)
vim.keymap.set("n", "<leader>fp", telescope.find_plugins)
vim.keymap.set("n", "<leader>fr", telescope.oldfiles)

-- analagous to `<leader>` maps but with customizations
vim.keymap.set("n", "<localleader><leader>", telescope.find_nvim)
vim.keymap.set("n", "<localleader>fe", telescope.file_browser_relative)
vim.keymap.set("n", "<localleader>fg", telescope.rg.live_grep_with_shortcuts)

-- lsp handlers
vim.keymap.set("n", "gw", function()
  telescope.diagnostics({ bufnr = 0 })
end)
vim.keymap.set("n", "gW", telescope.diagnostics)

-- custom commands
vim.api.nvim_create_user_command("BCommits", telescope.git_bcommits, {})
vim.api.nvim_create_user_command("Commits", telescope.git_commits, {})
vim.api.nvim_create_user_command("Buffers", function()
  telescope.buffers { sort_lastused = true }
end, {})
