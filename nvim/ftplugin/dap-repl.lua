local dap = require "dap"

require("dap.ext.autocompl").attach()

vim.keymap.set("i", "<c-h>", "<c-w>h", { buffer = 0, desc = "dap: goto left window" })
vim.keymap.set("i", "<c-j>", "<c-w>j", { buffer = 0, desc = "dap: goto lower window" })
vim.keymap.set("i", "<c-k>", "<c-w>k", { buffer = 0, desc = "dap: goto upper window" })
vim.keymap.set("i", "<c-l>", "<c-w>l", { buffer = 0, desc = "dap: goto right window" })

vim.keymap.set("i", "<leader>di", function()
  dap.step_into()
  vim.cmd.startinsert()
end, { buffer = 0, desc = "dap: step into" })

vim.keymap.set("i", "<leader>do", function()
  dap.step_over()
  vim.cmd.startinsert()
end, { buffer = 0, desc = "dap: step over" })

vim.keymap.set("i", "<leader>dO", function()
  dap.step_out()
  vim.cmd.startinsert()
end, { buffer = 0, desc = "dap: step out" })

vim.keymap.set("i", "<leader>dc", function()
  dap.continue()
  vim.cmd.startinsert()
end, { buffer = 0, desc = "dap: continue" })

vim.keymap.set("i", "<leader>dT", dap.terminate, { buffer = 0, desc = "dap: terminate" })