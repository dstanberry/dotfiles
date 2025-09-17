return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local ts = require "nvim-treesitter"
      if not ts.get_installed then return ds.error "`nvim-treesitter` is out of date. Please update it." end
      ts.update(nil, { summary = true })
    end,
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
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
      if not ts.get_installed then
        return ds.error "`nvim-treesitter` is out of date. Please update it."
      elseif vim.fn.executable "tree-sitter" == 0 then
        return ds.error {
          "**treesitter-main** requires the `tree-sitter` CLI executable to be installed.",
          "Run `:checkhealth nvim-treesitter` for more information.",
        }
      end
      ts.setup(opts)

      local installed = ts.get_installed "parsers"
      local highlight = vim.tbl_get(opts, "highlight", "enable")
      local indent = vim.tbl_get(opts, "indent", "enable")
      if highlight or indent then
        vim.api.nvim_create_autocmd("FileType", {
          group = ds.augroup "treesitter",
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
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
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
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find "[cC]" then return vim.cmd("normal! " .. key) end
              require("nvim-treesitter-textobjects.move")[lhs](query, "textobjects")
            end,
            desc = ("goto %s %s %s"):format(direction, query:match "@([^%.]+)" or "", boundary),
            mode = { "n", "o", "x" },
            silent = true,
          })
          return acc2
        end, acc)
      end, {})
    end,
    opts = {},
    config = function(_, opts)
      local ts = require "nvim-treesitter-textobjects"
      if not ts.setup then return ds.error "`nvim-treesitter-textobjects` is out of date. Please update it." end
      ts.setup(opts)
    end,
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
