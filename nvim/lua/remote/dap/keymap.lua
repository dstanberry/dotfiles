local dap = require "dap"
local dapwidgets = require "dap.ui.widgets"
local dapui = require "dapui"

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dh", dapwidgets.hover)

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end)
vim.keymap.set("n", "<leader>dE", function()
  dapui.eval(vim.fn.input "Evaluate expression: ")
end)

vim.keymap.set("n", "<f1>", dapui.eval)
vim.keymap.set("n", "<f2>", dap.step_into)
vim.keymap.set("n", "<f3>", dap.step_out)
vim.keymap.set("n", "<f4>", dap.step_over)
vim.keymap.set("n", "<f5>", dap.continue)
vim.keymap.set("n", "<f10>", dap.terminate)

vim.keymap.set("n", "<f12>", function()
  dap.repl.toggle { height = 15 }
end)
