return {
  { "mfussenegger/nvim-dap-python", lazy = true },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    keys = function()
      local function get_args(config)
        local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
        config = vim.deepcopy(config)
        config.args = function()
          local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
          return vim.split(vim.fn.expand(new_args), " ")
        end
        return config
      end

      local function _breakpoint() require("dap").toggle_breakpoint() end
      local function _conditional() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end
      local function _args() require("dap").continue { before = get_args } end
      local function _run() require("dap").continue() end
      -- stylua: ignore start
      ---@diagnostic disable-next-line: missing-fields
      local function _console() require("dapui").float_element("console", { enter = true, width = 200, position = "center" }) end
      -- stylua: ignore end
      local function _eval() require("dapui").eval() end
      local function _expr() require("dapui").eval(vim.fn.input "Evaluate expression: ") end
      local function _hover() require("dap.ui.widgets").hover() end
      local function _into() require("dap").step_into() end
      local function _over() require("dap").step_over() end
      local function _out() require("dap").step_out() end
      local function _repl() require("dap").repl.toggle { height = 15 } end
      local function _stop() require("dap").terminate() end
      local function _ui() require("dapui").toggle() end
      local function _watch() require("dapui").elements.watches.add() end

      return {
        { "<leader>db", _breakpoint, desc = "dap: toggle breakpoint" },
        { "<leader>dB", _conditional, desc = "dap: set conditional breakpoint" },
        { "<leader>da", _args, desc = "dap: run with args" },
        { "<leader>dc", _run, desc = "dap: run / continue" },
        { "<leader>dC", _console, desc = "dap: show console output" },
        { "<leader>de", _eval, desc = "dap: evaluate" },
        { "<leader>dE", _expr, desc = "dap: evaluate expression" },
        { "<leader>dh", _hover, desc = "dap: hover" },
        { "<leader>di", _into, desc = "dap: step into" },
        { "<leader>do", _over, desc = "dap: step over" },
        { "<leader>dO", _out, desc = "dap: step out" },
        { "<leader>dt", _repl, desc = "dap: toggle repl" },
        { "<leader>dT", _stop, desc = "dap: terminate" },
        { "<leader>du", _ui, desc = "dap: toggle ui" },
        { "<leader>dw", _watch, desc = "dap: add to watches" },
      }
    end,
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      local dapvt = require "nvim-dap-virtual-text"

      dap.defaults.fallback.terminal_win_cmd = "belowright 10new"
      dap.set_log_level "ERROR"

      local _signs = {
        Breakpoint = ds.icons.debug.Breakpoint,
        BreakpointCondition = ds.icons.debug.BreakpointConditional,
        BreakpointRejected = { ds.icons.debug.BreakpointRejected, "DiagnosticError" },
        LogPoint = ds.icons.debug.BreakpointLog,
        Stopped = { ds.icons.debug.BreakpointActive, "DiagnosticWarn", "DapBreakpointActiveLine" },
      }
      for name, sign in pairs(_signs) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      vim.g.dap_virtual_text = true
      dapvt.setup {
        enabled = true,
        enabled_commands = true,
        commented = false,
        show_stop_reason = true,
        virt_text_pos = "inline",
        display_callback = function(variable, _, _, _, options)
          if options.virt_text_pos == "inline" then
            return string.format(" = %s", variable.value)
          else
            return string.format("%s = %s", variable.name, variable.value)
          end
        end,
      }

      ---@diagnostic disable-next-line: missing-fields
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
            pause = ds.icons.debug.Pause,
            play = ds.icons.debug.Continue,
            step_into = ds.icons.debug.StepInto,
            step_over = ds.icons.debug.StepOver,
            step_out = ds.icons.debug.StepOut,
            step_back = ds.icons.debug.StepBack,
            run_last = ds.icons.debug.Restart,
            terminate = ds.icons.debug.Stop,
          },
        },
        floating = {
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

      ---@diagnostic disable-next-line: duplicate-set-field
      require("dap.ext.vscode").json_decode = function(str)
        return vim.json.decode(require("plenary.json").json_strip_comments(str))
      end

      local root = "remote/dap/debuggers"
      ds.fs.walk(root, function(path, name, kind)
        if (kind == "file" or kind == "link") and name:match "%.lua$" then
          local ok, mod = pcall(require, ds.get_module(path))
          if ok and mod.setup then mod.setup() end
        end
      end)
    end,
  },
}
