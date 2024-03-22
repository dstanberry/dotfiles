return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line "$",
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      if require("lazy.core.config").plugins["which-key.nvim"] ~= nil then
        local i = {
          [" "] = "mini.ai: whitespace",
          ['"'] = 'mini.ai: balanced "',
          ["'"] = "mini.ai: balanced '",
          ["`"] = "mini.ai: balanced `",
          ["("] = "mini.ai: balanced (",
          [")"] = "mini.ai: balanced ) including white-space",
          [">"] = "mini.ai: balanced > including white-space",
          ["<lt>"] = "mini.ai: balanced <",
          ["]"] = "mini.ai: balanced ] including white-space",
          ["["] = "mini.ai: balanced [",
          ["}"] = "mini.ai: balanced } including white-space",
          ["{"] = "mini.ai: balanced {",
          ["?"] = "mini.ai: user prompt",
          _ = "mini.ai: underscore",
          a = "mini.ai: argument",
          b = "mini.ai: balanced ), ], }",
          c = "mini.ai: class",
          d = "mini.ai: digit(s)",
          e = "mini.ai: word with (camel/snake) case",
          f = "mini.ai: function",
          g = "mini.ai: entire buffer",
          o = "mini.ai: block, conditional, loop",
          q = "mini.ai: quote `, \", '",
          t = "mini.ai: tag",
          u = "mini.ai: use/call function and method",
          U = "mini.ai: use/call without dot in function name",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end
        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs { n = "next", p = "previous" } do
          ---@diagnostic disable-next-line: assign-type-mismatch
          i[key] = vim.tbl_extend("force", { name = "mini.ai: inside " .. name .. " textobject" }, ic)
          ---@diagnostic disable-next-line: assign-type-mismatch
          a[key] = vim.tbl_extend("force", { name = "mini.ai: around " .. name .. " textobject" }, ac)
        end
        require("which-key").register {
          mode = { "o", "x" },
          i = i,
          a = a,
        }
      end
    end,
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = { enable_autocmd = false },
      },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "mini.surround: add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "mini.surround: delete surrounding" },
        { opts.mappings.find, desc = "mini.surround: find right surrounding" },
        { opts.mappings.find_left, desc = "mini.surround: find left surrounding" },
        { opts.mappings.highlight, desc = "mini.surround: highlight surrounding" },
        { opts.mappings.replace, desc = "mini.surround: replace surrounding" },
        { opts.mappings.update_n_lines, desc = "mini.surround: update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "ysa",
        delete = "ysd",
        find = "ysf",
        find_left = "ysF",
        highlight = "ysh",
        replace = "ysr",
        update_n_lines = "ysn",
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = {
      { "gJ", desc = "mini.splitjoin: split arguments" },
      { "gj", desc = "mini.splitjoin: join arguments" },
    },
    opts = {
      mappings = {
        toggle = "",
        split = "gJ",
        join = "gj",
      },
    },
    config = function(_, opts) require("mini.splitjoin").setup(opts) end,
  },
}
