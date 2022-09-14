local ok, navic = pcall(require, "nvim-navic")
if not ok then
  return
end

local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NavicIconsArray", {link = "TSConstant"})
groups.new("NavicIconsBoolean", {link = "TSBoolean"})
groups.new("NavicIconsClass", {link = "Type"})
groups.new("NavicIconsConstant", {link = "TSConstant"})
groups.new("NavicIconsConstructor", {link = "TSConstructor"})
groups.new("NavicIconsEnum", {link = "TSEnum"})
groups.new("NavicIconsEnumMember", {link = "TSField"})
groups.new("NavicIconsEvent", {link = "TSBoolean"})
groups.new("NavicIconsField", {link = "TSField"})
groups.new("NavicIconsFile", {link = "Directory"})
groups.new("NavicIconsFunction", {link = "TSFunction"})
groups.new("NavicIconsInterface", {link = "TSKeywordFunction"})
groups.new("NavicIconsKey", {link = "TSText"})
groups.new("NavicIconsMethod", {link = "TSFunction"})
groups.new("NavicIconsModule", {link = "TSNamespace"})
groups.new("NavicIconsNamespace", {link = "TSNamespace"})
groups.new("NavicIconsNull", {link = "TSType"})
groups.new("NavicIconsNumber", {link = "TSNumber"})
groups.new("NavicIconsObject", {link = "TSType"})
groups.new("NavicIconsOperator", {link = "TSOperator"})
groups.new("NavicIconsPackage", {link = "TSNamespace"})
groups.new("NavicIconsProperty", {link = "TSProperty"})
groups.new("NavicIconsString", {link = "TSString"})
groups.new("NavicIconsStruct", {link = "Type"})
groups.new("NavicIconsTypeParameter", {link = "Identifier"})
groups.new("NavicIconsVariable", {link = "TSVariable"})

navic.setup {
  depth_limit = 0,
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
  separator = pad(icons.misc.ChevronRight, "right"),
}

return setmetatable({}, {
  __index = function(t, k)
    return navic[k]
  end,
})
