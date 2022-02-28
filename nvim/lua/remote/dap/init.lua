-- verify dap is available
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local util = require "util"

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
  dap.defaults.fallback.terminal_win_cmd = "belowright 10new"

  vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })
  vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "DiagnosticSignWarn",
    linehl = "IncSearch",
    numhl = "",
  })

  local dapvt
  ok, dapvt = pcall(require, "nvim-dap-virtual-text")
  if ok then
    dapvt.setup {
      enabled = true,
      enabled_commands = true,
      commented = false,
      show_stop_reason = true,
      virt_text_pos = "eol",
    }
    vim.g.dap_virtual_text = true
  end

  local dapui
  ok, dapui = pcall(require, "dapui")
  if ok then
    dapui.setup {
      mappings = {
        expand = { "<cr>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
      },
      sidebar = {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        size = 50,
        position = "left",
      },
      tray = {
        elements = { "repl" },
        size = 15,
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

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end

  local debuggers = vim.api.nvim_get_runtime_file("lua/remote/dap/debuggers/*.lua", true)
  for _, file in ipairs(debuggers) do
    local mod = util.get_module_name(file)
    require(mod).setup()
  end

  vim.api.nvim_create_augroup { name = "dap-repl", clear = true }

  vim.api.nvim_create_autocmd {
    group = "dap-repl",
    event = "FileType",
    pattern = "dap-repl",
    callback = require("dap.ext.autocompl").attach,
  }
end

return M
