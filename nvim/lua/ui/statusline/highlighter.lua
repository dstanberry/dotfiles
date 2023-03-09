local M = {}

local modes = setmetatable({
  n = "%2*",
  no = "%2*",
  v = "%4*",
  V = "%4*",
  ["\22"] = "%4*",
  s = "%6*",
  S = "%6*",
  i = "%1*",
  ic = "%1*",
  ix = "%1*",
  R = "%3*",
  Rc = "%3*",
  Rv = "%3*",
  Rx = "%3*",
  c = "%5*",
  cv = "%5*",
  ce = "%5*",
  r = "%2*",
  rm = "%2*",
  ["r?"] = "%2*",
  ["!"] = "%2*",
  t = "%2*",
}, {
  __index = function() return "%2*" end,
})

M.mode = function(m) return modes[m] end

M.sanitize = function(group) return "%#" .. group .. "#" end

M.segment = "%="
M.reset = "%*"

M.create_hl = function(hlgroup, attr)
  local id = vim.api.nvim_get_hl_id_by_name(hlgroup)
  vim.api.nvim_set_hl(0, hlgroup, attr)
  return M.sanitize(hlgroup)
end

return M
