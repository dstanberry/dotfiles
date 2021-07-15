---------------------------------------------------------------
-- => Statusline Highlight Groups
---------------------------------------------------------------
-- initialize modules table
local hl = {}

--
local function sanitize(mode)
  return "%#" .. mode .. "#"
end

-- get corresponding highlight group for mode
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

hl.mode = function(m)
  return sanitize(modes[m])
end

-- highlight group for current window
hl.statusline = sanitize "StatusLine"
-- highlight group for non-current window
hl.statuslinenc = sanitize "StatusLine"

-- separation point between sections
hl.segment = "%="

-- highlight groups
hl.user1 = "%1*"
hl.user2 = "%2*"
hl.user3 = "%3*"
hl.user4 = "%4*"
hl.user5 = "%5*"
hl.user6 = "%6*"
hl.user7 = "%7*"
hl.user8 = "%8*"
hl.user9 = "%9*"

-- custom highlight groups
hl.custom00 = sanitize "Custom00"
hl.custom0 = sanitize "Custom0"
hl.custom1 = sanitize "Custom1"
hl.custom2 = sanitize "Custom2"
hl.custom3 = sanitize "Custom3"
hl.custom4 = sanitize "Custom4"
hl.custom5 = sanitize "Custom5"
hl.custom6 = sanitize "Custom6"

-- highlight group for lsp diagnostic
hl.lsperror = sanitize "LspDiagnosticsStatusError"
hl.lspwarning = sanitize "LspDiagnosticsStatusWarning"
hl.lspinfo = sanitize "LspDiagnosticsStatusInformation"
hl.lsphint = sanitize "LspDiagnosticsStatusHint"

return hl
