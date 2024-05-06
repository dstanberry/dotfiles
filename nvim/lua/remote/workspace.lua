---@diagnostic disable: missing-fields

local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"

return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "tiagovla/scope.nvim", config = true },
    keys = {
      { "<leader>bg", ":BufferLineGroupToggle ", desc = "bufferline: toggle group" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "bufferline: toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "bufferline: delete all non-pinned buffers" },
    },
    init = function() groups.new("PanelHeading", { link = "Title" }) end,
    config = function()
      local bufferline_groups = require "bufferline.groups"
      local bufferline = require "bufferline"
      bufferline.setup {
        highlights = function(defaults)
          local hl = util.reduce(defaults.highlights, function(highlight, attrs, name)
            local formatted = name:lower()
            local is_group = formatted:match "group"
            local is_offset = formatted:match "offset"
            local is_separator = formatted:match "separator"
            if not is_group or (is_group and is_separator) then attrs.bg = c.bg2 end
            if is_separator and not (is_group or is_offset) then attrs.fg = c.bg2 end
            highlight[name] = attrs
            return highlight
          end)
          hl.buffer_selected.italic = false
          hl.buffer_visible.bold = true
          hl.buffer_visible.italic = false
          hl.buffer_visible.fg = c.gray1
          hl.tab_selected.bold = true
          hl.tab_selected.fg = c.red1
          return hl
        end,
        options = {
          style_preset = { bufferline.style_preset.minimal },
          mode = "buffers",
          numbers = "none",
          left_mouse_command = "buffer %d",
          ---@diagnostic disable-next-line: assign-type-mismatch
          right_mouse_command = nil,
          middle_mouse_command = "bdelete! %d",
          close_command = "bdelete! %d",
          buffer_close_icon = icons.misc.Close,
          close_icon = icons.misc.CloseBold,
          hover = { enabled = true, reveal = { "close" } },
          left_trunc_marker = icons.misc.LeftArrowCircled,
          right_trunc_marker = icons.misc.RightArrowCircled,
          max_name_length = 20,
          color_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          sort_by = "insert_after_current",
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, _, ctx)
            if ctx.buffer:current() then return "" end
            return pad(icons.diagnostics.Warn, "left")
          end,
          indicator = {
            icon = pad(icons.misc.VerticalBarThin, "right"),
            style = "none",
          },
          offsets = {
            {
              text = pad(icons.documents.FolderOutlineClosed, "right") .. "EXPLORER",
              filetype = "neo-tree",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = pad(icons.groups.Sql, "right") .. "DATABASE VIEWER",
              filetype = "dbee",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = pad(icons.groups.Sql, "right") .. "DATABASE VIEWER",
              filetype = "dbui",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = pad(icons.groups.Diff, "right") .. "DIFF VIEW",
              filetype = "DiffviewFiles",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = pad(icons.groups.StackFrame, "right") .. "DEBUGGER",
              filetype = "dapui_scopes",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = pad(icons.groups.Tree, "right") .. "SYMBOLS",
              filetype = "trouble",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
          },
          groups = {
            items = {
              {
                name = "SQL",
                -- icon = icons.groups.Sql,
                auto_close = true,
                highlight = { fg = c.orange0 },
                matcher = function(buf) return buf.name:match "%.sql$" end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "Unit Tests",
                -- icon = icons.groups.Lab,
                highlight = { fg = c.yellow0 },
                auto_close = true,
                matcher = function(buf)
                  return buf.name:match "_spec%."
                    or buf.name:match "%.spec"
                    or buf.name:match "_test%."
                    or buf.name:match "%.test"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "Zettelkasten Notes",
                -- icon = icons.groups.Book,
                highlight = { fg = c.cyan1 },
                auto_close = true,
                matcher = function(buf)
                  return vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR) or buf.path:match "zettelkasten"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              bufferline_groups.builtin.pinned:with { icon = icons.groups.Pinned },
              bufferline_groups.builtin.ungrouped,
            },
          },
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local has_telescope, telescope = pcall(require, "telescope.pickers")
      local telescope_picker
      if has_telescope then
        telescope_picker = function(files)
          local file_paths = {}
          for _, item in ipairs(files.items) do
            table.insert(file_paths, item.value)
          end
          telescope
            .new(require("telescope.themes").get_ivy {}, {
              prompt_title = "Harpoon (marks)",
              finder = require("telescope.finders").new_table { results = file_paths },
              previewer = require("telescope.config").values.file_previewer {},
              sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
              layout_config = { height = 30, prompt_position = "top" },
            })
            :find()
        end
      end

      local keys = {
        { "<leader>ha", function() require("harpoon"):list():add() end, desc = "harpoon: mark file" },
        {
          "<leader>hf",
          function()
            local harpoon = require "harpoon"
            if has_telescope then
              telescope_picker(harpoon:list())
            else
              harpoon.ui:toggle_quick_menu(harpoon:list())
            end
          end,
          desc = "harpoon: find marks",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>h" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "harpoon: goto " .. i,
        })
      end
      return keys
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>fE",
        function() require("neo-tree.command").execute { toggle = true, dir = util.buffer.get_root() } end,
        desc = "neotree: browse root directory",
      },
      {
        "<localleader>fE",
        function() require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() } end,
        desc = "neotree: browse current directory",
      },
      {
        "-",
        function() require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() } end,
        desc = "neotree: browse current directory",
      },
    },
    deactivate = function() vim.cmd { cmd = "NeoTree", args = { "close" } } end,
    init = function()
      local GRAY = color.darken(c.gray0, 10)

      groups.new("NeoTreeTitleBar", { fg = c.bg2, bg = c.red1, bold = true })
      groups.new("NeoTreeFloatBorder", { fg = GRAY, bg = GRAY })
      groups.new("NeoTreeFloatNormal", { bg = GRAY })

      groups.new("NeoTreeNormal", { link = "NormalSB" })
      groups.new("NeoTreeNormalNC", { link = "NormalSB" })
      groups.new("NeoTreeTabActive", { fg = c.fg0, bg = c.bgX })
      groups.new("NeoTreeTabInactive", { fg = c.gray1, bg = c.bgX })
      groups.new("NeoTreeTabSeparatorActive", { fg = c.bgX, bg = c.bgX })
      groups.new("NeoTreeTabSeparatorInactive", { fg = c.bgX, bg = c.bgX })

      groups.new("NeoTreeFileName", { fg = color.lighten(c.gray2, 30) })
      groups.new("NeoTreeRootName", { link = "Directory" })

      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then require "neo-tree" end
      end
    end,
    opts = {
      sources = { "filesystem", "document_symbols" },
      source_selector = {
        winbar = true,
        separator_active = " ",
        sources = {
          { source = "filesystem", display_name = pad(icons.documents.MultipleFolders, "both", 1, 2) .. "Files " },
          { source = "document_symbols", display_name = pad(icons.kind.Class, "both", 1, 2) .. "Symbols " },
        },
      },
      enable_git_status = true,
      git_status_async = true,
      use_popups_for_input = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".DS_Store", "ntuser.*", "NTUSER.*" },
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["O"] = {
            command = function(state)
              local filepath = state.tree:get_node().path
              vim.ui.open(filepath)
            end,
            desc = "neotree: open file in system UI",
          },
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "neotree: copy path to clipboard",
          },
        },
      },
      document_symbols = {
        follow_cursor = true,
        kinds = util.reduce(vim.tbl_deep_extend("keep", icons.kind, icons.type), function(acc, v, k)
          acc[k] = { icon = v, hl = ("TroubleIcon%s"):format(k) }
          return acc
        end),
      },
      default_component_configs = {
        icon = {
          folder_closed = icons.documents.FolderClosed,
          folder_open = icons.documents.FolderOpened,
          folder_empty = icons.documents.FolderEmpty,
          folder_empty_open = icons.documents.FolderEmpty,
        },
        indent = {
          with_expanders = true,
          expander_collapsed = icons.misc.FoldClosed,
          expander_expanded = icons.misc.FoldOpened,
          expander_highlight = "NeoTreeExpander",
        },
        name = {
          highlight_opened_files = true,
        },
      },
    },
    config = function(_, opts)
      local function on_move(data) require("remote.lsp.handlers").on_rename(data.source, data.destination) end

      local events = require "neo-tree.events"
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then require("neo-tree.sources.git_status").refresh() end
        end,
      })
    end,
  },
  {
    "yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    init = function() groups.new("qfPosition", { link = "@markup.link" }) end,
  },
  {
    "folke/persistence.nvim",
    event = "LazyFile",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end, desc = "persistence: save session" },
      { "<leader>qS", function() require("persistence").stop() end, desc = "persistence: untrack session" },
      { "<leader>qr", function() require("persistence").load() end, desc = "persistence: restore session" },
      {
        "<leader>ql",
        function() require("persistence").load { last = true } end,
        desc = "persistence: restore last session",
      },
    },
  },
  {
    "windwp/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "spectre: replace in files" },
    },
    config = function()
      require("spectre").setup()

      groups.new("SpectreSearch", { fg = c.bg0, bg = c.rose0, bold = true })
      groups.new("SpectreReplace", { fg = c.bg0, bg = c.green0, bold = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("cursorline", { clear = true }),
        pattern = "spectre_panel",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
  },
  {
    "EthanJWright/vs-tasks.nvim",
    name = "vstask",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "LazyFile",
    keys = function()
      local has_telescope, telescope = pcall(require, "telescope")
      if not has_telescope then return {} end

      local themes = require "telescope.themes"

      local show_tasks = function()
        telescope.extensions.vstask.tasks(themes.get_dropdown {
          previewer = false,
          prompt_title = "Launch Task",
        })
      end

      return {
        { "<leader>ft", show_tasks, desc = "telescope: show vscode tasks" },
      }
    end,
    opts = {
      config_dir = ".vscode",
      -- json_parser = vim.json.decode,
      cache_json_conf = true,
      cache_strategy = "last",
      terminal = "toggleterm",
      term_opts = {
        current = {
          direction = "float",
        },
        tab = {
          direction = "tab",
        },
      },
      telescope_keys = {
        tab = "<c-t>",
        current = "<cr>",
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      direction = "float",
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.5
        end
      end,
      hide_numbers = true,
      autochdir = true,
      highlights = {
        Normal = { link = "Normal" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
      },
      float_opts = {
        border = "single",
        winblend = 0,
      },
      winbar = {
        enabled = false,
      },
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      close_on_exit = true,
      shell = has "win32" and "pwsh -NoLogo" or vim.o.shell,
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local Terminal = require("toggleterm.terminal").Terminal
          local float
          float = Terminal:new {
            direction = "float",
            on_open = function(term)
              vim.wo.sidescrolloff = 0
              vim.keymap.set(
                { "i", "n", "t" },
                "<a-w><a-t>",
                function() float:toggle() end,
                { buffer = term.bufnr, desc = "toggleterm: toggle float" }
              )
            end,
          }
          vim.keymap.set("n", "<a-w><a-t>", function() float:toggle() end, { desc = "toggleterm: toggle float" })

          local tab
          tab = Terminal:new {
            direction = "tab",
            on_open = function(term)
              vim.keymap.set(
                { "i", "n", "t" },
                "<a-w><a-y>",
                function() tab:toggle() end,
                { buffer = term.bufnr, desc = "toggleterm: toggle tab" }
              )
            end,
          }
          vim.keymap.set("n", "<a-w><a-y>", function() tab:toggle() end, { desc = "toggleterm: toggle tab" })

          local lazygit
          lazygit = Terminal:new {
            cmd = "lazygit",
            dir = "git_dir",
            hidden = true,
            direction = "tab",
            on_open = function(term)
              vim.wo.sidescrolloff = 0
              vim.keymap.set(
                { "i", "n", "t" },
                "<a-w><a-l>",
                function() lazygit:toggle() end,
                { buffer = term.bufnr, desc = "toggleterm: toggle float" }
              )
            end,
          }
          vim.keymap.set("n", "<a-w><a-l>", function() lazygit:toggle() end, { desc = "toggleterm: toggle lazygit" })
        end,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    branch = "dev",
    cmd = { "Trouble" },
    keys = {
      {
        "gD",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_definitions_float", "toggle" } } end,
        desc = "trouble: lsp definitions",
      },
      {
        "gI",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_implementations", "toggle", "preview.type=float" } } end,
        desc = "trouble: lsp implementations",
      },
      {
        "gR",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_references", "toggle", "preview.type=float" } } end,
        desc = "trouble: lsp references",
      },
      {
        "gS",
        function() vim.cmd { cmd = "Trouble", args = { "symbols", "toggle" } } end,
        desc = "trouble: lsp document symbols",
      },
      {
        "gT",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_type_definitions", "toggle", "preview.type=float" } } end,
        desc = "trouble: lsp type definitions",
      },
      {
        "gw",
        function() vim.cmd { cmd = "Trouble", args = { "diagnostics", "toggle", "filter.buf=0" } } end,
        desc = "trouble: document diagnostics",
      },
      {
        "gW",
        function() vim.cmd { cmd = "Trouble", args = { "diagnostics_float", "toggle" } } end,
        desc = "trouble: workspace diagnostics",
      },
      {
        "<localleader>ql",
        function() vim.cmd { cmd = "Trouble", args = { "loclist", "toggle" } } end,
        desc = "trouble: location list",
      },
      {
        "<localleader>qq",
        function() vim.cmd { cmd = "Trouble", args = { "qflist", "toggle" } } end,
        desc = "trouble: quickfix list",
      },
      {
        "<c-up>",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cprevious)
          end
        end,
        desc = "trouble: previous item",
      },
      {
        "<c-down>",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cnext)
          end
        end,
        desc = "trouble: next item",
      },
    },
    opts = {
      icons = {
        kinds = vim.tbl_extend(
          "keep",
          vim.tbl_map(function(kind) return pad(kind, "right") end, icons.kind),
          vim.tbl_map(function(kind) return pad(kind, "right") end, icons.type)
        ),
      },
      modes = {
        lsp_definitions_float = {
          mode = "lsp_definitions",
          preview = {
            type = "float",
            relative = "editor",
            position = { 0, -2 },
            size = { width = 0.4, height = 0.3 },
            zindex = 200,
          },
        },
        diagnostics_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
  },
}
