return {
  "folke/todo-comments.nvim",
  cmd = { "TodoQuickFix", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    sign_priority = 0,
  },
}
