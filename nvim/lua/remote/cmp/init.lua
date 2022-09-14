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
      item.menu = pad(item.kind, "both")
      item.kind = pad(icons.kind[item.kind], "both")
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
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp_document_symbol" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
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

groups.new("CmpItemKindClass", { link = "Type" })
-- groups.new("CmpItemKindColor", { link = "" })
groups.new("CmpItemKindConstant", { link = "TSConstant" })
groups.new("CmpItemKindConstructor", { link = "TSConstructor" })
groups.new("CmpItemKindDefault", { fg = c.white })
groups.new("CmpItemKindEnum", { link = "TSEnum" })
groups.new("CmpItemKindEnumMember", { link = "TSField" })
groups.new("CmpItemKindEvent", { link = "TSBoolean" })
groups.new("CmpItemKindField", { link = "TSField" })
groups.new("CmpItemKindFile", { link = "Directory" })
groups.new("CmpItemKindFolder", { link = "Directory" })
groups.new("CmpItemKindFunction", { link = "TSFunction" })
groups.new("CmpItemKindInterface", { link = "TSKeywordFunction" })
groups.new("CmpItemKindKeyword", { link = "TSKeyword" })
groups.new("CmpItemKindMethod", { link = "TSFunction" })
groups.new("CmpItemKindModule", { link = "TSNamespace" })
groups.new("CmpItemKindOperator", { link = "TSOperator" })
groups.new("CmpItemKindProperty", { link = "TSProperty" })
groups.new("CmpItemKindReference", { link = "TSTextReference" })
groups.new("CmpItemKindSnippet", { fg = c.white })
groups.new("CmpItemKindStruct", { link = "Type" })
groups.new("CmpItemKindText", { link = "TSText" })
groups.new("CmpItemKindTypeParameter", { link = "Identifier" })
groups.new("CmpItemKindUnit", { link = "SpecialChar" })
groups.new("CmpItemKindValue", { link = "TSText" })
groups.new("CmpItemKindVariable", { link = "TSVariable" })

groups.new("CmpBorder", { fg = c.bg_dark, bg = c.bg_dark })
groups.new("CmpFloat", { fg = c.white, bg = c.bg_dark })
