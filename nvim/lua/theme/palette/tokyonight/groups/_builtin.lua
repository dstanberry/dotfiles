local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- vim editor colors
    ColorColumn                = { bg = c.black },
    Conceal                    = { fg = c.gray2 },
    CurSearch                  = { link = "IncSearch" },
    Search                     = { fg = c.fg2, bg = ds.color.blend(c.blue3, c.bg2, 0.4) },
    Cursor                     = { fg = c.bg2, bg = c.fg2 },
    CursorIM                   = { fg = c.bg2, bg = c.fg2 },
    lCursor                    = { fg = c.bg2, bg = c.fg2 },
    CursorLineNr               = { fg = c.orange1, bold = true },
    Debug                      = { fg = c.orange1 },
    FoldColumn                 = { fg = c.fg_comment, bg = c.bg2 },
    Folded                     = { fg = c.blue1, bg = c.gray0 },
    LineNrAbove                = { fg = c.gray1 },
    LineNrBelow                = { fg = c.gray1 },
    MatchParen                 = { fg = c.orange1, bold = true },
    MoreMsg                    = { fg = c.blue1 },
    NonText                    = { fg = c.gray2 },
    Normal                     = { fg = c.fg2, bg = c.bg2 },
    NormalNC                   = { fg = c.fg2, bg = c.bg2 },
    -- custom alternate background(s)
    NormalOverlay              = { fg = c.fg1, bg = c.bgX },
    NormalSB                   = { fg = c.fg0, bg = ds.color.darken(c.bg2, 15) },

    FloatBorder                = { fg = ds.color.blend(ds.color.darken(c.cyan2, 5), c.bg2, 0.8), bg = c.bg0 },
    FloatTitle                 = { fg = ds.color.blend(ds.color.darken(c.cyan2, 5), c.bg2, 0.8), bg = c.bg0 },
    NormalFloat                = { fg = c.fg0, bg = c.bgX },

    PMenu                      = { fg = c.fg2, bg = c.bg1 },
    PMenuMatch                 = { fg = ds.color.darken(c.cyan2, 5), bg = c.bg1 },
    PMenuMatchSel              = { fg = ds.color.darken(c.cyan2, 5), bg = ds.color.blend(c.gray1, c.bg2, 0.8) },
    PMenuSbar                  = { bg = ds.color.blend(c.bg1, c.fg2, 0.95) },
    PMenuSel                   = { bg = ds.color.blend(c.gray1, c.bg2, 0.8) },
    PmenuThumb                 = { bg = c.gray1 },

    Question                   = { fg = c.blue1 },
    qfFileName                 = { fg = c.blue1 },
    SignColumn                 = { fg = c.gray1, bg = c.bg2 },
    SignColumnSB               = { fg = c.gray1, bg = ds.color.darken(c.bg2, 15) },
    SpecialKey                 = { fg = c.gray2 },
    SpellBad                   = { sp = c.red1, undercurl = true },
    SpellCap                   = { sp = c.yellow1, undercurl = true },
    SpellLocal                 = { sp = c.cyan2, undercurl = true },
    SpellRare                  = { sp = ds.color.lighten(c.cyan0, 10), undercurl = true },
    Title                      = { fg = c.blue1, bold = true },
    VertSplit                  = { fg = ds.color.darken(c.bg2, 50) },
    WinSeparator               = { fg = ds.color.darken(c.bg2, 50), bold = true },
    VisualNOS                  = { bg = c.bg_visual },
    Whitespace                 = { fg = c.gray1 },
    WildMenu                   = { bg = c.bg_visual },

    -- standard syntax highlighting
    Identifier                 = { fg = c.magenta2 },
    Function                   = { fg = c.blue1 },

    Statement                  = { fg = c.magenta2 },
    Keyword                    = { fg = c.cyan1 },
    Operator                   = { fg = ds.color.lighten(c.cyan0, 10) },

    Special                    = { fg = ds.color.darken(c.cyan2, 5) },
    Delimiter                  = { link = "Special" },

    Type                       = { fg = ds.color.darken(c.cyan2, 5) },

    Todo                       = { fg = c.yellow1, bg = c.bg2 },

    Bold                       = { fg = c.fg2, bold = true },
    Italic                     = { fg = c.fg2, italic = true },

    htmlH1                     = { fg = c.magenta2, bold = true },

    debugBreakpoint            = { fg = c.cyan2, bg = ds.color.blend(c.cyan2, c.bg2, 0.1) },
    debugPC                    = { bg = ds.color.darken(c.bg2, 15) },
    dosIniLabel                = { link = "@property" },
    helpCommand                = { fg = c.blue1, bg = ds.color.lighten(c.gray0, 10) },

    -- diff highlighting
    DiffAdded                  = { fg = ds.color.lighten(c.green0, 10), bg = c.diff_add },
    DiffNewFile                = { fg = ds.color.darken(c.cyan2, 5), bg = c.diff_add },
    DiffOldFile                = { fg = ds.color.darken(c.cyan2, 5), bg = c.diff_delete },
    DiffLine                   = { fg = c.fg_comment },
    DiffIndexLine              = { fg = c.magenta2 },
    DiffRemoved                = { fg = c.red0, bg = c.diff_delete },

    -- lsp diagnostic highlighting
    DiagnosticUnnecessary      = { fg = ds.color.lighten(c.gray0, 10) },

    DiagnosticError            = { fg = c.red1 },
    DiagnosticWarn             = { fg = c.yellow1 },
    DiagnosticInfo             = { fg = c.cyan2 },
    DiagnosticHint             = { fg = ds.color.lighten(c.cyan0, 10) },

    DiagnosticVirtualTextError = { fg = c.red1, bg = ds.color.blend(c.red1, c.bg2, 0.1) },
    DiagnosticVirtualTextWarn  = { fg = c.yellow1, bg = ds.color.blend(c.yellow1, c.bg2, 0.1) },
    DiagnosticVirtualTextInfo  = { fg = c.cyan2, bg = ds.color.blend(c.cyan2, c.bg2, 0.1) },
    DiagnosticVirtualTextHint  = { fg = ds.color.lighten(c.cyan0, 10), bg = ds.color.blend(ds.color.lighten(c.cyan0, 10), c.bg2, 0.1) },

    DiagnosticUnderlineError   = { undercurl = true, sp = c.red1 },
    DiagnosticUnderlineWarn    = { undercurl = true, sp = c.yellow1 },
    DiagnosticUnderlineInfo    = { undercurl = true, sp = c.cyan2 },
    DiagnosticUnderlineHint    = { undercurl = true, sp = ds.color.lighten(c.cyan0, 10) },

    -- lsp inline completion highlighting
    ComplHint                  = { fg = ds.color.lighten(c.gray0, 10) },

    -- lsp codelens highlighting
    LspCodeLens                = { fg = c.fg_comment },

    -- lsp inlay hints
    LspInlayHint               = { fg = c.gray2, bg = ds.color.blend(ds.color.darken(c.blue2, 5), c.bg2, 0.1) },

    -- lsp document highlighting
    LspReferenceText           = { bg = c.gray1 },
    LspReferenceRead           = { bg = c.gray1 },
    LspReferenceWrite          = { bg = c.gray1 },
    LspSignatureActiveParameter = { fg = c.fg2, bg = ds.color.blend(c.bg_visual, c.bg2, 0.4), bold = true },
    LspInfoBorder              = { fg = ds.color.blend(ds.color.darken(c.cyan2, 5), c.bg2, 0.8), bg = c.bg0 },

    -- health highlighting
    healthError                = { fg = c.red1 },
    healthSuccess              = { fg = c.green1 },
    healthWarning              = { fg = c.yellow1 },

    helpExample                = { fg = c.fg_comment },

    -- statusline highlighting
    StatusLine                 = { fg = c.fg0, bg = ds.color.darken(c.bg2, 15) },
    StatusLineNC               = { fg = c.gray1, bg = ds.color.darken(c.bg2, 15) },

    -- tabline highlighting
    TabLine                    = { fg = c.gray1, bg = ds.color.darken(c.bg2, 15) },
    TabLineFill                = { bg = c.black },
    TabLineSel                 = { fg = c.black, bg = c.blue1 },
  }
end

return M
