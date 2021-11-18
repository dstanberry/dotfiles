-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local M = setmetatable({}, {
  __index = function(t, k)
    if k == "widgets" then
      local val = require "dap.ui.widgets"
      rawset(t, k, val)
      return val
    end
    return dap[k]
  end,
})

M.setup = function()
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

  local dap_ui
  ok, dap_ui = pcall(require, "dapui")
  if ok then
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
  end

  local snippets = vim.api.nvim_get_runtime_file("lua/remote/dap/debuggers/*.lua", true)
  for _, file in ipairs(snippets) do
    local fname = (file):match "^.+/(.+)$"
    local mod = fname:sub(1, -5)
    require(("remote.dap.debuggers.%s"):format(mod)).setup()
  end
end

return M
