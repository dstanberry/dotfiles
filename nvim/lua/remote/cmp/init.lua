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
    ["<down>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
    ["<up>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp_document_symbol" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline {
    ["<down>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
    ["<up>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
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

groups.new("CmpItemAbbrDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrDeprecatedDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrMatchDefault", { guifg = BLUE, guibg = nil, gui = "bold", guisp = nil })
groups.new("CmpItemAbbrMatchFuzzyDefault", { guifg = c.orange, guibg = nil, gui = "bold", guisp = nil })

groups.new("CmpItemMenu", { guifg = BLUE_DARK, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindFunction", { guifg = MAGENTA, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindKeyword", { guifg = BLUE_LIGHT, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindMethod", { guifg = MAGENTA, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindSnippet", { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindText", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindVariable", { guifg = BLUE_LIGHT, guibg = nil, gui = "none", guisp = nil })

groups.new("CmpBorder", { guifg = c.bg_dark, guibg = c.bg_dark, gui = nil, guisp = nil })
groups.new("CmpFloat", { guifg = c.base04, guibg = c.bg_dark, gui = nil, guisp = nil })
