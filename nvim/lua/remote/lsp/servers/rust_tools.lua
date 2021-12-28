-- verify rust-tools is available
local ok, rust_tools = pcall(require, "rust-tools")
if not ok then
  return
end

local paths = require("remote.dap.debuggers.c").get_executable_path()

local M = {}

M.setup = function(rust_analyzer_config)
  rust_tools.setup {
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      executor = require("rust-tools.executors").termopen,
      inlay_hints = {
        only_current_line = false,
        -- only_current_line_autocmd = "CursorHold",
        show_parameter_hints = true,
        parameter_hints_prefix = ":",
        other_hints_prefix = "→ ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      hover_actions = {
        auto_focus = true,
      },
      crate_graph = {
        backend = "x11",
        output = nil,
        full = true,
      },
    },
    server = rust_analyzer_config,
    dap = {
      adapter = {
        require("rust-tools.dap").get_codelldb_adapter(paths.code, paths.library),
      },
    },
  }
end

return M
