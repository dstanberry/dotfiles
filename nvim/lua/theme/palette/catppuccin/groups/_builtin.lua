local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- vim editor colors
    ColorColumn          = { bg = c.gray0 },
    Conceal              = { fg = c.overlay1 },
    CurSearch            = { fg = c.bg1, bg = c.red1 },
    IncSearch            = { fg = c.bg1, bg = ds.color.blend(c.aqua1, c.bg2, 0.9) },
    Substitute           = { fg = ds.color.blend(c.red1, c.magenta2, 0.5), bg = c.gray1 },
    Search               = { fg = c.fg2, bg = ds.color.blend(c.aqua1, c.bg2, 0.3) },
    Cursor               = { fg = c.bg2, bg = c.rose1 },
    CursorIM             = { fg = c.bg2, bg = c.rose1 },
    lCursor              = { fg = c.bg2, bg = c.rose1 },
    CursorColumn         = { bg = c.bg1 },
    CursorLine           = { bg = ds.color.blend(c.gray0, c.bg2, 0.64) },
    CursorLineNr         = { fg = c.purple0 },
    Debug                = { link = "Special" },
    EndOfBuffer          = { fg = c.bg2 },
    ErrorMsg             = { fg = c.red1, bold = true, italic = true },
    FoldColumn           = { fg = c.overlay0 },
    Folded               = { fg = c.blue1, bg = c.gray1 },
    MatchParen           = { fg = c.orange1, bg = c.gray1, bold = true },
    ModeMsg              = { fg = c.fg2, bold = true },
    MoreMsg              = { fg = c.blue1 },
    MsgArea              = { fg = c.fg2 },
    NonText              = { fg = c.overlay0 },
    Normal               = { fg = c.fg2, bg = c.bg2 },
    NormalNC             = { fg = c.fg2, bg = c.bg2 },
    -- custom alternate background(s)
    NormalOverlay        = { fg = c.fg2, bg = c.bgX },
    NormalSB             = { fg = c.fg2, bg = c.bg0 },

    FloatShadow          = { fg = c.overlay0 },
    FloatShadowThrough   = { bg = ds.color.blend(c.bg1, c.bg2, 0.45) },
    FloatBorder          = { fg = c.blue1, bg = c.bg1 },
    FloatTitle           = { fg = c.fg0, bg = c.bg1 },
    NormalFloat          = { fg = c.fg2, bg = c.bg1 },

    PMenu                = { fg = c.overlay2, bg = c.bg1 },
    PMenuBorder          = { link = "FloatBorder" },
    PMenuSbar            = { bg = c.gray0 },
    PMenuSel             = { bg = c.gray0, bold = true },
    PmenuExtra           = { fg = c.overlay0 },
    PmenuExtraSel        = { fg = c.overlay0, bg = c.gray0, bold = true },

    Question             = { fg = c.blue1 },
    QuickFixLine         = { bg = c.gray1, bold = true },
    qfLineNr             = { fg = c.yellow1 },
    qfFileName           = { fg = c.blue1 },
    SignColumnSB         = { fg = c.gray1, bg = c.bg0 },
    SpecialKey           = { link = "NonText" },
    SpellBad             = { sp = c.red1, undercurl = true },
    SpellCap             = { sp = c.yellow1, undercurl = true },
    SpellLocal           = { sp = c.blue1, undercurl = true },
    SpellRare            = { sp = c.green1, undercurl = true },
    TermCursor           = { fg = c.bg2, bg = c.rose1 },
    TermCursorNC         = { fg = c.bg2, bg = c.overlay2 },
    Title                = { fg = c.blue1, bold = true },
    VertSplit            = { fg = c.bg0 },
    WinSeparator         = { fg = c.bg0 },
    Visual               = { bg = c.gray1, bold = true },
    VisualNOS            = { bg = c.gray1, bold = true },
    Whitespace           = { fg = c.gray1 },
    WildMenu             = { bg = c.overlay0 },

    -- standard syntax highlighting
    Boolean              = { fg = c.orange1 },
    Character            = { fg = c.cyan1 },
    String               = { fg = c.green1 },
    Number               = { fg = c.orange1 },
    Float                = { link = "Number" },

    Identifier           = { fg = c.rose0 },
    Function             = { fg = c.blue1 },

    Statement            = { fg = c.purple1 },
    Keyword              = { fg = c.purple1 },
    Operator             = { fg = c.aqua1 },
    Conditional          = { fg = c.purple1 },
    Exception            = { fg = c.purple1 },
    Label                = { fg = c.aqua0 },
    Repeat               = { fg = c.purple1 },

    PreProc              = { fg = c.magenta2 },
    Define               = { link = "PreProc" },
    Include              = { fg = c.purple1 },
    Macro                = { fg = c.purple1 },
    PreCondit            = { link = "PreProc" },

    Special              = { fg = c.magenta2 },
    Delimiter            = { fg = c.overlay2 },
    SpecialChar          = { link = "Special" },
    SpecialComment       = { link = "Special" },
    Tag                  = { fg = c.purple0, bold = true },

    Type                 = { fg = c.yellow1 },
    StorageClass         = { fg = c.yellow1 },
    Structure            = { fg = c.yellow1 },
    Typedef              = { link = "Type" },

    Comment              = { fg = c.overlay2 },
    Todo                 = { fg = c.bg2, bg = c.rose0, bold = true },

    Underlined           = { underline = true },
    Bold                 = { bold = true },
    Italic               = { italic = true },

    htmlH1               = { fg = c.magenta2, bold = true },
    htmlH2               = { fg = c.blue1, bold = true },

    -- diff highlighting
    DiffAdd              = { bg = ds.color.blend(c.green1, c.bg2, 0.18) },
    DiffChange           = { bg = ds.color.blend(c.blue1, c.bg2, 0.07) },
    DiffDelete           = { bg = ds.color.blend(c.red1, c.bg2, 0.18) },
    DiffText             = { bg = ds.color.blend(c.blue1, c.bg2, 0.30) },
    DiffAdded            = { fg = c.green1 },
    DiffNewFile          = { fg = c.orange1 },
    DiffLine             = { fg = c.overlay0 },
    DiffRemoved          = { fg = c.red1 },
    diffOldFile          = { fg = c.yellow1 },
    diffIndexLine        = { fg = c.cyan1 },

    -- lsp highlighting
    LspReferenceText     = { bg = c.gray1 },
    LspReferenceRead     = { bg = c.gray1 },
    LspReferenceWrite    = { bg = c.gray1 },
    LspCodeLens          = { fg = c.overlay0 },
    LspCodeLensSeparator = { link = "LspCodeLens" },
    LspInlayHint         = { fg = c.overlay0, bg = ds.color.blend(c.gray0, c.bg2, 0.64) },

    -- statusline highlighting
    StatusLine           = { fg = c.fg2, bg = c.bg1 },
    StatusLineNC         = { fg = c.gray1, bg = c.bg1 },

    -- tabline highlighting
    TabLine              = { fg = c.overlay0, bg = c.bg0 },
    TabLineFill          = { bg = c.bg1 },
    TabLineSel           = { link = "Normal" },

    -- winbar highlighting
    Winbar               = { fg = c.rose1 },
    WinbarNC             = { link = "Winbar" },
  }
end

return M
