-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

cmp.setup {
  documentation = true,
  snippet = {
    expand = function(args)
      pcall(function()
        require("luasnip").lsp_expand(args.body)
      end)
    end,
  },
  mapping = {
    ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<esc>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
    ["<cr>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer", keyword_length = 5, max_item_count = 5 },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = ({
        Class = " (class)",
        Color = " (color)",
        Constant = " (constant)",
        Constructor = " (constructor)",
        Enum = " (enum)",
        EnumMember = " (enum member)",
        Event = " (event)",
        Field = "陋 (field)",
        File = " (file)",
        Folder = " (folder)",
        Function = " (function)",
        Interface = " (interface)",
        Keyword = " (keyword)",
        Method = " (method)",
        Module = " (module)",
        Operator = " (operator)",
        Property = " (property)",
        Reference = " (reference)",
        Snippet = " (snippet)",
        Struct = " (struct)",
        Text = " (text)",
        TypeParameter = " (type parameter)",
        Unit = " (unit)",
        Value = " (value)",
        Variable = "勞 (variable)",
      })[vim_item.kind]
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true,
  },
}

cmp.setup.cmdline("/", {
  completion = {
    autocomplete = false,
  },
  sources = {
    { name = "nvim_lsp_document_symbol" },
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

c.comp00 = color.lighten(c.base0D, 15)
c.comp01 = color.lighten(c.base0D, 21)
c.comp02 = color.lighten(c.base0E, 9)

groups.new("CmpItemAbbrDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrDeprecatedDefault", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemAbbrMatchDefault", { guifg = c.comp00, guibg = nil, gui = "bold", guisp = nil })
groups.new("CmpItemAbbrMatchFuzzyDefault", { guifg = c.base09, guibg = nil, gui = "bold", guisp = nil })
groups.new("CmpItemItemDefault", { guifg = c.base0C, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemItemMenuDefault", { guifg = c.base10, guibg = nil, gui = "none", guisp = nil })

groups.new("CmpItemKindFunction", { guifg = c.comp02, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindMethod", { guifg = c.comp02, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindSnippet", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindVariable", { guifg = c.comp01, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindKeyword", { guifg = c.comp01, guibg = nil, gui = "none", guisp = nil })
groups.new("CmpItemKindText", { guifg = c.base04, guibg = nil, gui = "none", guisp = nil })
