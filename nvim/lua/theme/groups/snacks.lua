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
  local BG_L = ds.color.lighten(c.bg0, 40)

  local HINT = ds.color.get "DiagnosticHint"
  local INFO = ds.color.get "DiagnosticInfo"
  local WARN = ds.color.get "DiagnosticWarn"
  local ERROR = ds.color.get "DiagnosticError"

  local HINT_D = ds.color.blend(HINT, c.bgX, 0.03)
  local HINT_L = ds.color.blend(HINT, c.bgX, 0.1)
  local INFO_D = ds.color.blend(INFO, c.bgX, 0.03)
  local INFO_L = ds.color.blend(INFO, c.bgX, 0.1)
  local WARN_D = ds.color.blend(WARN, c.bgX, 0.03)
  local WARN_L = ds.color.blend(WARN, c.bgX, 0.1)
  local ERROR_D = ds.color.blend(ERROR, c.bgX, 0.03)
  local ERROR_L = ds.color.blend(ERROR, c.bgX, 0.1)
  local OVERLAY_D = ds.color.blend(c.overlay0, GRAY_DARK, 0.2)

  -- stylua: ignore
  return {
    SnacksFooter               = { fg = c.blue0, bg = c.bg0, bold = true },
    SnacksFooterDesc           = { fg = c.overlay1, bg = c.bg0, bold = true },
    SnacksFooterKey            = { fg = c.rose0, bg = c.bg0, bold = true},
    SnacksNormal               = { fg = c.white, bg = c.bg0 },
    SnacksTitle                = { fg = c.red1, bg = GRAY_DARK, bold = true },

    -- dashboard
    SnacksDashboardDesc        = { fg = c.overlay1 },
    SnacksDashboardFooter      = { fg = c.blue0 },
    SnacksDashboardHeader      = { fg = c.magenta0 },
    SnacksDashboardIcon        = { fg = c.overlay1, bold = true },
    SnacksDashboardKey         = { fg = c.rose0 },
    SnacksDashboardShortCut    = { fg = c.overlay1 },
    SnacksDashboardSpecial     = { fg = c.fg_conceal },

    -- indent
    SnacksIndent1              = { fg = CYAN },
    SnacksIndent2              = { fg = ORANGE },
    SnacksIndent3              = { fg = MAGENTA },
    SnacksIndent4              = { fg = CYAN_LIGHT },
    SnacksIndent5              = { fg = PINK },
    SnacksIndent6              = { fg = MAGENTA_LIGHT },
    SnacksIndent7              = { fg = YELLOW },
    SnacksIndent8              = { fg = YELLOW_LIGHT },

    -- notifier
    SnacksNotifierTrace        = { fg = c.white, bg = HINT_D },
    SnacksNotifierBorderTrace  = { fg = HINT_L, bg = HINT_D },
    SnacksNotifierIconTrace    = { link = "DiagnosticHint" },
    SnacksNotifierTitleTrace   = { fg = HINT },

    SnacksNotifierDebug        = { fg = c.white, bg = HINT_D },
    SnacksNotifierBorderDebug  = { fg = HINT_L, bg = HINT_D },
    SnacksNotifierIconDebug    = { link = "DiagnosticHint" },
    SnacksNotifierTitleDebug   = { fg = HINT },

    SnacksNotifierInfo         = { fg = c.white, bg = INFO_D },
    SnacksNotifierBorderInfo   = { fg = INFO_L, bg = INFO_D },
    SnacksNotifierIconInfo     = { link = "DiagnosticInfo" },
    SnacksNotifierTitleInfo    = { fg = INFO },

    SnacksNotifierWarn         = { fg = c.white, bg = WARN_D },
    SnacksNotifierBorderWarn   = { fg = WARN_L, bg = WARN_D },
    SnacksNotifierIconWarn     = { link = "DiagnosticWarn" },
    SnacksNotifierTitleWarn    = { fg = WARN },

    SnacksNotifierError        = { fg = c.white, bg = ERROR_D },
    SnacksNotifierBorderError  = { fg = ERROR_L, bg = ERROR_D },
    SnacksNotifierIconError    = { link = "DiagnosticError" },
    SnacksNotifierTitleError   = { fg = ERROR },

    SnacksNotifierHistory      = { fg = c.fg1, bg = c.bg0 },
    SnacksNotifierHistoryTitle = { fg = c.red1, bg = c.bg0, bold = true },

    -- picker
    SnacksPicker               = { bg = GRAY_DARK },
    SnacksPickerBorder         = { fg = OVERLAY_D, bg = GRAY_DARK },

    SnacksPickerBoxTitle       = { fg = c.bg2, bg = c.red1, bold = true },

    SnacksPickerInputBorder    = { fg = c.red1, bg = GRAY_DARK },
    SnacksPickerInputTitle     = { fg = c.red1, bg = GRAY_DARK, bold = true },

    SnacksPickerList           = { bg = GRAY_DARK },
    SnacksPickerListCursorLine = { bg = c.bg4, bold = true },

    SnacksPickerPreview        = { bg = c.bg0 },
    SnacksPickerPreviewBorder  = { fg = c.bg0, bg = c.bg0 },
    SnacksPickerPreviewTitle   = { fg = c.bg2, bg = c.bg0, bold = true },

    SnacksPickerDir            = { fg = c.gray2 },
    SnacksPickerSearch         = { fg = c.orange0, bold = true },
    SnacksPickerFlag           = { fg = c.red1, bg = GRAY_DARK, bold = true, italic = true },
    SnacksPickerMatch          = { fg = c.orange0, bold = true },
    SnacksPickerPickWin        = { fg = GRAY, bg = c.overlay0, bold = true, italic = true },
    SnacksPickerPickWinCurrent = { fg = GRAY, bg = c.magenta0, bold = true, italic = true },
    SnacksPickerPrompt         = { fg = c.green2, bold = true },
    SnacksPickerSelected       = { fg = c.magenta1},
    SnacksPickerToggle         = { fg = GRAY_DARK, bg = c.red1, bold = true, italic = true },

    -- scratch
    SnacksScratchTitle         = { fg = c.red1, bg = c.bg0, bold = true },
    SnacksScratchCursorLine    = { bg = BG_L },

  }
end

return M
