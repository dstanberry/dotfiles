return {
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
        question_header = string.format("%s %s ", ds.icons.misc.User, user),
        answer_header = string.format("%s %s ", ds.icons.kind.Copilot, "Copilot"),
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
        { "<leader>c", mode = { "n", "v" }, "", desc = "+copilot" },
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
      ds.plugin.on_load("telescope.nvim", function()
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
  -- Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },
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
      "L3MON4D3/LuaSnip",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = {
          "zbirenbaum/copilot.lua",
          build = ":Copilot auth",
          cmd = "Copilot",
          opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = { ["*"] = true },
            server_opts_overrides = {
              settings = { advanced = { debug = { acceptselfSignedCertificate = true } } },
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
            item.kind = ds.pad(ds.icons.kind[item.kind], "both")
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert {
          -- NOTE: superceded by noice.nvim
          -- ["<c-d>"] = cmp.mapping.scroll_docs(4),
          -- ["<c-f>"] = cmp.mapping.scroll_docs(-4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<c-@>"] = cmp.mapping.complete(),
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
            border = ds.icons.border.Default,
            winhighlight = "Normal:FloatBorder,FloatBorder:FloatBorderSB,CursorLine:PmenuSel",
          },
          documentation = {
            border = ds.icons.border.Default,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorderSB",
          },
        },
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)

      local BLUE = ds.color.lighten(vim.g.ds_colors.blue2, 15)
      local BLUE_DARK = ds.color.darken(vim.g.ds_colors.blue2, 35)

      ds.hl.new("CmpItemAbbrDefault", { fg = vim.g.ds_colors.white })
      ds.hl.new("CmpItemAbbrDeprecatedDefault", { fg = vim.g.ds_colors.white })
      ds.hl.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
      ds.hl.new("CmpItemAbbrMatchFuzzyDefault", { fg = vim.g.ds_colors.orange0, bold = true })
      ds.hl.new("CmpItemMenu", { fg = BLUE_DARK })

      ds.hl.new("CmpItemKindClass", { link = "@lsp.type.class" })
      ds.hl.new("CmpItemKindConstant", { link = "@constant" })
      ds.hl.new("CmpItemKindConstructor", { link = "@constructor" })
      ds.hl.new("CmpItemKindCopilot", { fg = vim.g.ds_colors.green0 })
      ds.hl.new("CmpItemKindDefault", { fg = vim.g.ds_colors.white })
      ds.hl.new("CmpItemKindEnum", { link = "@lsp.type.enum" })
      ds.hl.new("CmpItemKindEnumMember", { link = "@lsp.type.enumMember" })
      ds.hl.new("CmpItemKindEvent", { link = "@boolean" })
      ds.hl.new("CmpItemKindField", { link = "@variable.member" })
      ds.hl.new("CmpItemKindFile", { link = "Directory" })
      ds.hl.new("CmpItemKindFolder", { link = "Directory" })
      ds.hl.new("CmpItemKindFunction", { link = "@lsp.type.function" })
      ds.hl.new("CmpItemKindInterface", { link = "@lsp.type.interface" })
      ds.hl.new("CmpItemKindKeyword", { link = "@keyword" })
      ds.hl.new("CmpItemKindMethod", { link = "@lsp.type.method" })
      ds.hl.new("CmpItemKindModule", { link = "@module" })
      ds.hl.new("CmpItemKindOperator", { link = "@operator" })
      ds.hl.new("CmpItemKindProperty", { link = "@property" })
      ds.hl.new("CmpItemKindReference", { link = "@markup.link" })
      ds.hl.new("CmpItemKindSnippet", { fg = vim.g.ds_colors.purple0 })
      ds.hl.new("CmpItemKindStruct", { link = "@lsp.type.struct" })
      ds.hl.new("CmpItemKindText", { link = "@markup" })
      ds.hl.new("CmpItemKindTypeParameter", { link = "@lsp.type.parameter" })
      ds.hl.new("CmpItemKindUnit", { link = "SpecialChar" })
      ds.hl.new("CmpItemKindValue", { link = "@markup" })
      ds.hl.new("CmpItemKindVariable", { link = "@variable" })
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
  },
}
