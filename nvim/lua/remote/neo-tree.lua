local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"

groups.new("NeoTreeNormal", { link = "NormalSB" })
groups.new("NeoTreeNormalNC", { link = "NormalSB" })
groups.new("NeoTreeTabActive", { fg = c.fg, bg = c.bg_alt })
groups.new("NeoTreeTabInactive", { fg = c.gray_lighter, bg = c.bg })
groups.new("NeoTreeTabSeparatorActive", { fg = c.fg, bg = c.bg_alt })
groups.new("NeoTreeTabSeparatorInactive", { fg = c.gray_dark, bg = c.bg })

groups.new("NeoTreeRootName", { fg = c.fg })

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
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = { winbar = true, separator_active = " " },
      enable_git_status = true,
      git_status_async = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
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
          ["<esc>"] = "revert_preview",
          ["o"] = "toggle_node",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = icons.misc.FoldClosed,
          expander_expanded = icons.misc.FoldOpened,
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
  },
}
