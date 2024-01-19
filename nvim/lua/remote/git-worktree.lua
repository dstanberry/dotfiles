return {
  "polarmutex/git-worktree.nvim",
  event = "VeryLazy",
  config = function()
    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return end

    local themes = require "telescope.themes"

    require("git-worktree").setup {}
    telescope.load_extension "git_worktree"

    vim.keymap.set(
      "n",
      "<leader>gl",
      function()
        telescope.extensions.git_worktree.git_worktree(themes.get_dropdown {
          previewer = false,
          prompt_title = "Switch to a Git Working Tree",
        })
      end,
      { desc = "git-worktree: switch to a worktree" }
    )

    vim.keymap.set(
      "n",
      "<leader>ga",
      function()
        telescope.extensions.git_worktree.create_git_worktree(themes.get_dropdown {
          previewer = false,
          prompt_title = "Create a Git Working Tree",
        })
      end,
      { desc = "git-worktree: create a worktree" }
    )
  end,
}
