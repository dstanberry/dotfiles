---------------------------------------------------------------
-- => Tree-Sitter Configuration
---------------------------------------------------------------
-- verify tree-sitter is available
if not pcall(require, "nvim-treesitter") then
  return
end

-- set default options
require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",
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
  rainbow = {
    enable = false,
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = false,
      keymaps = { smart_rename = "<leader>g/" },
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
