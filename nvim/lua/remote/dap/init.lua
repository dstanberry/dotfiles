-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local M = setmetatable({}, {
  __index = function(t, k)
    if k == 'widgets' then
      local val = require('dap.ui.widgets')
      rawset(t, k, val)
      return val
    end
    return dap[k]
  end,
})

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DiagnosticsError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "DiagnosticsWarn",
  linehl = "DiagnosticsWarn",
  numhl = "",
})

if pcall(require, "nvim-dap-virtual-text") then
  vim.g.dap_virtual_text = true
end

-- verify dap-ui is available
local dap_ui
ok, dap_ui = pcall(require, "dapui")
if not ok then
  return
end

dap_ui.setup {
  mappings = {
    expand = { "<cr>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    elements = {
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 0.25 },
    },
    size = 50,
    position = "left",
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom",
  },
  floating = {
    boder = "single",
    max_height = nil,
    max_width = nil,
    mappings = {
      close = { "q", "<esc>" },
    },
  },
  windows = { indent = 1 },
}

return M
