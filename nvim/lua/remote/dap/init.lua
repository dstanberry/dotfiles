local get_args = function(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
    return vim.split(vim.fn.expand(new_args), " ")
  end
  return config
end

return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "jbyuki/one-small-step-for-vimkind",
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  -- stylua: ignore
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "dap: toggle breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "dap: set conditional breakpoint" },
    { "<leader>da", function() require("dap").continue({before = get_args}) end, desc = "dap: run with args" },
    { "<leader>dc", function() require("dap").continue() end, desc = "dap: run / continue" },
    ---@diagnostic disable-next-line: missing-fields
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
    ds.hl.new("DapBreakpointActiveLine", { bg = ds.color.blend(vim.g.ds_colors.yellow2, vim.g.ds_colors.bg3, 0.14) })

    ds.hl.new("DapUINormal", { link = "NormalSB" })
    ds.hl.new("DapUIStop", { fg = vim.g.ds_colors.red1 })
    ds.hl.new("DapUIStopNC", { link = "DapUIStop" })
    ds.hl.new("DapUIRestart", { fg = vim.g.ds_colors.green1 })
    ds.hl.new("DapUIRestartNC", { link = "DapUIRestart" })
    ds.hl.new("DapUIStepOver", { fg = vim.g.ds_colors.blue0 })
    ds.hl.new("DapUIStepOverNC", { link = "DapUIStepOver" })
    ds.hl.new("DapUIStepInto", { fg = vim.g.ds_colors.blue0 })
    ds.hl.new("DapUIStepIntoNC", { link = "DapUIStepInto" })
    ds.hl.new("DapUIStepOut", { fg = vim.g.ds_colors.blue0 })
    ds.hl.new("DapUIStepOutNC", { link = "DapUIStepOut" })
    ds.hl.new("DapUIStepBack", { fg = vim.g.ds_colors.blue0 })
    ds.hl.new("DapUIStepBackNC", { link = "DapUIStepBack" })
    ds.hl.new("DapUIPlayPause", { fg = vim.g.ds_colors.blue4 })
    ds.hl.new("DapUIPlayPauseNC", { link = "DapUIPlayPause" })
    ds.hl.new("DapUIUnavailable", { fg = vim.g.ds_colors.gray2 })
    ds.hl.new("DapUIUnavailableNC", { link = "DapUIUnavailable" })
    ds.hl.new("DapUIThread", { fg = vim.g.ds_colors.green0 })
    ds.hl.new("DapUIThreadNC", { link = "DapUIThread" })
  end,
  config = function()
    local dap = require "dap"
    dap.defaults.fallback.terminal_win_cmd = "belowright 10new"
    vim.fn.sign_define("DapBreakpoint", {
      text = vim.g.ds_icons.debug.Breakpoint,
      texthl = "DiagnosticSignInfo",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
      text = vim.g.ds_icons.debug.BreakpointActive,
      texthl = "DiagnosticSignWarn",
      linehl = "DapBreakpointActiveLine",
      numhl = "",
    })

    vim.g.dap_virtual_text = true
    require("nvim-dap-virtual-text").setup {
      enabled = true,
      enabled_commands = true,
      commented = false,
      show_stop_reason = true,
      -- virt_text_pos = "eol",
      virt_text_pos = "inline",
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "inline" then
          return string.format(" = %s", variable.value)
        else
          return string.format("%s = %s", variable.name, variable.value)
        end
      end,
    }

    local dapui = require "dapui"
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
          pause = vim.g.ds_icons.debug.Pause,
          play = vim.g.ds_icons.debug.Continue,
          step_into = vim.g.ds_icons.debug.StepInto,
          step_over = vim.g.ds_icons.debug.StepOver,
          step_out = vim.g.ds_icons.debug.StepOut,
          step_back = vim.g.ds_icons.debug.StepBack,
          run_last = vim.g.ds_icons.debug.Restart,
          terminate = vim.g.ds_icons.debug.Stop,
        },
      },
      ---@diagnostic disable-next-line: missing-fields
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

    local json = require "plenary.json"
    local vscode = require "dap.ext.vscode"

    ---@diagnostic disable-next-line: duplicate-set-field
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

    local extras = { base = "nvim/lua/", root = "remote/dap/debuggers" }
    local start = extras.base .. extras.root
    ds.walk(start, function(path, name, type)
      if (type == "file" or type == "link") and name:match "%.lua$" then
        name = path:sub(#start + 2, -5):gsub("/", ".")
        require(extras.root:gsub("/", ".") .. "." .. name).setup()
      end
    end)
  end,
}
