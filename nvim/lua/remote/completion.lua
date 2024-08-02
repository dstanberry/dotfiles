return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
      popup = {
        border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
      },
    },
    config = function(_, opts)
      require("crates").setup(opts)
      ds.plugin.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.g.ds_cmp_group,
          pattern = "Cargo.toml",
          callback = function()
            local plugin = require("lazy.core.config").spec.plugins["nvim-cmp"]
            local sources = require("lazy.core.plugin").values(plugin, "opts", false).sources or {}
            table.insert(sources, { name = "crates" })
            require("cmp").setup.buffer { sources = sources }
          end,
        })
      end)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "LazyFile",
    dependencies = {
      "zbirenbaum/copilot.lua",
      build = ":Copilot auth",
      cmd = "Copilot",
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
      ds.plugin.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.g.ds_cmp_group,
          callback = function(args)
            if not (args.data and args.data.client_id) then return end
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "copilot" then copilot_cmp._on_insert_enter {} end
            local plugin = require("lazy.core.config").spec.plugins["nvim-cmp"]
            local sources = require("lazy.core.plugin").values(plugin, "opts", false).sources or {}
            table.insert(sources, { name = "copilot", priority = 100, group_index = 1 })
            require("cmp").setup.buffer { sources = sources }
          end,
        })
      end)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require "cmp"
      vim.g.ds_cmp_group = ds.augroup "cmp_sources"
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
          ghost_text = { hl_group = "CmpGhostText" },
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
          ["<cr>"] = function(fallback)
            local confirm_opts = { select = true, behavior = cmp.ConfirmBehavior.Insert }
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              if vim.api.nvim_get_mode().mode == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-g>u", true, true, true), "n", false)
              end
              if cmp.confirm(confirm_opts) then return end
            end
            return fallback()
          end,
        },
        snippet = {
          expand = function(args)
            pcall(function() require("luasnip").lsp_expand(args.body) end)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 5, max_view_entries = 5 },
        }),
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
        custom_highlights = function()
          local BLUE = ds.color.lighten(vim.g.ds_colors.blue2, 15)
          local BLUE_DARK = ds.color.darken(vim.g.ds_colors.blue2, 35)

          ds.hl.new("CmpGhostText", { link = "Comment" })

          ds.hl.new("CmpItemAbbrDefault", { fg = vim.g.ds_colors.white })
          ds.hl.new("CmpItemAbbrDeprecatedDefault", { fg = vim.g.ds_colors.white })
          ds.hl.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
          ds.hl.new("CmpItemAbbrMatchFuzzyDefault", { fg = vim.g.ds_colors.orange0, bold = true })
          ds.hl.new("CmpItemMenu", { fg = BLUE_DARK })

          ds.hl.new("CmpItemMenuDefault", { link = "@property" })
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
          ds.hl.new("CmpItemKindText", { link = "@markup.raw" })
          ds.hl.new("CmpItemKindTypeParameter", { link = "@lsp.type.parameter" })
          ds.hl.new("CmpItemKindUnit", { link = "SpecialChar" })
          ds.hl.new("CmpItemKindValue", { link = "@markup" })
          ds.hl.new("CmpItemKindVariable", { link = "@property" })
        end,
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
      if opts.custom_highlights and type(opts.custom_highlights) == "function" then opts.custom_highlights() end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.g.ds_cmp_group,
        callback = opts.custom_highlights,
      })
    end,
  },
}
