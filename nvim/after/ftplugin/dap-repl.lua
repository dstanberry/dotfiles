local dap = require "dap"

require("dap.ext.autocompl").attach()

vim.keymap.set("i", "<c-h>", "<c-w>h", { buffer = true, desc = "dap: goto left window" })
vim.keymap.set("i", "<c-j>", "<c-w>j", { buffer = true, desc = "dap: goto lower window" })
vim.keymap.set("i", "<c-k>", "<c-w>k", { buffer = true, desc = "dap: goto upper window" })
vim.keymap.set("i", "<c-l>", "<c-w>l", { buffer = true, desc = "dap: goto right window" })

vim.keymap.set("i", "<f2>", function()
  dap.step_into()
  vim.cmd.startinsert()
end, { buffer = true, desc = "dap: step into" })

vim.keymap.set("i", "<f3>", function()
  dap.step_out()
  vim.cmd.startinsert()
end, { buffer = true, desc = "dap: step out" })

vim.keymap.set("i", "<f4>", function()
  dap.step_over()
  vim.cmd.startinsert()
end, { buffer = true, desc = "dap: step over" })

vim.keymap.set("i", "<f5>", function()
  dap.continue()
  vim.cmd.startinsert()
end, { buffer = true, desc = "dap: continue" })

vim.keymap.set("i", "<f10>", dap.terminate, { buffer = true, desc = "dap: terminate" })
