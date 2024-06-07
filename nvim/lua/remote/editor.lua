local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

return {
  {
    "monaqa/dial.nvim",
    keys = {
      { "<c-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "dial: increment" },
      { "<c-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "dial: decrement" },
    },
    config = function()
      local augend = require "dial.augend"
      local config = require "dial.config"

      local ordinal_numbers = augend.constant.new {
        elements = {
          "first",
          "second",
          "third",
          "fourth",
          "fifth",
          "sixth",
          "seventh",
          "eighth",
          "ninth",
          "tenth",
        },
        word = false,
        cyclic = true,
      }

      local weekdays = augend.constant.new {
        elements = {
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday",
        },
        word = true,
        cyclic = true,
      }

      local months = augend.constant.new {
        elements = {
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        },
        word = true,
        cyclic = true,
      }

      config.augends:register_group {
        default = {
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new {
            elements = {
              "True",
              "False",
            },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          ordinal_numbers,
          weekdays,
          months,
        },
        markdown = {
          augend.misc.alias.markdown_header,
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new {
            elements = {
              "True",
              "False",
            },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          ordinal_numbers,
          weekdays,
          months,
        },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "LazyFile",
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "flash: search" },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "flash: treesitter search",
      },
      { "r", mode = "o", function() require("flash").remote() end, desc = "flash: remote op" },
      {
        "R",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "flash: treesitter remote op",
      },
    },
    opts = {
      modes = {
        char = {
          enabled = true,
          keys = { "f", "F", "t", "T", [";"] = "<c-right>", [","] = "<c-left>" },
        },
        search = { enabled = false },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = function()
      return {
        library = {
          uv = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "luvit-meta", "library"),
        },
      }
    end,
  },
  -- Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
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
      ds.on_load("which-key.nvim", function()
        local mini_motions = function()
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
        vim.schedule(mini_motions)
      end)
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4",
        auto_insert_mode = true,
        show_help = true,
        question_header = string.format("%s %s ", icons.misc.User, user),
        answer_header = string.format("%s %s ", icons.kind.Copilot, "Copilot"),
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require "CopilotChat.select"
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = function()
      local keys = {
        {
          "<leader>cc",
          mode = { "n", "v" },
          function() return require("CopilotChat").toggle() end,
          desc = "copilot: toggle chat",
        },
        {
          "<leader>ca",
          mode = { "n", "v" },
          function()
            local input = vim.fn.input "Ask Copilot: "
            if input ~= "" then require("CopilotChat").ask(input) end
          end,
          desc = "copilot: quick chat",
        },
        {
          "<leader>cx",
          mode = { "n", "v" },
          function() return require("CopilotChat").reset() end,
          desc = "copilot: clear history",
        },
      }
      return keys
    end,
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
      ds.on_load("telescope.nvim", function()
        vim.keymap.set({ "n", "v" }, "<leader>cd", function()
          local actions = require "CopilotChat.actions"
          local help = actions.help_actions()
          if not help then
            print "no diagnostics found on the current line"
            return
          end
          require("CopilotChat.integrations.telescope").pick(help)
        end, { desc = "copilot: show diagnostics help" })
        vim.keymap.set({ "n", "v" }, "<leader>cp", function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end, { desc = "copilot: show available actions" })
      end)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "petertriho/cmp-git",
      "saadparwaiz1/cmp_luasnip",
      -- snippets manager
      "L3MON4D3/LuaSnip",
      -- LLM
      {
        "zbirenbaum/copilot-cmp",
        url = "https://github.com/dstanberry/copilot-cmp",
        dependencies = {
          "zbirenbaum/copilot.lua",
          cmd = "Copilot",
          build = ":Copilot auth",
          opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = { ["*"] = true },
            server_opts_overrides = {
              settings = {
                advanced = {
                  debug = { acceptselfSignedCertificate = true },
                },
              },
            },
          },
        },
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require "copilot_cmp"
          copilot_cmp.setup(opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              if not (args.data and args.data.client_id) then return end
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "copilot" then copilot_cmp._on_insert_enter {} end
            end,
          })
        end,
      },
    },
    opts = function()
      local cmp = require "cmp"
      return {
        enabled = function()
          local context = require "cmp.config.context"
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          elseif buftype == "prompt" then
            return false
          else
            return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
          end
        end,
        experimental = {
          ghost_text = true,
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, item)
            item.menu = ds.pad(item.kind, "both")
            item.kind = ds.pad(icons.kind[item.kind], "both")
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert {
          -- NOTE: superceded by noice.nvim
          -- ["<c-d>"] = cmp.mapping.scroll_docs(4),
          -- ["<c-f>"] = cmp.mapping.scroll_docs(-4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<c-c>"] = cmp.mapping.close(),
          ["<cr>"] = cmp.mapping.confirm { select = true },
        },
        snippet = {
          expand = function(args)
            pcall(function() require("luasnip").lsp_expand(args.body) end)
          end,
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority_weight = 120, group_index = 1 },
          { name = "luasnip", priority_weight = 100, group_index = 1 },
          { name = "copilot", priority = 100, group_index = 1 },
          { name = "path", priority_weight = 90, group_index = 1 },
          { name = "buffer", priority_weight = 50, keyword_length = 5, max_view_entries = 5, group_index = 2 },
        },
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        window = {
          completion = {
            border = icons.border.ThinBlock,
            winhighlight = "Normal:FloatBorder,FloatBorder:FloatBorderSB,CursorLine:PmenuSel",
          },
          documentation = {
            border = icons.border.ThinBlock,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorderSB",
          },
        },
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)

      local BLUE = color.lighten(c.blue2, 15)
      local BLUE_DARK = color.darken(c.blue2, 35)

      groups.new("CmpItemAbbrDefault", { fg = c.white })
      groups.new("CmpItemAbbrDeprecatedDefault", { fg = c.white })
      groups.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
      groups.new("CmpItemAbbrMatchFuzzyDefault", { fg = c.orange0, bold = true })
      groups.new("CmpItemMenu", { fg = BLUE_DARK })

      groups.new("CmpItemKindClass", { link = "@lsp.type.class" })
      groups.new("CmpItemKindConstant", { link = "@constant" })
      groups.new("CmpItemKindConstructor", { link = "@constructor" })
      groups.new("CmpItemKindCopilot", { fg = c.green0 })
      groups.new("CmpItemKindDefault", { fg = c.white })
      groups.new("CmpItemKindEnum", { link = "@lsp.type.enum" })
      groups.new("CmpItemKindEnumMember", { link = "@lsp.type.enumMember" })
      groups.new("CmpItemKindEvent", { link = "@boolean" })
      groups.new("CmpItemKindField", { link = "@variable.member" })
      groups.new("CmpItemKindFile", { link = "Directory" })
      groups.new("CmpItemKindFolder", { link = "Directory" })
      groups.new("CmpItemKindFunction", { link = "@lsp.type.function" })
      groups.new("CmpItemKindInterface", { link = "@lsp.type.interface" })
      groups.new("CmpItemKindKeyword", { link = "@keyword" })
      groups.new("CmpItemKindMethod", { link = "@lsp.type.method" })
      groups.new("CmpItemKindModule", { link = "@module" })
      groups.new("CmpItemKindOperator", { link = "@operator" })
      groups.new("CmpItemKindProperty", { link = "@property" })
      groups.new("CmpItemKindReference", { link = "@markup.link" })
      groups.new("CmpItemKindSnippet", { fg = c.purple0 })
      groups.new("CmpItemKindStruct", { link = "@lsp.type.struct" })
      groups.new("CmpItemKindText", { link = "@markup" })
      groups.new("CmpItemKindTypeParameter", { link = "@lsp.type.parameter" })
      groups.new("CmpItemKindUnit", { link = "SpecialChar" })
      groups.new("CmpItemKindValue", { link = "@markup" })
      groups.new("CmpItemKindVariable", { link = "@variable" })
    end,
  },
}
