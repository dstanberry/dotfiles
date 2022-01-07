local util = require "util"

vim.api.nvim_add_user_command("S", util.buffer.create_scratch, {})
vim.api.nvim_add_user_command("W", util.buffer.sudo_write, {})
