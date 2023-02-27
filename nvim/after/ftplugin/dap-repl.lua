local dap = require "dap"

require("dap.ext.autocompl").attach()

-- stylua: ignore
vim.keymap.set("i", "<c-h>", "<c-w>h", { buffer = vim.api.nvim_get_current_buf(), desc = "dap: goto left window" })
-- stylua: ignore
vim.keymap.set( "i", "<c-j>", "<c-w>j", { buffer = vim.api.nvim_get_current_buf(), desc = "dap: goto lower window" })
-- stylua: ignore
vim.keymap.set( "i", "<c-k>", "<c-w>k", { buffer = vim.api.nvim_get_current_buf(), desc = "dap: goto upper window" })
-- stylua: ignore
vim.keymap.set( "i", "<c-l>", "<c-w>l", { buffer = vim.api.nvim_get_current_buf(), desc = "dap: goto right window" })

vim.keymap.set("i", "<f2>", function()
  dap.step_into()
  vim.cmd.startinsert()
end, { buffer = vim.api.nvim_get_current_buf(), desc = "dap: step into" })

vim.keymap.set("i", "<f3>", function()
  dap.step_out()
  vim.cmd.startinsert()
end, { buffer = vim.api.nvim_get_current_buf(), desc = "dap: step out" })

vim.keymap.set("i", "<f4>", function()
  dap.step_over()
  vim.cmd.startinsert()
end, { buffer = vim.api.nvim_get_current_buf(), desc = "dap: step over" })

vim.keymap.set("i", "<f5>", function()
  dap.continue()
  vim.cmd.startinsert()
end, { buffer = vim.api.nvim_get_current_buf(), desc = "dap: continue" })

vim.keymap.set("i", "<f10>", dap.terminate, { buffer = vim.api.nvim_get_current_buf(), desc = "dap: terminate" })
