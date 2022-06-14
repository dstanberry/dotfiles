local theme = "kdark"

require("util").reload("ui.theme").setup(theme)

vim.g.colors_name = theme
vim.o.background = "dark"
