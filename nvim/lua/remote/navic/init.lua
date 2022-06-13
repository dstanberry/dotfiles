local ok, navic = pcall(require, "nvim-navic")
if not ok then
  return
end

local icons = require "ui.icons"

navic.setup {
  depth_limit = 0,
  depth_limit_indicator = "..",
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
  separator = pad(icons.misc.ChevronRight, "right"),
}

return setmetatable({}, {
  __index = function(t, k)
    return navic[k]
  end,
})
