local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NavicIconsArray", { fg = c.orange })
groups.new("NavicIconsBoolean", { fg = c.orange })
groups.new("NavicIconsClass", { fg = c.orange })
groups.new("NavicIconsConstant", { fg = c.magenta })
groups.new("NavicIconsConstructor", { fg = c.orange })
groups.new("NavicIconsEnum", { fg = c.orange })
groups.new("NavicIconsEnumMember", { fg = c.fg })
groups.new("NavicIconsEvent", { fg = c.orange })
groups.new("NavicIconsField", { fg = c.teal })
groups.new("NavicIconsFile", { fg = c.fg })
groups.new("NavicIconsFunction", { fg = c.blue })
groups.new("NavicIconsInterface", { fg = c.orange })
groups.new("NavicIconsKey", { fg = c.purple })
groups.new("NavicIconsKeyword", { fg = c.purple })
groups.new("NavicIconsMethod", { fg = c.blue })
groups.new("NavicIconsModule", { fg = c.yellow })
groups.new("NavicIconsNamespace", { fg = c.fg })
groups.new("NavicIconsNull", { fg = c.orange })
groups.new("NavicIconsNumber", { fg = c.orange })
groups.new("NavicIconsObject", { fg = c.orange })
groups.new("NavicIconsOperator", { fg = c.fg })
groups.new("NavicIconsPackage", { fg = c.fg })
groups.new("NavicIconsProperty", { fg = c.fg })
groups.new("NavicIconsString", { fg = c.green })
groups.new("NavicIconsStruct", { fg = c.orange })
groups.new("NavicIconsTypeParameter", { fg = c.rose })
groups.new("NavicIconsVariable", { fg = c.magenta })

return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    depth_limit = 5,
    depth_limit_indicator = "..",
    highlight = true,
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
    separator = pad(icons.misc.ChevronRight, "both"),
  },
  init = function()
    vim.api.nvim_create_augroup("navic-buffer", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = "navic-buffer",
      callback = function()
        if vim.api.nvim_buf_line_count(0) > 10000 then vim.b.navic_lazy_update_context = true end
      end,
    })
  end,
}
