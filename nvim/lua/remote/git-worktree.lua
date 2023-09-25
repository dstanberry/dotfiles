return {
  "ThePrimeagen/git-worktree.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>gl",
      function() require("telescope").extensions.git_worktree.git_worktrees() end,
      desc = "worktree: list linked tree(s)",
    },
    -- NOTE: creating new worktrees via cli is more robust
    -- {
    --   "<leader>ga",
    --   function() require("telescope").extensions.git_worktree.create_git_worktree() end,
    --   desc = "worktree: create new tree",
    -- },
  },
  config = function()
    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return end

    require("git-worktree").setup {}
    telescope.load_extension "git_worktree"
  end,
}
