local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local BORDER = ds.color.blend(c.aqua1, "#000000", 0.8)
  local GIT_ADD = "#b8db87"
  local GIT_CHANGE = "#7ca1f2"
  local GIT_DELETE = "#e26a75"

  -- stylua: ignore
  return {
    -- vim editor colors
    ColorColumn                = { bg = c.black },
    CurSearch                  = { link = "IncSearch" },
    Search                     = { fg = c.fg2, bg = c.blue1 },
    Cursor                     = { fg = c.bg2, bg = c.fg2 },
    CursorIM                   = { fg = c.bg2, bg = c.fg2 },
    lCursor                    = { fg = c.bg2, bg = c.fg2 },
    CursorLineNr               = { fg = c.orange2, bold = true },
    Debug                      = { fg = c.orange2 },
    FoldColumn                 = { fg = c.fg0, bg = c.bg2 },
    Folded                     = { fg = c.blue3, bg = c.gray0 },
    LineNrAbove                = { fg = c.gray0 },
    LineNrBelow                = { fg = c.gray0 },
    MatchParen                 = { fg = c.orange2, bold = true },
    MoreMsg                    = { fg = c.blue3 },
    Normal                     = { fg = c.fg2, bg = c.bg2 },
    NormalNC                   = { fg = c.fg2, bg = c.bg2 },
    -- custom alternate background(s)
    NormalOverlay              = { fg = c.fg1, bg = c.bgX },
    NormalSB                   = { fg = c.fg1, bg = c.bg1 },

    FloatBorder                = { fg = BORDER, bg = c.bg1 },
    FloatTitle                 = { fg = BORDER, bg = c.bg1 },
    NormalFloat                = { fg = c.fg2, bg = c.bg1 },

    PMenu                      = { fg = c.fg2, bg = c.bg1 },
    PMenuMatch                 = { fg = c.aqua1, bg = c.bg1 },
    PMenuMatchSel              = { fg = c.aqua1, bg = ds.color.blend(c.gray0, "#000000", 0.8) },
    PMenuSbar                  = { bg = ds.color.blend(c.bg1, "#ffffff", 0.95) },
    PMenuSel                   = { bg = ds.color.blend(c.gray0, "#000000", 0.8) },
    PmenuThumb                 = { bg = c.gray0 },

    Question                   = { fg = c.blue3 },
    qfFileName                 = { fg = c.blue3 },
    SignColumn                 = { fg = c.gray0, bg = c.bg2 },
    SignColumnSB               = { fg = c.gray0, bg = c.bg1 },
    SpecialKey                 = { fg = c.gray1 },
    SpellBad                   = { sp = c.red2, undercurl = true },
    SpellCap                   = { sp = c.yellow1, undercurl = true },
    SpellLocal                 = { sp = c.aqua0, undercurl = true },
    SpellRare                  = { sp = c.cyan1, undercurl = true },
    Title                      = { fg = c.blue3, bold = true },
    VertSplit                  = { fg = c.black },
    WinSeparator               = { fg = c.black, bold = true },
    VisualNOS                  = { bg = c.bg_visual },
    Whitespace                 = { fg = c.gray0 },
    WildMenu                   = { bg = c.bg_visual },

    -- standard syntax highlighting
    Identifier                 = { fg = c.purple1 },
    Function                   = { fg = c.blue3 },

    Statement                  = { fg = c.purple1 },
    Keyword                    = { fg = c.aqua2 },
    Operator                   = { fg = c.aqua3 },

    Special                    = { fg = c.aqua1 },
    Delimiter                  = { link = "Special" },

    Type                       = { fg = c.aqua1 },

    Todo                       = { fg = c.blue3, bg = c.bg2 },

    Bold                       = { fg = c.fg2, bold = true },
    Italic                     = { fg = c.fg2, italic = true },

    htmlH1                     = { fg = c.purple1, bold = true },

    debugBreakpoint            = { fg = c.aqua0, bg = ds.color.blend(c.aqua0, c.bg2, 0.1) },
    debugPC                    = { bg = c.bg1 },
    dosIniLabel                = { link = "@property" },
    helpCommand                = { fg = c.blue3, bg = ds.color.lighten(c.gray0, 10) },

    -- diff highlighting
    DiffAdded                  = { fg = GIT_ADD, bg = c.diff_add },
    DiffChange                 = { fg = GIT_CHANGE, bg = c.diff_change },
    DiffNewFile                = { fg = c.aqua1, bg = c.diff_add },
    DiffOldFile                = { fg = c.aqua1, bg = c.diff_delete },
    DiffLine                   = { fg = c.fg_comment },
    DiffIndexLine              = { fg = c.purple1 },
    DiffRemoved                = { fg = GIT_DELETE, bg = c.diff_delete },

    -- lsp diagnostic highlighting
    DiagnosticUnnecessary      = { fg = ds.color.lighten(c.gray0, 10) },

    DiagnosticError            = { fg = c.red2 },
    DiagnosticWarn             = { fg = c.yellow1 },
    DiagnosticInfo             = { fg = c.aqua0 },
    DiagnosticHint             = { fg = c.cyan1 },

    DiagnosticVirtualTextError = { fg = c.red2, bg = ds.color.blend(c.red2, "#000000", 0.1) },
    DiagnosticVirtualTextWarn  = { fg = c.yellow1, bg = ds.color.blend(c.yellow1, "#000000", 0.1) },
    DiagnosticVirtualTextInfo  = { fg = c.aqua0, bg = ds.color.blend(c.aqua0, "#000000", 0.1) },
    DiagnosticVirtualTextHint  = { fg = c.cyan1, bg = ds.color.blend(c.cyan1, "#000000", 0.1) },

    DiagnosticUnderlineError   = { undercurl = true, sp = c.red2 },
    DiagnosticUnderlineWarn    = { undercurl = true, sp = c.yellow1 },
    DiagnosticUnderlineInfo    = { undercurl = true, sp = c.aqua0 },
    DiagnosticUnderlineHint    = { undercurl = true, sp = c.cyan1 },

    -- lsp inline completion highlighting
    ComplHint                  = { fg = ds.color.lighten(c.gray0, 10) },

    -- lsp codelens highlighting
    LspCodeLens                = { fg = c.fg_comment },

    -- lsp inlay hints
    LspInlayHint               = { fg = c.gray2, bg = ds.color.blend(c.blue2, "#000000", 0.1) },

    -- lsp document highlighting
    LspReferenceText           = { bg = c.gray1 },
    LspReferenceRead           = { bg = c.gray1 },
    LspReferenceWrite          = { bg = c.gray1 },
    LspSignatureActiveParameter = { fg = c.fg2, bg = ds.color.blend(c.bg_visual, c.bg2, 0.4), bold = true },
    LspInfoBorder              = { fg = BORDER, bg = c.bg1 },

    -- health highlighting
    healthError                = { fg = c.red2 },
    healthSuccess              = { fg = c.cyan1 },
    healthWarning              = { fg = c.yellow1 },

    helpExample                = { fg = c.fg_comment },

    -- statusline highlighting
    StatusLine                 = { fg = c.fg1, bg = c.bg1 },
    StatusLineNC               = { fg = c.gray0, bg = c.bg1 },

    -- tabline highlighting
    TabLine                    = { fg = c.gray0, bg = c.bg1 },
    TabLineFill                = { bg = c.black },
    TabLineSel                 = { fg = c.black, bg = c.blue3 },
  }
end

return M
