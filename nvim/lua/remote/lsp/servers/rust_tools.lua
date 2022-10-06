-- verify rust-tools is available
local ok, rust_tools = pcall(require, "rust-tools")
if not ok then
  return
end

local icons = require "ui.icons"
local paths = require("remote.dap.debuggers.c").get_executable_path()

local M = {}

M.setup = function(rust_analyzer_config)
  local cfg = rust_analyzer_config or {}
  rust_tools.setup {
    tools = {
      executor = require("rust-tools.executors").termopen,
      on_initialized = nil,
      reload_workspace_from_cargo_toml = true,
      runnables = { use_telescope = true },
      debuggables = { use_telescope = true },
      autoSetHints = true,
      inlay_hints = {
        auto = false,
        only_current_line = false,
        only_current_line_autocmd = "CursorHold",
        show_parameter_hints = true,
        parameter_hints_prefix = ":",
        other_hints_prefix = icons.misc.RightArrow,
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      hover_actions = {
        auto_focus = true,
        border = "none",
      },
      crate_graph = {
        backend = "x11",
        output = nil,
        full = true,
      },
    },
    server = vim.tbl_deep_extend("force", cfg, {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "gk", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
        -- vim.keymap.set("n", "ga", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
      end,
    }),
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(paths.code, paths.library),
    },
  }
end

return M
