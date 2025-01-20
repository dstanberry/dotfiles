return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "LazyFile",
    cmd = "Copilot",
    opts = {
      filetypes = { ["*"] = true },
      panel = { enabled = false },
      suggestion = { enabled = false },
      server_opts_overrides = {
        settings = {
          advanced = { debug = { acceptselfSignedCertificate = true } },
        },
      },
    },
  },
  { "xzbdmw/colorful-menu.nvim", lazy = true },
  {
    "saghen/blink.cmp",
    version = false,
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      "kristijanhusak/vim-dadbod-completion",
      { "saghen/blink.compat", version = false, opts = { impersonate_nvim_cmp = true } },
    },
    opts = {
      appearance = { use_nvim_cmp_as_default = false, kind_icons = ds.icons.kind },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
            components = { kind_icon = { width = { fill = true } } },
          },
          border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
          winblend = vim.o.pumblend,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
            winblend = vim.o.pumblend,
          },
        },
        ghost_text = { enabled = true },
      },
      keymap = {
        preset = "none",
        ["<cr>"] = { "accept", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-c>"] = { "hide", "fallback" },
      },
      sources = {
        cmdline = {},
        default = { "buffer", "copilot", "dadbod", "lazydev", "lsp", "path" },
        providers = {
          copilot = { name = "copilot", module = "blink-cmp-copilot", kind = "Copilot" },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      snippets = {
        preset = "luasnip",
      },
    },
    config = function(_, opts)
      local ok, colors = pcall(require, "colorful-menu")
      if ok then
        -- better highlights for completion items
        opts.completion.menu.draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
          components = {
            label = { text = colors.blink_components_text, highlight = colors.blink_components_highlight },
            kind_icon = { width = { fill = true } },
          },
        }
      end
      -- kind icon overrides
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local transform_items = provider.transform_items
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = provider.kind
          CompletionItemKind[provider.kind] = kind_idx
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end
          provider.kind = nil
        end
      end
      require("blink.cmp").setup(opts)
    end,
  },
}
