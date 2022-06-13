local c = require("ui.theme").colors

local M = {}

local function sanitize(group)
  return "%#" .. group .. "#"
end

local modes = setmetatable({
  n = "Custom2",
  no = "Custom2",
  v = "Custom4",
  V = "Custom4",
  ["\22"] = "Custom4",
  s = "Custom6",
  S = "Custom6",
  i = "Custom1",
  ic = "Custom1",
  ix = "Custom1",
  R = "Custom3",
  Rc = "Custom3",
  Rv = "Custom3",
  Rx = "Custom3",
  c = "Custom5",
  cv = "Custom5",
  ce = "Custom5",
  r = "Custom2",
  rm = "Custom2",
  ["r?"] = "Custom2",
  ["!"] = "Custom2",
  t = "Custom2",
}, {
  __index = function()
    return "Custom2"
  end,
})

M.mode = function(m)
  return sanitize(modes[m])
end

M.segment = "%="
M.reset = "%*"

M.lsp_error = sanitize "DiagnosticStatusError"
M.lsp_warn = sanitize "DiagnosticStatusWarn"
M.lsp_info = sanitize "DiagnosticStatusInfo"
M.lsp_hint = sanitize "DiagnosticStatusHint"

M.statusline = sanitize "StatusLine"
M.statuslinenc = sanitize "StatusLine"

M.user1 = "%1*"
M.user2 = "%2*"
M.user3 = "%3*"
M.user4 = "%4*"
M.user5 = "%5*"
M.user6 = "%6*"
M.user7 = "%7*"
M.user8 = "%8*"
M.user9 = "%9*"

M.custom00 = sanitize "Custom00"
M.custom0 = sanitize "Custom0"
M.custom1 = sanitize "Custom1"
M.custom2 = sanitize "Custom2"
M.custom3 = sanitize "Custom3"
M.custom4 = sanitize "Custom4"
M.custom5 = sanitize "Custom5"
M.custom6 = sanitize "Custom6"

M.winbar = sanitize "Winbar"
M.winbar_icon = sanitize "WinbarIcon"
M.winbarnc = sanitize "WinbarNC"

return M
