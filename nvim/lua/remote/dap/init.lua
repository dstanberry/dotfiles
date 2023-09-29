local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"

return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "jbyuki/one-small-step-for-vimkind",
    "mfussenegger/nvim-dap-python",
    { "mxsdev/nvim-dap-vscode-js", branch = "start-debugging" },
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  -- stylua: ignore
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "dap: toggle breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "dap: set conditional breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "dap: continue" },
    { "<leader>dC", function() require("dapui").float_element("console", { enter = true, width = 200, position = "center" }) end, desc = "dap: show console output" },
    { "<leader>de", function() require("dapui").eval() end, desc = "dap: evaluate" },
    { "<leader>dE", function() require("dapui").eval(vim.fn.input "Evaluate expression: ") end, desc = "dap: evaluate expression" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "dap: hover" },
    { "<leader>di", function() require("dap").step_into() end, desc = "dap: step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "dap: step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "dap: step out" },
    { "<leader>dt", function() require("dap").repl.toggle { height = 15 } end, desc = "dap: toggle repl" },
    { "<leader>dT", function() require("dap").terminate() end, desc = "dap: terminate" },
  },
  init = function()
    groups.new("DapBreakpointActiveLine", { bg = color.blend(c.yellow2, c.bg3, 0.14) })

    groups.new("DapUINormal", { link = "NormalSB" })
    groups.new("DapUIStop", { fg = c.red1 })
    groups.new("DapUIStopNC", { link = "DapUIStop" })
    groups.new("DapUIRestart", { fg = c.green1 })
    groups.new("DapUIRestartNC", { link = "DapUIRestart" })
    groups.new("DapUIStepOver", { fg = c.blue0 })
    groups.new("DapUIStepOverNC", { link = "DapUIStepOver" })
    groups.new("DapUIStepInto", { fg = c.blue0 })
    groups.new("DapUIStepIntoNC", { link = "DapUIStepInto" })
    groups.new("DapUIStepOut", { fg = c.blue0 })
    groups.new("DapUIStepOutNC", { link = "DapUIStepOut" })
    groups.new("DapUIStepBack", { fg = c.blue0 })
    groups.new("DapUIStepBackNC", { link = "DapUIStepBack" })
    groups.new("DapUIPlayPause", { fg = c.blue4 })
    groups.new("DapUIPlayPauseNC", { link = "DapUIPlayPause" })
    groups.new("DapUIUnavailable", { fg = c.gray2 })
    groups.new("DapUIUnavailableNC", { link = "DapUIUnavailable" })
    groups.new("DapUIThread", { fg = c.green0 })
    groups.new("DapUIThreadNC", { link = "DapUIThread" })
  end,
  config = function()
    local dap = require "dap"
    dap.defaults.fallback.terminal_win_cmd = "belowright 10new"
    vim.fn.sign_define("DapBreakpoint", {
      text = icons.debug.Breakpoint,
      texthl = "DiagnosticSignInfo",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
      text = icons.debug.BreakpointActive,
      texthl = "DiagnosticSignWarn",
      linehl = "DapBreakpointActiveLine",
      numhl = "",
    })
    local ok, dapvt = pcall(require, "nvim-dap-virtual-text")
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
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.30 },
              { id = "breakpoints", size = 0.30 },
              { id = "stacks", size = 0.20 },
              { id = "watches", size = 0.15 },
            },
            size = 50,
            position = "left",
          },
          {
            elements = { "repl" },
            size = 0.15,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = icons.debug.Pause,
            play = icons.debug.Continue,
            step_into = icons.debug.StepInto,
            step_over = icons.debug.StepOver,
            step_out = icons.debug.StepOut,
            step_back = icons.debug.StepBack,
            run_last = icons.debug.Restart,
            terminate = icons.debug.Stop,
          },
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
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end
    local debuggers = vim.api.nvim_get_runtime_file("lua/remote/dap/debuggers/*.lua", true)
    for _, file in ipairs(debuggers) do
      local mod = util.get_module_name(file)
      require(mod).setup()
    end
  end,
}
