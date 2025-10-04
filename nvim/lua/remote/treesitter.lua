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
          group = ds.augroup "remote.treesitter",
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
    opts = {
      select = {
        lookahead = false,
        lookbehind = false,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
      -- stylua: ignore
      keys = {
        goto_next_start = { ["]b"] = "@codeblock.outer", ["]c"] = "@class.outer", ["]f"] = "@function.outer", ["]u"] = "@parameter.inner" },
        goto_next_end = { ["]B"] = "@codeblock.outer", ["]C"] = "@class.outer", ["]F"] = "@function.outer", ["]U"] = "@parameter.inner" },
        goto_previous_start = { ["[b"] = "@codeblock.outer", ["[c"] = "@class.outer", ["[f"] = "@function.outer", ["[u"] = "@parameter.inner" },
        goto_previous_end = { ["[B"] = "@codeblock.outer", ["[C"] = "@class.outer", ["[F"] = "@function.outer", ["[U"] = "@parameter.inner" },
        swap_next = { ["]s"] = "@parameter.inner" },
        swap_previous = { ["[s"] = "@parameter.inner" },
      },
    },
    config = function(_, opts)
      local ts = require "nvim-treesitter-textobjects"
      if not ts.setup then return ds.error "`nvim-treesitter-textobjects` is out of date. Please update it." end
      ts.setup { move = opts.move or {}, select = opts.seleect or {} }

      vim.api.nvim_create_autocmd("FileType", {
        group = ds.augroup "remote.treesitter.textobjects",
        callback = function(args)
          if not ds.treesitter.has(args.match, "textobjects") then return end
          ds.tbl_each(opts.keys or {}, function(queries, name)
            local is_move = name:sub(1, 4) == "goto"
            local mode = is_move and { "n", "o", "x" } or { "n" }
            ds.tbl_each(queries, function(query, lhs)
              local direction = (lhs:sub(1, 1) == "[") and "previous" or "next"
              local label = (query:match "@([^%.]+)") or ""
              local desc = is_move
                  and ("goto %s %s %s"):format(direction, label, name:find "_end$" and "end" or "start")
                or ("swap %s %s"):format(direction, label)
              local rhs = function()
                local mod = require("nvim-treesitter-textobjects." .. (is_move and "move" or "swap"))
                if is_move then
                  mod[name](query, "textobjects")
                else
                  mod[name](query)
                end
              end
              -- don't use if in diff mode and the key is one of the c/C keys
              if not (vim.wo.diff and lhs:find "[cC]") then
                vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc, silent = true })
              end
            end)
          end)
        end,
      })
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
