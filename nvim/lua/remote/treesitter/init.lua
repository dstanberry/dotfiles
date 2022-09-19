-- verify nvim-treesitter is available
if not pcall(require, "nvim-treesitter") then
  return
end

local c = require("ui.theme").colors
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
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>v",
      node_incremental = "gn",
      scope_incremental = "ga",
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
      goto_partner = "<localleader>%",
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
    colors = {
      c.CYAN,
      c.CYAN_LIGHT,
      c.MAGENTA,
      c.MAGENTA_LIGHT,
      c.PINK,
      c.ORANGE,
      c.YELLOW,
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "g<space>",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "<leader>gd",
        list_definitions = "<leader>gl",
        list_definitions_toc = "<leader>gO",
        goto_next_usage = "<leader>gr",
        goto_previous_usage = "<leader>gR",
      },
    },
  },
  textobjects = {
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]}"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]{"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[{"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[}"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ii"] = "@parameter.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<a-s><a-l>"] = "@parameter.inner",
        ["<a-s><a-j>"] = "@function.outer",
      },
      swap_previous = {
        ["<a-s><a-h>"] = "@parameter.inner",
        ["<a-s><a-k>"] = "@function.outer",
      },
    },
  },
}

-- setup custom parsers
require "remote.treesitter.parsers"
