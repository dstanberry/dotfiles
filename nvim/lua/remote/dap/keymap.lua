---------------------------------------------------------------
-- => DAP keymaps
---------------------------------------------------------------
local map = require "util.map"

-- define keymaps
map.nnoremap("<localleader>db", function()
  require("dap").toggle_breakpoint()
end)
map.nnoremap("<localleader>dr", function()
  require("dap").repl_open()
end)
map.nnoremap("<localleader>dh", function()
  require("dap.ui.variables").hover()
end)
map.nnoremap("<f5>", function()
  require("dap").continue()
end)
map.nnoremap("<f10>", function()
  require("dap").step_over()
end)
