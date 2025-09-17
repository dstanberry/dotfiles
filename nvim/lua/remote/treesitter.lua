return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    branch = "main",
    build = ":TSUpdate",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSInstall", "TSLog", "TSUninstall", "TSUpdate" },
    init = function() end,
    opts = {
      ensure_installed = "all",
      highlight = {
        enable = true,
        disable = { "tmux" },
      },
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
    },
    config = function(_, opts)
      local ts = require "nvim-treesitter"

      ts.setup(opts)

      local installed = ts.get_installed "parsers"
      local highlight = vim.tbl_get(opts, "highlight", "enable")
      local indent = vim.tbl_get(opts, "indent", "enable")
      if highlight or indent then
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(event)
            local lang = vim.treesitter.language.get_lang(event.match)
            if not vim.tbl_contains(installed, lang) then return end
            if highlight then pcall(vim.treesitter.start) end
            if indent then vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()" end
          end,
        })
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
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
    branch = "main",
    event = "VeryLazy",
    opts = {},
    keys = function()
      -- stylua: ignore
      local move = {
        goto_next_start     = {["]b"] = "@codeblock.outer", ["]c"] = "@class.outer", ["]f"] = "@function.outer", ["]u"] = "@parameter.inner",},
        goto_next_end       = {["]B"] = "@codeblock.outer", ["]C"] = "@class.outer", ["]F"] = "@function.outer", ["]U"] = "@parameter.inner",},
        goto_previous_start = {["[b"] = "@codeblock.outer", ["[c"] = "@class.outer", ["[f"] = "@function.outer", ["[u"] = "@parameter.inner",},
        goto_previous_end   = {["[B"] = "@codeblock.outer", ["[C"] = "@class.outer", ["[F"] = "@function.outer", ["[U"] = "@parameter.inner",},
      }
      return ds.tbl_reduce(move, function(acc, rhs, lhs)
        return ds.tbl_reduce(rhs, function(acc2, query, key)
          local direction = (key:sub(1, 1) == "[") and "previous" or "next"
          local boundary = (key:sub(2, 2) == key:sub(2, 2):upper()) and "end" or "start"
          table.insert(acc2, {
            key,
            function() require("nvim-treesitter-textobjects.move")[lhs](query, "textobjects") end,
            desc = ("goto %s %s %s"):format(direction, query:match "@([^%.]+)" or "", boundary),
            mode = { "n", "o", "x" },
            silent = true,
          })
          return acc2
        end, acc)
      end, {})
    end,
    config = function(_, opts) require("nvim-treesitter-textobjects").setup(opts) end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = { [""] = require("rainbow-delimiters").strategy["global"] },
        query = { [""] = "rainbow-delimiters" },
        highlight = vim.tbl_map(function(i) return "SnacksIndent" .. i end, vim.fn.range(1, 8)),
      }
    end,
  },
}
