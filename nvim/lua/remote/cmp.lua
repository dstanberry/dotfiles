local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local BLUE = color.lighten(c.blue2, 15)
local BLUE_DARK = color.darken(c.blue2, 35)

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    -- snippets manager
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require "cmp"
    cmp.setup {
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
        -- ["<c-d>"] = cmp.mapping.scroll_docs(4),
        -- ["<c-f>"] = cmp.mapping.scroll_docs(-4),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-c>"] = cmp.mapping.close(),
        ["<cr>"] = cmp.mapping.confirm { select = true },
      },
      snippet = {
        expand = function(args)
          pcall(function() require("luasnip").lsp_expand(args.body) end)
        end,
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp", priority_weight = 120 },
        { name = "luasnip", priority_weight = 100 },
        { name = "path", priority_weight = 90 },
        { name = "buffer", priority_weight = 50, keyword_length = 5, max_view_entries = 5 },
      },
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },
      window = {
        completion = {
          border = icons.border.ThinBlock,
          winhighlight = "Normal:FloatBorder,FloatBorder:FloatBorderSB,CursorLine:PmenuSel",
        },
        documentation = {
          border = icons.border.ThinBlock,
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorderSB",
        },
      },
    }

    groups.new("CmpItemAbbrDefault", { fg = c.white })
    groups.new("CmpItemAbbrDeprecatedDefault", { fg = c.white })
    groups.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
    groups.new("CmpItemAbbrMatchFuzzyDefault", { fg = c.orange0, bold = true })
    groups.new("CmpItemMenu", { fg = BLUE_DARK })

    groups.new("CmpItemKindClass", { link = "@lsp.type.class" })
    groups.new("CmpItemKindConstant", { link = "@constant" })
    groups.new("CmpItemKindConstructor", { link = "@constructor" })
    groups.new("CmpItemKindDefault", { fg = c.white })
    groups.new("CmpItemKindEnum", { link = "@lsp.type.enum" })
    groups.new("CmpItemKindEnumMember", { link = "@lsp.type.enumMember" })
    groups.new("CmpItemKindEvent", { link = "@boolean" })
    groups.new("CmpItemKindField", { link = "@field" })
    groups.new("CmpItemKindFile", { link = "Directory" })
    groups.new("CmpItemKindFolder", { link = "Directory" })
    groups.new("CmpItemKindFunction", { link = "@lsp.type.function" })
    groups.new("CmpItemKindInterface", { link = "@lsp.type.interface" })
    groups.new("CmpItemKindKeyword", { link = "@keyword" })
    groups.new("CmpItemKindMethod", { link = "@lsp.type.method" })
    groups.new("CmpItemKindModule", { link = "@namespace" })
    groups.new("CmpItemKindOperator", { link = "@operator" })
    groups.new("CmpItemKindProperty", { link = "@property" })
    groups.new("CmpItemKindReference", { link = "@text.reference" })
    groups.new("CmpItemKindSnippet", { fg = c.purple0 })
    groups.new("CmpItemKindStruct", { link = "@lsp.type.struct" })
    groups.new("CmpItemKindText", { link = "@text" })
    groups.new("CmpItemKindTypeParameter", { link = "@lsp.type.parameter" })
    groups.new("CmpItemKindUnit", { link = "SpecialChar" })
    groups.new("CmpItemKindValue", { link = "@text" })
    groups.new("CmpItemKindVariable", { link = "@variable" })
  end,
}
