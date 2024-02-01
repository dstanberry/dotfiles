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
    -- LLM
    {
      "zbirenbaum/copilot-cmp",
      dependencies = {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = { ["*"] = true },
          server_opts_overrides = {
            settings = {
              advanced = {
                debug = { acceptSelfSignedCertificate = true },
              },
            },
          },
        },
      },
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require "copilot_cmp"
        copilot_cmp.setup(opts)
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            if not (args.data and args.data.client_id) then return end
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "copilot" then copilot_cmp._on_insert_enter {} end
          end,
        })
      end,
    },
  },
  opts = function()
    local cmp = require "cmp"
    return {
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
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          item.menu = pad(item.kind, "both")
          item.kind = pad(icons.kind[item.kind], "both")
          return item
        end,
      },
      mapping = cmp.mapping.preset.insert {
        -- NOTE: superceded by noice.nvim
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
        { name = "nvim_lsp", priority_weight = 120, group_index = 1 },
        { name = "luasnip", priority_weight = 100, group_index = 1 },
        { name = "copilot", priority = 100, group_index = 1 },
        { name = "path", priority_weight = 90, group_index = 1 },
        { name = "buffer", priority_weight = 50, keyword_length = 5, max_view_entries = 5, group_index = 2 },
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
  end,
  config = function(_, opts)
    require("cmp").setup(opts)

    groups.new("CmpItemAbbrDefault", { fg = c.white })
    groups.new("CmpItemAbbrDeprecatedDefault", { fg = c.white })
    groups.new("CmpItemAbbrMatchDefault", { fg = BLUE, bold = true })
    groups.new("CmpItemAbbrMatchFuzzyDefault", { fg = c.orange0, bold = true })
    groups.new("CmpItemMenu", { fg = BLUE_DARK })

    groups.new("CmpItemKindClass", { link = "@lsp.type.class" })
    groups.new("CmpItemKindConstant", { link = "@constant" })
    groups.new("CmpItemKindConstructor", { link = "@constructor" })
    groups.new("CmpItemKindCopilot", { fg = c.green0 })
    groups.new("CmpItemKindDefault", { fg = c.white })
    groups.new("CmpItemKindEnum", { link = "@lsp.type.enum" })
    groups.new("CmpItemKindEnumMember", { link = "@lsp.type.enumMember" })
    groups.new("CmpItemKindEvent", { link = "@boolean" })
    groups.new("CmpItemKindField", { link = "@variable.member" })
    groups.new("CmpItemKindFile", { link = "Directory" })
    groups.new("CmpItemKindFolder", { link = "Directory" })
    groups.new("CmpItemKindFunction", { link = "@lsp.type.function" })
    groups.new("CmpItemKindInterface", { link = "@lsp.type.interface" })
    groups.new("CmpItemKindKeyword", { link = "@keyword" })
    groups.new("CmpItemKindMethod", { link = "@lsp.type.method" })
    groups.new("CmpItemKindModule", { link = "@module" })
    groups.new("CmpItemKindOperator", { link = "@operator" })
    groups.new("CmpItemKindProperty", { link = "@property" })
    groups.new("CmpItemKindReference", { link = "@markup.link" })
    groups.new("CmpItemKindSnippet", { fg = c.purple0 })
    groups.new("CmpItemKindStruct", { link = "@lsp.type.struct" })
    groups.new("CmpItemKindText", { link = "@markup" })
    groups.new("CmpItemKindTypeParameter", { link = "@lsp.type.parameter" })
    groups.new("CmpItemKindUnit", { link = "SpecialChar" })
    groups.new("CmpItemKindValue", { link = "@markup" })
    groups.new("CmpItemKindVariable", { link = "@variable" })
  end,
}
