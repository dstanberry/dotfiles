return {
  "windwp/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- stylua: ignore
  keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "spectre: replace in files" },
  },
}
