local dap = require "dap"

require("dap.ext.autocompl").attach()

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("i", "<c-h>", "<c-w>h", { buffer = bufnr, desc = "dap: goto left window" })
vim.keymap.set("i", "<c-j>", "<c-w>j", { buffer = bufnr, desc = "dap: goto lower window" })
vim.keymap.set("i", "<c-k>", "<c-w>k", { buffer = bufnr, desc = "dap: goto upper window" })
vim.keymap.set("i", "<c-l>", "<c-w>l", { buffer = bufnr, desc = "dap: goto right window" })

vim.keymap.set("i", "<leader>di", function()
  dap.step_into()
  vim.cmd.startinsert()
end, { buffer = bufnr, desc = "dap: step into" })

vim.keymap.set("i", "<leader>do", function()
  dap.step_over()
  vim.cmd.startinsert()
end, { buffer = bufnr, desc = "dap: step over" })

vim.keymap.set("i", "<leader>dO", function()
  dap.step_out()
  vim.cmd.startinsert()
end, { buffer = bufnr, desc = "dap: step out" })

vim.keymap.set("i", "<leader>dc", function()
  dap.continue()
  vim.cmd.startinsert()
end, { buffer = bufnr, desc = "dap: continue" })

vim.keymap.set("i", "<leader>dT", dap.terminate, { buffer = bufnr, desc = "dap: terminate" })
