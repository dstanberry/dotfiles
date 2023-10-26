return {
  "dstanberry/harpoon",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "VeryLazy",
  config = function()
    local mark = require "harpoon.mark"
    local ui = require "harpoon.ui"

    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return end

    local themes = require "telescope.themes"

    telescope.load_extension "harpoon"
    vim.keymap.set(
      "n",
      "<leader>hf",
      function()
        telescope.extensions.harpoon.marks(themes.get_dropdown {
          previewer = false,
          prompt_title = "Harpoon (marks)",
        })
      end,
      { desc = "harpoon: find marks" }
    )

    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "harpoon: mark file" })
    vim.keymap.set("n", "<leader>hh", ui.nav_next, { desc = "harpoon: next file" })
    vim.keymap.set("n", "<leader>hl", ui.nav_prev, { desc = "harpoon: previous file" })
  end,
}
