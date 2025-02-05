---@class remote.snacks.util.picker
local M = {}

---@module "snacks"

local trouble = ds.plugin.is_installed "trouble.nvim"
    and {
      actions = {
        trouble_open = function(...) return require("trouble.sources.snacks").actions.trouble_open.action(...) end,
      },
      keys = { ["<c-q>"] = { "trouble_open", mode = { "i", "n" } } },
    }
  or { actions = {}, keys = {} }

M.config = function()
  local layouts = require "snacks.picker.config.layouts"

  layouts.select.layout.border = vim.tbl_map(
    function(icon) return { icon, "SnacksPickerBorderSB" } end,
    ds.icons.border.Default
  )

  ---@diagnostic disable-next-line: assign-type-mismatch
  layouts.telescope.layout.backdrop = true
  layouts.telescope.layout[1][1].title = ""
  layouts.telescope.layout[1][2].border = "top"
  layouts.telescope.layout[1][2].height = 2
  layouts.telescope.layout[2].width = 0.6

  layouts.vertical.layout.height = 0.7
  layouts.vertical.layout.min_width = 120
  layouts.vertical.layout[3].height = 0.7

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
      buffers = { layout = "ivy" },
      command_history = { layout = "vscode" },
      files = { prompt = ds.pad(ds.icons.misc.Prompt, "both"), layout = "telescope" },
      git_log = { layout = "vertical" },
      grep = { layout = "vertical" },
      grep_buffers = { layout = "ivy" },
      help = { layout = "ivy" },
      lazy = { prompt = ds.pad(ds.icons.misc.Prompt, "both"), layout = "vertical" },
      lsp_declarations = { layout = "vertical" },
      lsp_definitions = { layout = "vertical" },
      lsp_implementations = { layout = "vertical" },
      lsp_references = { layout = "vertical" },
      lsp_symbols = { layout = "vertical" },
      lsp_type_definitions = { layout = "vertical" },
      lsp_workspace_symbols = { layout = "vertical" },
      registers = { layout = { preset = "vscode", preview = true } },
      spelling = { layout = "vscode" },
      todo_comments = { layout = "vertical" },
    },
  }
end

M.file_browser = function()
  local cwd = vim.fn.expand "%:p:h"
  Snacks.picker.files {
    cwd = cwd,
    layout = "vscode",
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
