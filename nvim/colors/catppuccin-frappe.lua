local theme = "catppuccin-frappe"

require("util").reload("ui.theme").setup(theme)

vim.g.colors_name = theme
vim.o.background = "dark"

local file = vim.api.nvim_get_runtime_file("lua/ui/theme/groups.lua", true)[1]

if file then
  vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
    group = vim.api.nvim_create_augroup("colorscheme", { clear = true }),
    pattern = file,
    callback = function() vim.cmd.colorscheme(theme) end,
  })
end
