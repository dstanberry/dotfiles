---@class remote.snacks.util.picker
local M = {}

---@module "snacks"

local trouble = ds.plugin.is_installed "trouble.nvim"
    and {
      actions = { trouble_open = function(...) return require("trouble.sources.snacks").actions(...) end },
      keys = { ["<c-q>"] = { "trouble_open", mode = { "i", "n" } } },
    }
  or { actions = {}, keys = {} }

local kind_filter = {
  help = false,
  markdown = false,
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
}

M.config = function()
  local layouts = require "snacks.picker.config.layouts"

  layouts.telescope_wide = vim.deepcopy(layouts.telescope)
  ---@diagnostic disable-next-line: assign-type-mismatch
  layouts.telescope_wide.layout.backdrop = true
  layouts.telescope_wide.layout[1][1].title = ""
  layouts.telescope_wide.layout[1][2].border = "top"
  layouts.telescope_wide.layout[1][2].height = 2
  layouts.telescope_wide.layout[2].width = 0.6

  layouts.vertical_compact = vim.deepcopy(layouts.vertical)
  layouts.vertical_compact.layout.min_width = 120
  layouts.vertical_compact.layout.height = 0.5
  layouts.vertical_compact.layout[3].height = 0.7

  layouts.vertical_wide = vim.deepcopy(layouts.vertical_compact)
  layouts.vertical_wide.layout.height = 0.7

  layouts.vscode.layout.row = 0
  layouts.vscode.layout.border = vim.tbl_map(
    function(icon) return { icon, "SnacksPickerBorderSB" } end,
    ds.icons.border.Default
  )

  return {
    prompt = ds.pad(ds.icons.misc.Prompt, "right"),
    icons = {
      kinds = vim.tbl_deep_extend("keep", ds.icons.kind, ds.icons.type),
    },
    win = {
      input = {
        keys = vim.tbl_extend("force", trouble.keys, {
          ["<a-c>"] = { "toggle_cwd", mode = { "i", "n" } },
          ["<c-/>"] = { "toggle_help", mode = { "i", "n" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-f>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-n>"] = false,
          ["<c-u>"] = { "<c-s-u>", expr = true, mode = "i" },
          ["jk"] = { "close", mode = "i" },
        }),
      },
    },
    actions = vim.tbl_extend("force", trouble.actions, {
      ---@param p snacks.Picker
      toggle_cwd = function(p)
        local root = ds.root.get { buf = p.input.filter.current_buf, normalize = true }
        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
        local current = p:cwd()
        p:set_cwd(current == root and cwd or root)
        p:find()
      end,
    }),
    sources = {
      buffers = {
        layout = { preset = "vertical_compact" },
      },
      command_history = {
        layout = { preset = "vscode" },
      },
      files = {
        prompt = ds.pad(ds.icons.misc.Prompt, "both"),
        layout = { preset = "telescope_wide" },
      },
      grep = {
        layout = { preset = "vertical_wide" },
      },
      grep_buffers = {
        layout = { preset = "ivy" },
      },
      help = {
        layout = { preset = "ivy" },
      },
      lazy = {
        prompt = ds.pad(ds.icons.misc.Prompt, "both"),
        layout = { preset = "vertical_wide" },
      },
      registers = {
        layout = { preset = "vscode", preview = true },
      },
      spelling = {
        layout = { preset = "vscode" },
      },
      todo_comments = {
        layout = { preset = "vertical_wide" },
      },
      lsp_declarations = {
        layout = { preset = "vertical_wide" },
      },
      lsp_definitions = {
        layout = { preset = "vertical_wide" },
      },
      lsp_implementations = {
        layout = { preset = "vertical_wide" },
      },
      lsp_references = {
        layout = { preset = "vertical_wide" },
      },
      lsp_symbols = {
        filter = kind_filter,
        layout = { preset = "vertical_wide" },
      },
      lsp_type_definitions = {
        layout = { preset = "vertical_wide" },
      },
      lsp_workspace_symbols = {
        filter = kind_filter,
        layout = { preset = "vertical_wide" },
      },
    },
  }
end

M.file_browser = function()
  local cwd = vim.fn.expand "%:p:h"
  Snacks.picker.files {
    cwd = cwd,
    layout = { preset = "vscode" },
    actions = {
      parent = {
        action = function(picker, _)
          cwd = vim.loop.fs_realpath(vim.fs.joinpath(cwd, ".."))
          picker:set_cwd(cwd)
          picker:find()
        end,
      },
    },
    win = {
      input = {
        keys = {
          ["<c-w>"] = { "parent", mode = "i" },
          ["-"] = { "parent", mode = "n" },
        },
      },
    },
  }
end

return M
