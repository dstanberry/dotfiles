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
  __index = function()
    return "%2*"
  end,
})

M.mode = function(m)
  return modes[m]
end

M.sanitize = function(group)
  return "%#" .. group .. "#"
end

M.segment = "%="
M.reset = "%*"

M.user1 = "%1*"
M.user2 = "%2*"
M.user3 = "%3*"
M.user4 = "%4*"
M.user5 = "%5*"
M.user6 = "%6*"
M.user7 = "%7*"
M.user8 = "%8*"
M.user9 = "%9*"

return M
