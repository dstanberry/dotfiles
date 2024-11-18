return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "=", desc = "treesitter: increment selection" },
      { "<bs>", desc = "treesitter: decrement selection", mode = "x" },
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
      textobjects = {
        move = {
          enable = true,
          -- NOTE: matches mnemonic used in |mini.ai| configuration
          -- f[u]nction parameter | [f]unction | [c]lass
          goto_next_start = { ["]u"] = "@parameter.inner", ["]c"] = "@class.outer", ["]f"] = "@function.outer" },
          goto_next_end = { ["]U"] = "@parameter.inner", ["]C"] = "@class.outer", ["]F"] = "@function.outer" },
          goto_previous_start = { ["[u"] = "@parameter.inner", ["[c"] = "@class.outer", ["[f"] = "@function.outer" },
          goto_previous_end = { ["[U"] = "@parameter.inner", ["[C"] = "@class.outer", ["[F"] = "@function.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["]s"] = "@parameter.inner" },
          swap_previous = { ["[s"] = "@parameter.inner" },
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
    config = function(_, opts) pcall(require("nvim-treesitter.configs").setup, opts) end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
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
    "theHamsta/nvim-treesitter-pairs",
    keys = {
      { "%", function() require("nvim-treesitter.pairs").goto_partner() end, desc = "treesitter: goto partner" },
      { "X", function() require("nvim-treesitter.pairs").delete_balanced() end, desc = "treesitter: delete balanced" },
    },
    config = function()
      local nvim_treesitter_configs = require "nvim-treesitter.configs"
      ---@diagnostic disable-next-line: missing-fields
      nvim_treesitter_configs.setup {
        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = { "CursorMoved" },
          highlight_self = false,
          fallback_cmd_normal = "normal! %",
          goto_right_end = false,
          keymaps = {
            goto_partner = "%",
            delete_balanced = "X",
          },
          delete_balanced = {
            only_on_first_char = false,
            fallback_cmd_normal = nil,
            longest_partner = false,
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      if ds.plugin.is_loaded "nvim-treesitter" then
        local opts = ds.plugin.get_opts "nvim-treesitter"
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup { textobjects = opts.textobjects or {} }
      end
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
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = { [""] = require("rainbow-delimiters").strategy["global"] },
        query = { [""] = "rainbow-delimiters" },
        highlight = { "TSRainbow1", "TSRainbow2", "TSRainbow3", "TSRainbow4", "TSRainbow5", "TSRainbow6", "TSRainbow7" },
      }
    end,
  },
}
