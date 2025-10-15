---@class remote.snacks.stash.picker
local M = {}

---@return snacks.picker.Config
local _config = function()
  local layouts = require "snacks.picker.config.layouts"

  layouts.select.layout.border = vim.tbl_map(
    function(icon) return { icon, "SnacksPickerBorderSB" } end,
    ds.icons.border.Default
  )

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

  local flash = { actions = {}, keys = {} }
  local trouble = { actions = {}, keys = {} }

  if ds.plugin.is_installed "flash.nvim" then
    flash = {
      actions = {
        flash = function(picker)
          require("flash").jump {
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          }
        end,
      },
      keys = { ["<a-s>"] = { "flash", mode = { "i", "n" } }, ["s"] = { "flash" } },
    }
  end

  if ds.plugin.is_installed "trouble.nvim" then
    trouble = {
      actions = {
        trouble_open = function(...) return require("trouble.sources.snacks").actions.trouble_open.action(...) end,
      },
      keys = { ["<c-q>"] = { "trouble_open", mode = { "i", "n" } } },
    }
  end

  ---@module 'snacks.nvim'
  ---@type snacks.picker.Config
  return {
    icons = { kinds = vim.tbl_deep_extend("keep", ds.icons.kind, ds.icons.type) },
    prompt = ds.pad(ds.icons.misc.Prompt, "right"),
    actions = vim.tbl_extend("force", flash.actions, trouble.actions, {
      toggle_cwd = function(p) ---@param p snacks.Picker
        local root = ds.root.get { buf = p.input.filter.current_buf, normalize = true }
        local cwd = vim.fs.normalize(vim.uv.cwd() or ".")
        local current = p:cwd()
        p:set_cwd(current == root and cwd or root)
        p:find()
      end,
    }),
    sources = {
      buffers = { layout = { preset = "ivy" } },
      command_history = { layout = { preset = "vscode" } },
      explorer = { hidden = true, ignored = true },
      files = { prompt = ds.pad(ds.icons.misc.Prompt, "both"), layout = { preset = "telescope" } },
      git_log = { layout = { preset = "vertical" } },
      git_status = { layout = { preset = "ivy" } },
      grep = { layout = { preset = "vertical" } },
      grep_buffers = { layout = { preset = "ivy" } },
      help = { layout = { preset = "ivy" } },
      lazy = { layout = { preset = "vertical" } },
      lsp_config = { layout = { preset = "vertical" } },
      lsp_declarations = { layout = { preset = "vertical" } },
      lsp_definitions = { layout = { preset = "vertical" } },
      lsp_implementations = { layout = { preset = "vertical" } },
      lsp_references = { layout = { preset = "vertical" } },
      lsp_symbols = { layout = { preset = "vertical" } },
      lsp_type_definitions = { layout = { preset = "vertical" } },
      lsp_workspace_symbols = { layout = { preset = "vertical" } },
      registers = { layout = { preset = "vscode" } },
      spelling = { layout = { preset = "select" } },
      todo_comments = { layout = { preset = "vertical" } },
    },
    win = {
      input = {
        keys = vim.tbl_extend("force", flash.keys, trouble.keys, {
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
  }
end

M.config = _config()

M.file_browser = function()
  local cwd = vim.fn.expand "%:p:h"
  Snacks.picker.files {
    cwd = cwd,
    layout = { preset = "vscode", preview = true },
    actions = {
      parent = {
        action = function(picker, _)
          cwd = vim.uv.fs_realpath(vim.fs.joinpath(cwd, ".."))
          picker:set_cwd(cwd)
          picker:find()
        end,
      },
    },
    win = {
      input = {
        keys = {
          ["<a-c>"] = false,
          ["-"] = { "parent", mode = "n" },
        },
      },
    },
  }
end

M.git_diff_tree = function()
  Snacks.picker.pick {
    layout = "ivy",
    preview = "file",
    title = "Git Branch Modification(s)",
    finder = function(opts, ctx)
      local root = Snacks.git.get_root()
      return require("snacks.picker.source.proc").proc({
        opts,
        {
          cmd = "git",
          args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD@{u}..HEAD", "-r" },
          transform = function(item)
            item.cwd = root
            item.file = item.text
          end,
        },
      }, ctx)
    end,
  }
end

return M
