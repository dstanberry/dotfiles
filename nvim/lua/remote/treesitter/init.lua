-- verify nvim-treesitter is available
if not pcall(require, "nvim-treesitter") then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

c.tree00 = "#73c1b9"
c.tree01 = "#80d3dd"
c.tree02 = "#9086a4"
c.tree03 = "#bfafc4"
c.tree04 = "#dec7d0"
c.tree05 = "#e09696"
c.tree06 = "#ffdca8"

groups.new("TSRainbow1", { guifg = c.tree00, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow2", { guifg = c.tree01, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow3", { guifg = c.tree02, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow4", { guifg = c.tree03, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow5", { guifg = c.tree04, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow6", { guifg = c.tree05, guibg = "none", gui = "none", guisp = nil })
groups.new("TSRainbow7", { guifg = c.tree06, guibg = "none", gui = "none", guisp = nil })

require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  highlight = {
    enable = true,
    use_languagetree = false,
    disable = {},
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
      c.tree00,
      c.tree01,
      c.tree02,
      c.tree03,
      c.tree04,
      c.tree05,
      c.tree06,
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
        ["]s"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]e"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[s"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[e"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
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
