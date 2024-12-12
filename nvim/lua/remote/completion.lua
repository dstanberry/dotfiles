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
  {
    "saghen/blink.cmp",
    version = false,
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      "saadparwaiz1/cmp_luasnip",
      "kristijanhusak/vim-dadbod-completion",
      { "saghen/blink.compat", version = false, opts = { impersonate_nvim_cmp = true } },
    },
    opts = {
      appearance = { use_nvim_cmp_as_default = false, kind_icons = ds.icons.kind },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            treesitter = true,
            columns = { { "kind_icon" }, { "label", "label_description" }, { "kind" } },
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
        ["<cr>"] = { "accept", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-c>"] = { "hide", "fallback" },
        ["<c-d>"] = {},
        ["<c-f>"] = {},
      },
      sources = {
        cmdline = {},
        default = { "buffer", "copilot", "dadbod", "lazydev", "lsp", "luasnip", "path" },
        providers = {
          copilot = { name = "copilot", module = "blink-cmp-copilot", kind = "Copilot" },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },
      snippets = {
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
      },
    },
    config = function(_, opts)
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
