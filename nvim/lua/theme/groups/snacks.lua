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
    SnacksNormal                = { fg = c.white, bg = c.bg0 },

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
    SnacksNotifierTrace         = { fg   = c.white },
    SnacksNotifierBorderTrace   = { fg = ds.color.get_color "DiagnosticHint" },
    SnacksNotifierIconTrace     = { link = "DiagnosticHint" },
    SnacksNotifierTitleTrace    = { fg = ds.color.get_color "DiagnosticHint" },

    SnacksNotifierDebug         = { fg   = c.white },
    SnacksNotifierBorderDebug   = { fg = ds.color.get_color "DiagnosticHint" },
    SnacksNotifierIconDebug     = { link = "DiagnosticHint" },
    SnacksNotifierTitleDebug    = { fg = ds.color.get_color "DiagnosticHint" },

    SnacksNotifierInfo          = { fg   = c.white },
    SnacksNotifierBorderInfo    = { fg = ds.color.get_color "DiagnosticInfo" },
    SnacksNotifierIconInfo      = { link = "DiagnosticInfo" },
    SnacksNotifierTitleInfo     = { fg = ds.color.get_color "DiagnosticInfo" },

    SnacksNotifierWarn          = { fg   = c.white },
    SnacksNotifierBorderWarn    = { fg = ds.color.get_color "DiagnosticWarn" },
    SnacksNotifierIconWarn      = { link = "DiagnosticWarn" },
    SnacksNotifierTitleWarn     = { fg = ds.color.get_color "DiagnosticWarn" },

    SnacksNotifierError         = { fg   = c.white },
    SnacksNotifierBorderError   = { fg = ds.color.get_color "DiagnosticError" },
    SnacksNotifierIconError     = { link = "DiagnosticError" },
    SnacksNotifierTitleError    = { fg = ds.color.get_color "DiagnosticError" },

    SnacksNotifierHistory       = { fg = c.fg1, bg = c.bg0 },
    SnacksNotifierHistoryTitle  = { fg = c.blue0, bg = c.bg0, bold = true },

    -- picker
    SnacksPicker                = { bg = GRAY_DARK },
    SnacksPickerBorder          = { fg = GRAY_DARK, bg = GRAY_DARK },
    SnacksPickerBorderSB        = { fg = ds.color.blend(c.overlay0, GRAY_DARK, 0.2), bg = GRAY_DARK },

    SnacksPickerBoxTitle        = { fg = c.bg2, bg = c.red1, bold = true },

    SnacksPickerInputBorder     = { fg = c.red1, bg = GRAY_DARK },
    SnacksPickerInputTitle      = { fg = c.red1, bg = GRAY_DARK, bold = true },

    SnacksPickerList            = { bg = GRAY_DARK },
    SnacksPickerListCursorLine  = { bg = BLUE, bold = true },

    SnacksPickerPreview         = { bg = c.bg0 },
    SnacksPickerPreviewBorder   = { fg = c.bg0, bg = c.bg0 },
    SnacksPickerPreviewTitle    = { fg = c.bg2, bg = c.bg0, bold = true },

    SnacksPickerDir             = { fg = c.gray2 },
    SnacksPickerSearch          = { fg = c.orange0, bold = true },
    SnacksPickerFlag            = { fg = c.red1, bg = GRAY_DARK, bold = true, italic = true },
    SnacksPickerMatch           = { fg = c.orange0, bold = true },
    SnacksPickerPickWin         = { fg = GRAY, bg = c.overlay0, bold = true, italic = true },
    SnacksPickerPickWinCurrent  = { fg = GRAY, bg = c.magenta0, bold = true, italic = true },
    SnacksPickerPrompt          = { fg = c.green2, bold = true },
    SnacksPickerSelected        = { fg = c.magenta1},
    SnacksPickerToggle          = { fg = GRAY_DARK, bg = c.red1, bold = true, italic = true },

    -- scratch
    SnacksScratchTitle          = { fg = c.magenta0, bg = c.bg0, bold = true },
    SnacksScratchFooter         = { fg = c.blue0, bg = c.bg0, bold = true },
    SnacksScratchDesc           = { fg = c.overlay1, bg = c.bg0, bold = true },
    SnacksScratchKey            = { fg = c.rose0, bg = c.bg0, bold = true},

    SnacksScratchCursorLine     = { bg = ds.color.lighten(c.bg0, 40) },
  }
end

return M
