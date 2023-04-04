local theme = "kdark"

require("util").reload("ui.theme").setup(theme)

vim.g.colors_name = theme
vim.o.background = "dark"

local file = vim.api.nvim_get_runtime_file("lua/ui/theme/groups.lua", true)[1]

if file then
  vim.api.nvim_create_augroup("colorscheme_kdark", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
    group = "colorscheme_kdark",
    pattern = file,
    callback = function() vim.cmd.colorscheme "kdark" end,
  })
end
