---------------------------------------------------------------
-- => Statusline
---------------------------------------------------------------
-- load statusline utilities
local util = require "statusline.util"

-- initialize modules table
local statusline = {}

-- get corresponding highlight group for mode
local function get_highlight(m)
  local modes = {
    n = "Custom2",
    no = "Custom2",
    nov = "Custom2",
    noV = "Custom2",
    ["noCTRL-V"] = "Custom2",
    niI = "Custom2",
    niR = "Custom2",
    niV = "Custom2",
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
    ["null"] = "Custom2",
  }
  return modes[m] or "Custom2"
end

-- add section to statusline
local function add(hl_string, items, shrink)
  local out = ""
  shrink = shrink or nil
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        if shrink then
          out = out .. item
        else
          out = out .. " " .. item
        end
      end
    end
  end
  if shrink then
    return hl_string .. out
  else
    return hl_string .. out .. " "
  end
end

-- add section to statusline (with separators)
local function add_sep(hl_string, items)
  local out = ""
  shrink = shrink or nil
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        out = out .. " " .. item
      end
    end
  end
  return hl_string .. out .. " "
end

-- add lsp diagnostic section to statusline
local function print_diagnostics(hl, prefix, count)
  local out = prefix .. count
  if count > 0 then
    return hl .. out
  end
  return out
end

local function sanitize(mode)
  return "%#" .. mode .. "#"
end

statusline.focus = function()
  local mode = vim.fn.mode()
  local hl = get_highlight(mode)
  local sl = sanitize(hl)
  local diagnostics = util.get_lsp_diagnostics()
  return table.concat {
    add(sl, { "▊" }),
    add(sl, { util.git_branch() }),
    add("%1*", { util.filepath() }, true),
    add("%2*", { util.filename(), util.get_modified() }),
    "%=",
    add("%1*", {
      print_diagnostics("%#LspDiagnosticsDefaultError#", "E:", diagnostics.errors),
      print_diagnostics("%#LspDiagnosticsDefaultWarning#", "W:", diagnostics.warnings),
    }),
    add_sep("%#Custom00#", { util.get_readonly(), util.fileformat() }),
    add(sl, { util.filetype() }),
    add("%4*", { " ℓ %l с %c " }),
  }
end

return statusline
