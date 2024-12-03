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
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
    },
    opts = {
      accept = { auto_brackets = { enabled = true } },
      appearance = { kind_icons = ds.icons.kind },
      highlight = { use_nvim_cmp_as_default = false },
      completion = {
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
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-c>"] = { "hide", "fallback" },
        ["<c-d>"] = { "scroll_documentation_down", "fallback" },
        ["<c-f>"] = { "scroll_documentation_up", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
      },
      nerd_font_variant = "mono",
      sources = {
        compat = { "luasnip" },
        completion = { enabled_providers = { "buffer", "copilot", "dadbod", "lazydev", "lsp", "path" } },
        providers = {
          copilot = { name = "copilot", kind = "Copilot", module = "blink-cmp-copilot" },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          lsp = { fallback_for = { "lazydev" } },
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
      local enabled = opts.sources.completion.enabled_providers
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then table.insert(enabled, source) end
      end
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          require("blink.cmp.types").CompletionItemKind[provider.kind] = provider.kind
          provider.transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind = provider.kind or item.kind
            end
            return items
          end
        end
      end
      require("blink.cmp").setup(opts)
    end,
  },
}
