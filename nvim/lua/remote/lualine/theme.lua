local c = require("ui.theme").colors

local theme = {
  command = {
    a = { fg = c.magenta, bg = c.gray, bold = true },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
  inactive = {
    a = { fg = c.fg, bg = c.gray },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
  insert = {
    a = { fg = c.green, bg = c.gray, bold = true },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
  normal = {
    a = { fg = c.blue_dark, bg = c.gray, bold = true },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
  replace = {
    a = { fg = c.orange, bg = c.gray, bold = true },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
  visual = {
    a = { fg = c.red, bg = c.gray, bold = true },
    b = { fg = c.white, bg = c.gray },
    c = { fg = c.white, bg = c.gray },
  },
}

local mode_color = {
  n = c.blue_dark,
  no = c.blue_dark,
  v = c.red,
  V = c.red,
  ["\22"] = c.red,
  s = c.orange,
  S = c.orange,
  i = c.green,
  ic = c.green,
  ix = c.green,
  R = c.blue_light,
  Rc = c.blue_light,
  Rv = c.blue_light,
  Rx = c.blue_light,
  c = c.magenta,
  cv = c.magenta,
  ce = c.magenta,
  r = c.blue_dark,
  rm = c.cyan,
  ["r?"] = c.cyan,
  ["!"] = c.blue_dark,
  t = c.blue_dark,
}

return {
  palette = theme,
  modes = mode_color,
}
