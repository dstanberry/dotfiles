local dap = require "remote.dap"

require("dap.ext.autocompl").attach()

vim.keymap.set("i", "<c-h>", "<c-w>h")
vim.keymap.set("i", "<c-j>", "<c-w>j")
vim.keymap.set("i", "<c-k>", "<c-w>k")
vim.keymap.set("i", "<c-l>", "<c-w>l")

vim.keymap.set("i", "<f2>", function()
  dap.step_into()
  vim.cmd "startinsert"
end)
vim.keymap.set("i", "<f3>", function()
  dap.step_out()
  vim.cmd "startinsert"
end)
vim.keymap.set("i", "<f4>", function()
  dap.step_over()
  vim.cmd "startinsert"
end)
vim.keymap.set("i", "<f5>", function()
  dap.continue()
  vim.cmd "startinsert"
end)
vim.keymap.set("i", "<f10>", dap.terminate)