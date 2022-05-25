local ok, gps = pcall(require, "nvim-gps")
if not ok then
  return
end

local icons = require "ui.icons"

gps.setup {
  depth = 0,
  depth_limit_indicator = "..",
  disable_icons = false,
  icons = {
    ["class-name"] = pad(icons.kind.Class, "right"),
    ["function-name"] = pad(icons.kind.Function, "right"),
    ["method-name"] = pad(icons.kind.Function, "right"),
    ["container-name"] = pad(icons.type.Object, "right"),
    ["tag-name"] = pad(icons.misc.Tag, "right"),
    ["mapping-name"] = pad(icons.type.Object, "right"),
    ["sequence-name"] = pad(icons.type.Array, "right"),
    ["null-name"] = pad(icons.kind.Field, "right"),
    ["boolean-name"] = pad(icons.type.Boolean, "right"),
    ["integer-name"] = pad(icons.type.Number, "right"),
    ["float-name"] = pad(icons.type.Number, "right"),
    ["string-name"] = pad(icons.type.String, "right"),
    ["array-name"] = pad(icons.type.Array, "right"),
    ["object-name"] = pad(icons.type.Object, "right"),
    ["number-name"] = pad(icons.type.Number, "right"),
    ["table-name"] = pad(icons.misc.Table, "right"),
    ["date-name"] = pad(icons.misc.Calendar, "right"),
    ["date-time-name"] = pad(icons.misc.Table, "right"),
    ["inline-table-name"] = pad(icons.type.Object, "right"),
    ["time-name"] = pad(icons.misc.Watch, "right"),
    ["module-name"] = pad(icons.kind.Module, "right"),
  },
  separator = pad(icons.misc.ChevronRight, "right"),
}

return setmetatable({}, {
  __index = function(t, k)
    return gps[k]
  end,
})
