local groups = require "ui.theme.groups"

local CYAN = "#73c1b9"
local CYAN_LIGHT = "#80d3dd"
local PINK = "#dec7d0"
local ORANGE = "#e09696"
local YELLOW = "#ffdca8"
local MAGENTA = "#9086a4"
local MAGENTA_LIGHT = "#bfafc4"

groups.new("TSRainbow1", { fg = CYAN })
groups.new("TSRainbow2", { fg = CYAN_LIGHT })
groups.new("TSRainbow3", { fg = MAGENTA })
groups.new("TSRainbow4", { fg = MAGENTA_LIGHT })
groups.new("TSRainbow5", { fg = PINK })
groups.new("TSRainbow6", { fg = ORANGE })
groups.new("TSRainbow7", { fg = YELLOW })

vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("typescript", "typescriptreact")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function() require "remote.treesitter.context" end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs { "move", "select", "swap", "lsp_interop" } do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects" end
        end,
      },
      "HiPhish/nvim-ts-rainbow2",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/playground",
      "theHamsta/nvim-treesitter-pairs",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        highlight = {
          enable = true,
          use_languagetree = false,
          -- disable = { "markdown" },
        },
        indent = { enabled = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "=",
            node_incremental = "gn",
            scope_incremental = "<c-a>",
            node_decremental = "gp",
          },
        },
        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = {},
          highlight_self = false,
          goto_right_end = false,
          keymaps = {
            goto_partner = "%",
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        rainbow = {
          enable = true,
          query = "rainbow-parens",
          disable = { "typescriptreact" },
          strategy = { require "ts-rainbow.strategy.local" },
          hlgroups = {
            "TSRainbow1",
            "TSRainbow2",
            "TSRainbow3",
            "TSRainbow4",
            "TSRainbow5",
            "TSRainbow6",
            "TSRainbow7",
          },
        },
      }
    end,
  },
}
