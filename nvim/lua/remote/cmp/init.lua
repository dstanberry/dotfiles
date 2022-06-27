-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

cmp.setup {
  experimental = {
    ghost_text = true,
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(_, item)
      item.menu = item.kind
      item.kind = icons.kind[item.kind]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<c-d>"] = cmp.mapping.scroll_docs(4),
    ["<c-f>"] = cmp.mapping.scroll_docs(-4),
    ["<c-space>"] = cmp.mapping.complete(),
    ["<c-c>"] = cmp.mapping.close(),
    ["<cr>"] = cmp.mapping.confirm { select = true },
  },
  snippet = {
    expand = function(args)
      pcall(function()
        require("luasnip").lsp_expand(args.body)
      end)
    end,
  },
  sources = cmp.config.sources {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer", keyword_length = 5, max_item_count = 5 },
  },
  view = {
    entries = { name = "custom", selection_order = "near_cursor" },
  },
  window = {
    completion = {
      border = "single",
      winhighlight = "Normal:CmpBorder,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = "single",
      winhighlight = "NormalFloat:CmpFloat,FloatBorder:CmpBorder",
    },
  },
}

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline {
    ["<down>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
    ["<up>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp_document_symbol" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline {
    ["<down>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
    ["<up>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
  },
  sources = cmp.config.sources({
    { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
  }, {
    { name = "path" },
  }),
})

local BLUE = color.lighten(c.blue, 15)
local BLUE_LIGHT = color.lighten(c.blue, 21)
local BLUE_DARK = color.darken(c.blue, 35)
local MAGENTA = color.lighten(c.magenta, 9)

groups.new("CmpItemAbbrDefault", { fg = c.white })
groups.new("CmpItemAbbrDeprecatedDefault", { fg = c.white })
groups.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
groups.new("CmpItemAbbrMatchFuzzyDefault", { fg = c.orange, bold = true })

groups.new("CmpItemMenu", { fg = BLUE_DARK })
groups.new("CmpItemKindFunction", { fg = MAGENTA })
groups.new("CmpItemKindKeyword", { fg = BLUE_LIGHT })
groups.new("CmpItemKindMethod", { fg = MAGENTA })
groups.new("CmpItemKindSnippet", { fg = c.blue_dark })
groups.new("CmpItemKindText", { fg = c.white })
groups.new("CmpItemKindDefault", { fg = c.white })
groups.new("CmpItemKindVariable", { fg = BLUE_LIGHT })

groups.new("CmpBorder", { fg = c.bg_dark, bg = c.bg_dark })
groups.new("CmpFloat", { fg = c.white, bg = c.bg_dark })
