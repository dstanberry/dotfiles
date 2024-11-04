return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = {
        border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
      },
    },
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
      "roobert/tailwindcss-colorizer-cmp.nvim",
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
          format = function(entry, item)
            item.menu = ds.pad(item.kind, "both")
            item.kind = ds.pad(ds.icons.kind[item.kind], "both")
            local tailwind_colorizer = require("tailwindcss-colorizer-cmp").formatter(entry, item)
            if tailwind_colorizer.kind == "XX" then tailwind_colorizer.kind = ds.pad(ds.icons.kind.Color, "both") end
            return tailwind_colorizer
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
      }
    end,
  },
}
