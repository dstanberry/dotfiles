local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local map = require "util.map"

map.nnoremap("<localleader>db", function()
  dap.toggle_breakpoint()
end)
map.nnoremap("<localleader>dr", function()
  dap.repl_open()
end)
map.nnoremap("<localleader>dh", function()
  require("dap.ui.widgets").hover()
end)
map.nnoremap("<localleader>dq", function()
  dap.stop()
end)

map.nnoremap("<f5>", function()
  dap.continue()
end)
map.nnoremap("<f6>", function()
  dap.step_into()
end)
map.nnoremap("<f7>", function()
  dap.step_out()
end)
map.nnoremap("<f10>", function()
  dap.step_over()
end)
