ds.hl.new("TreesitterContext", { link = "Normal" })
ds.hl.new("TreesitterContextLineNumber", { link = "LineNr" })
ds.hl.new("TreesitterContextSeparator", { link = "NonText" })

-- vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("typescript", "typescriptreact")

return {
  {
    "nvim-treesitter/nvim-treesitter",
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
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0,
    version = false,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "=", desc = "treesitter: increment selection" },
      { "<bs>", desc = "treesitter: decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = "all",
      highlight = { enable = true },
      indent = { enabled = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "=",
          node_incremental = "=",
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
          goto_next_start = { ["]a"] = "@parameter.inner", ["]c"] = "@class.outer", ["]f"] = "@function.outer" },
          goto_next_end = { ["]A"] = "@parameter.inner", ["]C"] = "@class.outer", ["]F"] = "@function.outer" },
          goto_previous_start = { ["[a"] = "@parameter.inner", ["[c"] = "@class.outer", ["[f"] = "@function.outer" },
          goto_previous_end = { ["[A"] = "@parameter.inner", ["[C"] = "@class.outer", ["[F"] = "@function.outer" },
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
  {
    "windwp/nvim-ts-autotag",
    event = { "LazyFile", "VeryLazy" },
    opts = {},
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "LazyFile", "VeryLazy" },
    init = function()
      local CYAN = "#73c1b9"
      local CYAN_LIGHT = "#80d3dd"
      local PINK = "#dec7d0"
      local ORANGE = "#e09696"
      local YELLOW = "#ffdca8"
      local MAGENTA = "#9086a4"
      local MAGENTA_LIGHT = "#bfafc4"

      ds.hl.new("TSRainbow1", { fg = CYAN })
      ds.hl.new("TSRainbow2", { fg = ORANGE })
      ds.hl.new("TSRainbow3", { fg = MAGENTA })
      ds.hl.new("TSRainbow4", { fg = CYAN_LIGHT })
      ds.hl.new("TSRainbow5", { fg = PINK })
      ds.hl.new("TSRainbow6", { fg = MAGENTA_LIGHT })
      ds.hl.new("TSRainbow7", { fg = YELLOW })
    end,
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
        },
        highlight = {
          "TSRainbow1",
          "TSRainbow2",
          "TSRainbow3",
          "TSRainbow4",
          "TSRainbow5",
          "TSRainbow6",
          "TSRainbow7",
        },
      }
    end,
  },
}
