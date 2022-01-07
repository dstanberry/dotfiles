local dap = require "remote.dap"

vim.keymap.set("n", "<c-s-b>", dap.toggle_breakpoint)
vim.keymap.set("n", "<c-s-h>", dap.widgets.hover)

vim.keymap.set("n", "<f3>", function()
  dap.disconnect { terminateDebuggee = true }
  dap.close()
  -- (hack) because event listener does not always fire
  require("dapui").close()
end)

vim.keymap.set("n", "<f5>", dap.continue)
vim.keymap.set("n", "<f6>", dap.step_into)
vim.keymap.set("n", "<f7>", dap.step_out)
vim.keymap.set("n", "<f10>", dap.step_over)

vim.keymap.set("n", "<f12>", function()
  dap.repl.toggle { height = 15 }
end)
