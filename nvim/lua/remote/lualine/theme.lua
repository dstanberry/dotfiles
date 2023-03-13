local c = require("ui.theme").colors

local theme = {
  command = {
    a = { fg = c.magenta1, bg = c.gray0, bold = true },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
  inactive = {
    a = { fg = c.fg1, bg = c.gray0 },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
  insert = {
    a = { fg = c.green2, bg = c.gray0, bold = true },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
  normal = {
    a = { fg = c.blue1, bg = c.gray0, bold = true },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
  replace = {
    a = { fg = c.orange0, bg = c.gray0, bold = true },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
  visual = {
    a = { fg = c.red1, bg = c.gray0, bold = true },
    b = { fg = c.white, bg = c.gray0 },
    c = { fg = c.white, bg = c.gray0 },
  },
}

local mode_color = {
  n = c.blue1,
  no = c.blue1,
  v = c.red1,
  V = c.red1,
  ["\22"] = c.red1,
  s = c.orange0,
  S = c.orange0,
  i = c.green2,
  ic = c.green2,
  ix = c.green2,
  R = c.aqua1,
  Rc = c.aqua1,
  Rv = c.aqua1,
  Rx = c.aqua1,
  c = c.magenta1,
  cv = c.magenta1,
  ce = c.magenta1,
  r = c.blue1,
  rm = c.cyan2,
  ["r?"] = c.cyan2,
  ["!"] = c.blue1,
  t = c.blue1,
}

return {
  palette = theme,
  modes = mode_color,
}
