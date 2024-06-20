local theme = {
  command = {
    a = { fg = vim.g.ds_colors.magenta1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  inactive = {
    a = { fg = vim.g.ds_colors.fg1, bg = vim.g.ds_colors.gray0 },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  insert = {
    a = { fg = vim.g.ds_colors.green2, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  normal = {
    a = { fg = vim.g.ds_colors.blue1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  replace = {
    a = { fg = vim.g.ds_colors.orange0, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  visual = {
    a = { fg = vim.g.ds_colors.red1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
}

local mode_color = {
  n = vim.g.ds_colors.blue1,
  no = vim.g.ds_colors.blue1,
  v = vim.g.ds_colors.red1,
  V = vim.g.ds_colors.red1,
  ["\22"] = vim.g.ds_colors.red1,
  s = vim.g.ds_colors.orange0,
  S = vim.g.ds_colors.orange0,
  i = vim.g.ds_colors.green2,
  ic = vim.g.ds_colors.green2,
  ix = vim.g.ds_colors.green2,
  R = vim.g.ds_colors.aqua1,
  Rc = vim.g.ds_colors.aqua1,
  Rv = vim.g.ds_colors.aqua1,
  Rx = vim.g.ds_colors.aqua1,
  c = vim.g.ds_colors.magenta1,
  cv = vim.g.ds_colors.magenta1,
  ce = vim.g.ds_colors.magenta1,
  r = vim.g.ds_colors.blue1,
  rm = vim.g.ds_colors.cyan2,
  ["r?"] = vim.g.ds_colors.cyan2,
  ["!"] = vim.g.ds_colors.blue1,
  t = vim.g.ds_colors.blue1,
}

return {
  palette = theme,
  modes = mode_color,
}
