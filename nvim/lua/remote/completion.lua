return {
  { "xzbdmw/colorful-menu.nvim", lazy = true },
  {
    "saghen/blink.cmp",
    version = false,
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "kristijanhusak/vim-dadbod-completion",
      { "saghen/blink.compat", version = false, opts = { impersonate_nvim_cmp = true } },
    },
    opts = { ---@type blink.cmp.Config
      appearance = { use_nvim_cmp_as_default = false, kind_icons = ds.icons.kind },
      cmdline = { enabled = false },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
          winblend = vim.o.pumblend,
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
            components = { kind_icon = { width = { fill = true } } },
            treesitter = { "lsp" },
          },
          direction_priority = function()
            local blink_cmp = require "blink.cmp"
            local ctx = blink_cmp.get_context()
            local item = blink_cmp.get_selected_item()
            if ctx == nil or item == nil then return { "s", "n" } end
            local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
            local is_multi_line = item_text:find "\n" ~= nil
            if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
              vim.g.blink_cmp_upwards_ctx_id = ctx.id
              return { "n", "s" }
            end
            return { "s", "n" }
          end,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
            winblend = vim.o.pumblend,
          },
        },
        ghost_text = { enabled = true },
        trigger = { show_on_trigger_character = true },
      },
      keymap = {
        preset = "none",
        ["<tab>"] = { ds.cmp.coalesce { "snippet.jump", "inline.accept" }, "fallback" },
        ["<s-tab>"] = { "snippet_backward", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<c-t>"] = { function() ds.cmp.inline.cycle(-1) end },
        ["<c-g>"] = { function() ds.cmp.inline.cycle() end },
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-c>"] = { "hide", "fallback" },
        ["<esc>"] = { "cancel", "fallback" },
      },
      sources = {
        default = {
          "buffer",
          "dadbod",
          "lazydev",
          "lsp",
          "path",
          "snippets",
        },
        providers = {
          buffer = { score_offset = 10 },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          path = { score_offset = 10 },
        },
      },
      snippets = {
        preset = "luasnip",
        active = function(filter) return ds.snippet.active(filter) end,
        expand = function(snippet) return ds.snippet.expand(snippet) end,
        jump = function(direction) return ds.snippet.jump(direction) end,
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      local blink_cmp = require "blink.cmp"

      if ds.plugin.is_installed "colorful-menu.nvim" then
        local colors = require "colorful-menu"
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

      blink_cmp.setup(opts)

      --- @param options? { callback?: fun() }
      ds.cmp.hide = function(options) blink_cmp.hide(options or {}) end
      --- @param options? { callback?: fun() }
      ds.cmp.cancel = function(options) blink_cmp.cancel(options or {}) end
      --- @param options? blink.cmp.CompletionListAcceptOpts
      ds.cmp.confirm = function(options) blink_cmp.accept(options or {}) end
      --- @param options? { providers?: string[], initial_selected_item_idx?: number, callback?: fun() }
      ds.cmp.show = function(options) blink_cmp.show(options or {}) end
      ---@param component? "documentation"|"ghost_text"|"menu"|"signature"
      ds.cmp.visible = function(component)
        component = component or "menu"
        local func = ("is_%s_visible"):format(component)
        return blink_cmp[func] and type(blink_cmp[func]) == "function" and blink_cmp[func]() or false
      end
    end,
  },
}
