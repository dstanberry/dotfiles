local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- |mini.align| `=<bs>fn==1<cr>t` 
  -- stylua: ignore
  return {
    -- vim editor colors
    ColorColumn                                = { bg = c.bg3 },
    Conceal                                    = { fg = c.fg_conceal },
    CurSearch                                  = { fg = c.black, bg = c.orange0 },
    IncSearch                                  = { fg = c.black, bg = c.orange0 },
    Substitute                                 = { fg = c.black, bg = c.red1 },
    Search                                     = { fg = c.orange0, underline = true },
    Cursor                                     = { fg = c.bg2, bg = c.fg1 },
    CursorIM                                   = { fg = c.bg2, bg = c.fg1 },
    lCursor                                    = { fg = c.bg2, bg = c.fg1 },
    CursorColumn                               = { bg = c.bg3 },
    CursorLine                                 = { bg = c.bg3 },
    CursorLineNr                               = { fg = c.aqua1 },
    Debug                                      = { fg = c.gray2 },
    Directory                                  = { fg = c.blue1 },
    ErrorMsg                                   = { fg = c.red1 },
    FoldColumn                                 = { link = "SignColumn" },
    Folded                                     = { fg = c.gray2, bg = c.gray0 },
    LineNr                                     = { fg = c.gray1 },
    MatchParen                                 = { fg = c.red1, bold = true },
    ModeMsg                                    = { fg = c.fg0, bold = true },
    MoreMsg                                    = { fg = c.blue3 },
    MsgArea                                    = { fg = c.fg0 },
    -- MsgSeparator                            = { fg = c.fg0 },
    NonText                                    = { fg = c.grayX },
    Normal                                     = { fg = c.fg1, bg = c.bg2 },
    NormalNC                                   = { fg = c.fg1, bg = c.bg2 },
    FloatBorder                                = { fg = c.bg0, bg = c.bg0 },
    NormalFloat                                = { fg = c.white, bg = c.bg0 },
    NvimInternalError                          = { link = "Error" },
    PMenu                                      = { link = "NormalFloat" },
    PMenuSbar                                  = { fg = c.gray0, bg = c.bg0 },
    PMenuSel                                   = { fg = c.bg3, bg = c.blue1 },
    Question                                   = { fg = c.blue3 },
    QuickFixLine                               = { bg = c.bg_visual, bold = true },
    qfLineNr                                   = { fg = c.gray2 },
    qfFileName                                 = { fg = c.blue3 },
    SignColumn                                 = { fg = c.gray1 },
    SpecialKey                                 = { fg = c.aqua2 },
    SpecialKeyWin                              = { fg = c.gray1 },
    SpellBad                                   = { sp = c.red0, undercurl = true },
    SpellCap                                   = { sp = c.yellow2, undercurl = true },
    SpellLocal                                 = { sp = c.aqua0, undercurl = true },
    SpellRare                                  = { sp = c.purple0, undercurl = true },
    -- TermCursor                              = { fg = c.bg2, bg = c.fg2 },
    -- TermCursorNC                            = { fg = c.bg2, bg = c.fg2 },
    Title                                      = { fg = c.blue0, bold = true },
    VertSplit                                  = { fg = c.bg3 },
    WinSeparator                               = { link = "VertSplit" },
    Visual                                     = { bg = c.bg_visual },
    VisualNOS                                  = { fg = c.blue1 },
    WarningMsg                                 = { fg = c.yellow1 },
    Whitespace                                 = { link = "NonText" },
    WildMenu                                   = { link = "Visual" },
    -- custom alternate backgrounds
    FloatBorderSB                              = { fg = c.gray1, bg = c.bg0 },
    NormalSB                                   = { fg = c.fg1, bg = c.bgX },

    -- standard syntax highlighting
    Constant                                   = { fg = c.orange0 },
    Boolean                                    = { fg = c.yellow2 },
    Character                                  = { fg = c.green2 },
    String                                     = { fg = c.green2 },
    Number                                     = { fg = c.orange1 },
    -- Float                                   = { fg = orange1 },

    Identifier                                 = { fg = c.magenta1 },
    Function                                   = { fg = c.blue2 },

    Statement                                  = { fg = c.magenta1 },
    Keyword                                    = { fg = c.magenta2 },
    Operator                                   = { fg = c.fg1 },
    -- Conditional                             = {},
    -- Exception                               = {},
    -- Label                                   = {},
    -- Repeat                                  = {},

    PreProc                                    = { fg = c.cyan1 },
    -- Define                                  = {},
    -- Include                                 = {},
    Macro                                      = { fg = c.cyan0 },
    -- PreCondit                               = {},

    Special                                    = { fg = c.aqua1 },
    -- Delimiter                               = {},
    SpecialChar                                = { fg = c.rose1 },
    SpecialComment                             = { fg = c.fg_comment, italic = true },
    -- Tag                                     = {},

    Type                                       = { fg = c.red2 },
    -- StorageClass                            = {},
    Structure                                  = { fg = c.cyan2 },
    -- Typedef                                 = {},

    Comment                                    = { fg = c.gray1, italic = true },
    Error                                      = { fg = c.red1 },
    Todo                                       = { fg = c.yellow2 },

    Underlined                                 = { underline = true },
    Bold                                       = { bold = true },
    Italic                                     = { italic = true },

    htmlH1                                     = { fg = ds.color.lighten(c.blue3, 20), bold = true },
    htmlH2                                     = { fg = ds.color.lighten(c.blue4, 30), bold = true },

    -- diff highlighting
    DiffAdd                                    = { bg = c.diff_add },
    DiffChange                                 = { bg = c.diff_change },
    DiffDelete                                 = { bg = c.diff_delete },
    DiffText                                   = { bg = c.diff_text },
    DiffAdded                                  = { fg = c.green2 },
    DiffFile                                   = { fg = c.blue1 },
    DiffNewFile                                = { fg = c.green2 },
    DiffLine                                   = { fg = c.blue2 },
    DiffRemoved                                = { fg = c.red1 },

    -- git highlighting
    gitcommitBlank                             = { fg = c.fg1 },
    gitcommitOverflow                          = { fg = c.blue1 },
    gitcommitSummary                           = { fg = c.green2 },
    gitcommitComment                           = { fg = c.gray1, italic = true },
    gitcommitUntracked                         = { fg = c.gray1 },
    gitcommitDiscarded                         = { fg = c.gray1 },
    gitcommitSelected                          = { fg = c.gray1 },
    gitcommitHeader                            = { fg = c.magenta0 },
    gitcommitSelectedType                      = { fg = c.blue2 },
    gitcommitUnmergedType                      = { fg = c.blue2 },
    gitcommitDiscardedType                     = { fg = c.blue2 },
    gitcommitBranch                            = { fg = c.yellow2, bold = true },
    gitcommitUntrackedFile                     = { fg = c.yellow2 },
    gitcommitUnmergedFile                      = { fg = c.blue1, bold = true },
    gitcommitDiscardedFile                     = { fg = c.blue1, bold = true },
    gitcommitSelectedFile                      = { fg = c.green2, bold = true },

    -- lsp codelens highlighting
    LspCodeLens                                = { fg = ds.color.lighten(c.gray1, 20) },
    LspCodeLensText                            = { fg = ds.color.lighten(c.gray1, 20) },
    LspCodeLensSeparator                       = { fg = ds.color.lighten(c.gray1, 20) },

    -- lsp inlay hints
    LspInlayHint                               = { fg = c.gray1, bg = ds.color.blend(c.gray1, c.bg2, 0.2), italic = true },

    -- lsp document highlighting
    LspReferenceText                           = { underline = true, sp = c.gray1 },
    LspReferenceRead                           = { underline = true, sp = c.gray1 },
    LspReferenceWrite                          = { bold = true, italic = true, underline = true, sp = c.gray1 },

    -- lsp diagnostic highlighting
    DiagnosticDeprecated                       = { sp = c.red3, italic = true, strikethrough = true },
    DiagnosticUnnecessary                      = { fg = c.gray2, italic = true },

    DiagnosticError                            = { fg = c.red0 },
    DiagnosticWarn                             = { fg = c.yellow0 },
    DiagnosticInfo                             = { fg = c.aqua1 },
    DiagnosticHint                             = { fg = c.magenta0 },

    DiagnosticVirtualTextError                 = { fg = ds.color.blend(c.red0, c.bg2, 0.6) },
    DiagnosticVirtualTextWarn                  = { fg = ds.color.blend(c.yellow0, c.bg2, 0.6) },
    DiagnosticVirtualTextInfo                  = { fg = ds.color.blend(c.aqua1, c.bg2, 0.6) },
    DiagnosticVirtualTextHint                  = { fg = ds.color.blend(c.magenta0, c.bg2, 0.6) },

    DiagnosticUnderlineError                   = { undercurl = true, sp = c.red0 },
    DiagnosticUnderlineWarn                    = { undercurl = true, sp = c.yellow0 },
    DiagnosticUnderlineInfo                    = { undercurl = true, sp = c.aqua1 },
    DiagnosticUnderlineHint                    = { undercurl = true, sp = c.magenta0 },

    -- statusline highlighting
    StatusLine                                 = { fg = c.fg0, bg = c.gray0 },
    StatusLineNC                               = { fg = c.gray1, bg = c.gray0 },

    -- tabline highlighting
    TabLine                                    = { fg = c.gray1, bg = c.bg2 },
    TabLineFill                                = { fg = c.gray1, bg = c.bg2 },
    TabLineSel                                 = { fg = c.fg1, bg = c.bg0, bold = true },

    -- winbar highlighting
    Winbar                                     = { fg = ds.color.lighten(c.gray1, 10), bg = c.bg2 },
    WinbarNC                                   = { bg = c.bg2 },
    -- custom winbar highlights
    WinbarFilename                             = { fg = ds.color.lighten(c.gray2, 5), bg = c.bg2, bold = true },
    WinbarContext                              = { fg = ds.color.lighten(c.gray1, 15), bg = c.bg2 }
  }
end

return M
