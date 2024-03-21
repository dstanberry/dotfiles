local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"
local handlers = require "remote.lsp.handlers"

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

return {
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
        function() require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() } end,
        desc = "neotree: browse current directory",
      },
      {
        "-",
        function() require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() } end,
        desc = "neotree: browse current directory",
      },
    },
    deactivate = function() vim.cmd { cmd = "NeoTree", args = { "close" } } end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
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
        },
      },
      document_symbols = {
        follow_cursor = true,
        kinds = util.map(vim.tbl_deep_extend("keep", icons.kind, icons.type), function(kinds, v, k)
          kinds[k] = { icon = v, hl = ("NavicIcons%s"):format(k) }
          return kinds
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
      local function on_move(data) handlers.on_rename(data.source, data.destination) end

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
}
