-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

cmp.setup {
  experimental = {
    ghost_text = true,
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(_, item)
      item.menu = item.kind
      item.kind = ({
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "陋",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Keyword = "",
        Method = "",
        Module = "",
        Operator = "",
        Property = "",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "勞",
      })[item.kind]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<c-d>"] = cmp.mapping.scroll_docs(-4),
    ["<c-f>"] = cmp.mapping.scroll_docs(4),
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
  completion = {
    autocomplete = false,
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "nvim_lsp_document_symbol" },
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
  }),
})

c.comp00 = color.lighten(c.base0D, 15)
c.comp01 = color.lighten(c.base0D, 21)
c.comp02 = color.lighten(c.base0E, 9)
c.comp03 = color.darken(c.base0D, 35)

groups.new("CmpItemAbbrDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrDeprecatedDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrMatchDefault", { guifg = c.comp00, guibg = nil, gui = "bold", guisp = nil })
groups.new("CmpItemAbbrMatchFuzzyDefault", { guifg = c.base09, guibg = nil, gui = "bold", guisp = nil })

groups.new("CmpItemMenu", { guifg = c.comp03, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindFunction", { guifg = c.comp02, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindKeyword", { guifg = c.comp01, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindMethod", { guifg = c.comp02, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindSnippet", { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindText", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindVariable", { guifg = c.comp01, guibg = nil, gui = "none", guisp = nil })

groups.new("CmpBorder", { guifg = c.baseXX, guibg = c.baseXX, gui = nil, guisp = nil })
groups.new("CmpFloat", { guifg = c.base04, guibg = c.baseXX, gui = nil, guisp = nil })
