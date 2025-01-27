local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local CYAN = "#73c1b9"
  local CYAN_LIGHT = "#80d3dd"
  local PINK = "#dec7d0"
  local ORANGE = "#e09696"
  local YELLOW = "#ffdca8"
  local MAGENTA = "#9086a4"
  local MAGENTA_LIGHT = "#bfafc4"
  local YELLOW_LIGHT = "#f0e7b9"

  local GRAY = ds.color.darken(c.gray0, 10)
  local GRAY_DARK = ds.color.darken(c.gray0, 25)
  local BLUE = ds.color.darken(c.blue1, 43)

  -- stylua: ignore
  return {
    -- dashboard
    SnacksDashboardHeader       = { fg = c.magenta0 },
    SnacksDashboardFooter       = { fg = c.blue0 },

    SnacksDashboardSpecial      = { fg = c.fg_conceal },

    SnacksDashboardDesc         = { fg = c.overlay1 },
    SnacksDashboardKey          = { fg = c.rose0 },
    SnacksDashboardIcon         = { fg = c.overlay1, bold = true },
    SnacksDashboardShortCut     = { fg = c.overlay1 },

    -- indent
    SnacksIndent1               = { fg = CYAN },
    SnacksIndent2               = { fg = ORANGE },
    SnacksIndent3               = { fg = MAGENTA },
    SnacksIndent4               = { fg = CYAN_LIGHT },
    SnacksIndent5               = { fg = PINK },
    SnacksIndent6               = { fg = MAGENTA_LIGHT },
    SnacksIndent7               = { fg = YELLOW },
    SnacksIndent8               = { fg = YELLOW_LIGHT },

    -- notifier
    SnacksNormal                = { fg = c.white, bg = c.bg0 },

    SnacksNotifierTrace         = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderTrace   = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconTrace     = { link = "DiagnosticHint" },
    SnacksNotifierTitleTrace    = { fg = ds.color.get_color "DiagnosticHint", bg = c.bg0 },

    SnacksNotifierDebug         = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderDebug   = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconDebug     = { link = "DiagnosticHint" },
    SnacksNotifierTitleDebug    = { fg = ds.color.get_color "DiagnosticHint", bg = c.bg0 },

    SnacksNotifierInfo          = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderInfo    = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconInfo      = { link = "DiagnosticInfo" },
    SnacksNotifierTitleInfo     = { fg = ds.color.get_color "DiagnosticInfo", bg = c.bg0 },

    SnacksNotifierWarn          = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderWarn    = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconWarn      = { link = "DiagnosticWarn" },
    SnacksNotifierTitleWarn     = { fg = ds.color.get_color "DiagnosticWarn", bg = c.bg0 },

    SnacksNotifierError         = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderError   = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconError     = { link = "DiagnosticError" },
    SnacksNotifierTitleError    = { fg = ds.color.get_color "DiagnosticError", bg = c.bg0 },

    SnacksNotifierHistory       = { fg = c.fg1, bg = c.bg0 },
    SnacksNotifierHistoryTitle  = { fg = c.blue0, bg = c.bg0, bold = true },

    -- picker
    SnacksPicker                = { bg = GRAY_DARK },
    SnacksPickerBorder          = { fg = GRAY_DARK, bg = GRAY_DARK },

    SnacksPickerBoxTitle        = { fg = c.bg2, bg = c.red1, bold = true },

    SnacksPickerInputBorder     = { fg = c.red1, bg = GRAY_DARK },
    SnacksPickerInputTitle      = { fg = c.bg2, bg = c.red1, bold = true },

    SnacksPickerList            = { bg = GRAY_DARK },
    SnacksPickerListCursorLine  = { bg = BLUE, bold = true },

    SnacksPickerPreview         = { bg = c.bg0 },
    SnacksPickerPreviewBorder   = { fg = c.bg0, bg = c.bg0 },
    SnacksPickerPreviewTitle    = { fg = c.bg2, bg = c.bg0, bold = true },

    SnacksPickerMatch           = { fg = c.orange0, bold = true },
    SnacksPickerDir             = { fg = c.gray2 },
    SnacksPickerPrompt          = { fg = c.green2, bold = true },
    SnacksPickerSelected        = { fg = c.magenta1},

    -- custom user-defined group
    SnacksPickerBorderSB        = { fg = c.overlay0, bg = GRAY_DARK },

    -- scratch
    SnacksScratchTitle          = { fg = c.magenta0, bg = c.bg0, bold = true },
    SnacksScratchFooter         = { fg = c.blue0, bg = c.bg0, bold = true },
    SnacksScratchDesc           = { fg = c.overlay1, bg = c.bg0, bold = true },
    SnacksScratchKey            = { fg = c.rose0, bg = c.bg0, bold = true},

    SnacksScratchCursorLine     = { bg = ds.color.lighten(c.bg0, 40) },
  }
end

return M
