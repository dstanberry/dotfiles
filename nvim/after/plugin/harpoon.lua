--verify harpoon is available
local ok, harpoon = pcall(require, "harpoon")
if not ok then
  return
end

local mark = require "harpoon.mark"
local ui = require "harpoon.ui"

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local themes = require "telescope.themes"

if has_telescope then
  telescope.load_extension "harpoon"
  vim.keymap.set("n", "<leader>fh", function()
    telescope.extensions.harpoon.marks(themes.get_dropdown {
      previewer = false,
      prompt_title = "Harpoon (marks)",
    })
  end)
end

vim.keymap.set("n", "<localleader>ha", mark.add_file)
vim.keymap.set("n", "<localleader>.", ui.nav_next)
vim.keymap.set("n", ".<localleader>", ui.nav_prev)
