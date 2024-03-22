local groups = require "ui.theme.groups"

groups.new("TreesitterContext", { link = "Normal" })
groups.new("TreesitterContextLineNumber", { link = "LineNr" })
groups.new("TreesitterContextSeparator", { link = "NonText" })

-- vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("typescript", "typescriptreact")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          multiline_threshold = 4,
          separator = "─",
          mode = "topline",
          patterns = {
            lua = { "table" },
          },
        },
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
          local configs = require "nvim-treesitter.configs"
          for name, fn in pairs(move) do
            if name:find "goto" == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find "[%]%[][cC]" then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
      "nvim-treesitter/playground",
      "theHamsta/nvim-treesitter-pairs",
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-a>", desc = "treesitter: increment selection" },
      { "<bs", desc = "treesitter: decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = "all",
      highlight = { enable = true },
      indent = { enabled = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-a>",
          node_incremental = "<c-a>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      pairs = {
        enable = true,
        disable = {},
        highlight_pair_events = {},
        highlight_self = false,
        fallback_cmd_normal = "normal! %",
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
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    config = function(_, opts) pcall(require("nvim-treesitter.configs").setup, opts) end,
  },
}
