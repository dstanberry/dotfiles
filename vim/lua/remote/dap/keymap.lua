---------------------------------------------------------------
-- => DAP Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, 'dap') then
  return
end

-- define keymaps
local opts = {silent = true}

MAP("n", "<localleader>db", "require('dap').toggle_breakpoint()", opts)
MAP("n", "<localleader>dr", "require('dap').repl_open()", opts)
MAP("n", "<localleader>dh", "require('dap.ui.variables').hover()", opts)
MAP("n", "<f5>", "require('dap').continue()", opts)
MAP("n", "<f10>", "require('dap').step_over()", opts)
