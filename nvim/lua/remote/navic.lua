local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NavicIconsArray", { link = "@storageclass" })
groups.new("NavicIconsBoolean", { link = "@boolean" })
groups.new("NavicIconsClass", { link = "@class" })
groups.new("NavicIconsConstant", { link = "@constant" })
groups.new("NavicIconsConstructor", { link = "@constructor" })
groups.new("NavicIconsEnum", { link = "@lsp.type.enum" })
groups.new("NavicIconsEnumMember", { link = "@lsp.type.enumMember" })
groups.new("NavicIconsEvent", { link = "@lsp.type.event" })
groups.new("NavicIconsField", { link = "@field.yaml" })
groups.new("NavicIconsFile", { link = "Directory" })
groups.new("NavicIconsFunction", { link = "@function" })
groups.new("NavicIconsInterface", { link = "@lsp.type.interface" })
groups.new("NavicIconsKey", { link = "@field.yaml" })
groups.new("NavicIconsKeyword", { link = "@keyword" })
groups.new("NavicIconsMethod", { link = "@method" })
groups.new("NavicIconsModule", { link = "@include" })
groups.new("NavicIconsNamespace", { link = "@namespace" })
groups.new("NavicIconsNull", { link = "@error" })
groups.new("NavicIconsNumber", { link = "@number" })
groups.new("NavicIconsObject", { link = "@type" })
groups.new("NavicIconsOperator", { link = "@operator" })
groups.new("NavicIconsPackage", { link = "@include" })
groups.new("NavicIconsProperty", { link = "@field.yaml" })
groups.new("NavicIconsString", { link = "@string" })
groups.new("NavicIconsStruct", { link = "@type" })
groups.new("NavicIconsTypeParameter", { link = "@type" })
groups.new("NavicIconsVariable", { link = "@field.yaml" })

groups.new("NavicText", { link = "WinbarContext" })
groups.new("NavicSeparator", { fg = color.blend(c.purple1, c.bg2, 0.38) })

return {
  "SmiteshP/nvim-navic",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    highlight = false,
    icons = {
      Array = pad(icons.type.Array, "right"),
      Boolean = pad(icons.type.Boolean, "right"),
      Class = pad(icons.kind.Class, "right"),
      Constant = pad(icons.kind.Constant, "right"),
      Constructor = pad(icons.kind.Constructor, "right"),
      Enum = pad(icons.kind.Enum, "right"),
      EnumMember = pad(icons.kind.EnumMember, "right"),
      Event = pad(icons.kind.Event, "right"),
      Field = pad(icons.kind.Field, "right"),
      File = pad(icons.documents.File, "right"),
      Function = pad(icons.kind.Function, "right"),
      Interface = pad(icons.kind.Interface, "right"),
      Key = pad(icons.misc.Key, "right"),
      Method = pad(icons.kind.Function, "right"),
      Module = pad(icons.kind.Module, "right"),
      Namespace = pad(icons.kind.Class, "right"),
      Null = pad(icons.type.Boolean, "right"),
      Number = pad(icons.type.Number, "right"),
      Object = pad(icons.type.Object, "right"),
      Operator = pad(icons.kind.Operator, "right"),
      Package = pad(icons.type.Array, "right"),
      Property = pad(icons.kind.Property, "right"),
      String = pad(icons.type.String, "right"),
      Struct = pad(icons.kind.Struct, "right"),
      TypeParameter = pad(icons.kind.TypeParameter, "right"),
      Variable = pad(icons.kind.Variable, "right"),
    },
    lsp = {
      auto_attach = true,
      preference = { "tsserver" },
    },
    separator = pad(icons.misc.CaretRight, "both"),
  },
  init = function()
    local lsp_navic = vim.api.nvim_create_augroup("lsp_navic", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = lsp_navic,
      callback = function()
        if vim.api.nvim_buf_line_count(0) > 1200 then vim.b.navic_lazy_update_context = true end
      end,
    })
  end,
}
