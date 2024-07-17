---@class ColorPalette
---@field aqua0 string
---@field aqua1 string
---@field aqua2 string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field bg_visual string
---@field bgX string
---@field black string
---@field blue0 string
---@field blue1 string
---@field blue2 string
---@field blue3 string
---@field blue4 string
---@field cyan0 string
---@field cyan1 string
---@field cyan2 string
---@field diff_add string
---@field diff_change string
---@field diff_delete string
---@field diff_text string
---@field fg0 string
---@field fg1 string
---@field fg2 string
---@field fg_comment string
---@field fg_conceal string
---@field gray0 string
---@field gray1 string
---@field gray2 string
---@field grayX string
---@field green0 string
---@field green1 string
---@field green2 string
---@field magenta0 string
---@field magenta1 string
---@field magenta2 string
---@field orange0 string
---@field orange1 string
---@field purple0 string
---@field purple1 string
---@field red0 string
---@field red1 string
---@field red2 string
---@field red3 string
---@field rose0 string
---@field rose1 string
---@field white string
---@field yellow0 string
---@field yellow1 string
---@field yellow2 string

---@alias Colorscheme "kdark"|"catppuccin-frappe"|"catppuccin-mocha"
---@alias Background "light"|"dark"
---@alias Theme table<Colorscheme,ColorPalette>

local M = {}

---@class Colorschemes table<Colorscheme,Theme>
M.themes = {}

M._initialized = false

---@alias HighlightGroups table<string,vim.api.keyset.highlight>

---@param c ColorPalette
---@return HighlightGroups
M.defaults = function(c)
  -- INFO: |mini.align| `=<bs>fn==1<cr>t` 
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
    -- alternate backgrounds
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
    Keyword                                    = { fg = c.magenta1 },
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

    htmlH1                                     = { fg = c.blue3, bold = true },
    htmlH2                                     = { fg = c.magenta1, bold = true },
    htmlH3                                     = { fg = c.fg2, bold = true },

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
    gitcommitHeader                            = { fg = c.magenta1 },
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

    DiagnosticError                            = { fg = c.red1 },
    DiagnosticWarn                             = { fg = c.yellow2 },
    DiagnosticInfo                             = { fg = c.aqua1 },
    DiagnosticHint                             = { fg = c.magenta1 },

    DiagnosticStatusError                      = { fg = c.red1, bg = c.gray0 },
    DiagnosticStatusWarn                       = { fg = c.yellow2, bg = c.gray0 },
    DiagnosticStatusInfo                       = { fg = c.aqua1, bg = c.gray0 },
    DiagnosticStatusHint                       = { fg = c.magenta1, bg = c.gray0 },

    DiagnosticUnderlineError                   = { undercurl = true, sp = c.red1 },
    DiagnosticUnderlineWarn                    = { undercurl = true, sp = c.yellow2 },
    DiagnosticUnderlineInfo                    = { undercurl = true, sp = c.aqua1 },
    DiagnosticUnderlineHint                    = { undercurl = true, sp = c.magenta1 },

    -- lsp semantic tokens
    ["@lsp.type.boolean"]                      = { link = "@boolean" },
    ["@lsp.type.builtinType"]                  = { link = "@type.builtin" },
    ["@lsp.type.class"]                        = { link = "@class" },
    ["@lsp.type.comment"]                      = { link = "@comment" },
    ["@lsp.type.decorator"]                    = { link = "@constant.macro" },
    ["@lsp.type.deriveHelper"]                 = { link = "@attribute" },
    ["@lsp.type.enum"]                         = { link = "@constructor" },
    ["@lsp.type.enumMember"]                   = { link = "@constant" },
    ["@lsp.type.escapeSequence"]               = { link = "@string.escape" },
    ["@lsp.type.event"]                        = { link = "Identifier" },
    ["@lsp.type.formatSpecifier"]              = { link = "@markup.list" },
    ["@lsp.type.function"]                     = { link = "@function" },
    ["@lsp.type.generic"]                      = { link = "@variable" },
    ["@lsp.type.interface"]                    = { fg = ds.color.lighten(c.cyan1, 20) },
    ["@lsp.type.lifetime"]                     = { link = "@keyword.storage" },
    ["@lsp.type.method"]                       = { link = "@function.method" },
    ["@lsp.type.modifier"]                     = { link = "Identifier" },
    ["@lsp.type.namespace"]                    = { link = "@module" },
    ["@lsp.type.number"]                       = { link = "@number" },
    ["@lsp.type.operator"]                     = { link = "@operator" },
    ["@lsp.type.parameter"]                    = { link = "@variable.parameter" },
    ["@lsp.type.property"]                     = { link = "@property" },
    ["@lsp.type.regexp"]                       = { link = "@string.regexp" },
    ["@lsp.type.selfKeyword"]                  = { link = "@variable.builtin" },
    ["@lsp.type.selfTypeKeyword"]              = { link = "@variable.builtin" },
    ["@lsp.type.string"]                       = { link = "@string" },
    ["@lsp.type.struct"]                       = { link = "@structure" },
    ["@lsp.type.type"]                         = { link = "@type" },
    ["@lsp.type.typeAlias"]                    = { link = "@type.definition" },
    ["@lsp.type.typeParameter"]                = { link = "@lsp.type.class" },
    ["@lsp.type.unresolvedReference"]          = { link = "DiagnosticUnderlineError" },
    ["@lsp.type.variable"]                     = {}, -- fallback to treesitter

    -- lsp semantic modifier tokens
    ["@lsp.typemod.class.defaultLibrary"]      = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"]   = { link = "@function.builtin" },
    ["@lsp.typemod.keyword.async"]             = { link = "@keyword.coroutine" },
    ["@lsp.typemod.keyword.injected"]          = { link = "@keyword" },
    ["@lsp.typemod.macro.defaultLibrary"]      = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"]     = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"]         = { link = "@operator" },
    ["@lsp.typemod.string.injected"]           = { link = "@string" },
    ["@lsp.typemod.struct.defaultLibrary"]     = { link = "@type.builtin" },
    ["@lsp.typemod.type.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.typeAlias.defaultLibrary"]  = { link = "@type.builtin" },
    ["@lsp.typemod.variable.callable"]         = { link = "@function" },
    ["@lsp.typemod.variable.defaultLibrary"]   = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"]         = { link = "@variable" },
    ["@lsp.typemod.variable.static"]           = { link = "@constant" },

    -- treesitter highlighting
    ["@annotation"]                            = { fg = c.yellow2 },
    ["@attribute"]                             = { fg = c.yellow2 },
    ["@boolean"]                               = { link = "Boolean" },
    ["@character"]                             = { link = "Character" },
    ["@character.special"]                     = { link = "SpecialChar" },
    ["@class"]                                 = { fg = c.blue4 },
    ["@comment"]                               = { link = "Comment" },
    ["@comment.documentation"]                 = { link = "SpecialComment" },
    ["@comment.error"]                         = { link = "Error" },
    ["@comment.hint"]                          = { link = "DiagnosticHint" },
    ["@comment.info"]                          = { link = "DiagnosticInfo" },
    ["@comment.note"]                          = { link = "DiagnosticInfo" },
    ["@comment.todo"]                          = { link = "Todo" },
    ["@comment.warning"]                       = { link = "WarningMsg" },
    ["@conceal"]                               = { link = "Conceal" },
    ["@constant"]                              = { link = "Constant" },
    ["@constant.builtin"]                      = { bold = true },
    ["@constant.macro"]                        = { fg = c.cyan0, italic = true },
    ["@constructor"]                           = { fg = c.aqua1 },
    ["@definition.enum"]                       = { bold = true },
    ["@diff.delta"]                            = { link = "DiffChange" },
    ["@diff.minus"]                            = { link = "DiffDelete" },
    ["@diff.plus"]                             = { link = "DiffAdd" },
    ["@error"]                                 = { fg = c.red1 },
    ["@function"]                              = { link = "Function" },
    ["@function.builtin"]                      = { bold = true },
    ["@function.call"]                         = { link = "Function" },
    ["@function.macro"]                        = { fg = c.blue1 },
    ["@function.method"]                       = { link = "Function" },
    ["@function.method.call"]                  = { link = "Function" },
    ["@keyword"]                               = { link = "Keyword" },
    ["@keyword.coroutine"]                     = { link = "@keyword" },
    ["@keyword.conditional"]                   = { link = "Conditional" },
    ["@keyword.debug"]                         = { link = "Debug" },
    ["@keyword.directive"]                     = { link = "PreProc" },
    ["@keyword.directive.define"]              = { link = "Define" },
    ["@keyword.exception"]                     = { link = "Exception" },
    ["@keyword.function"]                      = { fg = c.magenta1 },
    ["@keyword.import"]                        = { link = "Include" },
    ["@keyword.operator"]                      = { fg = c.magenta1 },
    ["@keyword.repeat"]                        = { link = "Repeat" },
    ["@keyword.return"]                        = { fg = c.red2 },
    ["@keyword.storage"]                       = { link = "StorageClass" },
    ["@label"]                                 = { link = "Label" },
    ["@markup"]                                = { fg = c.fg1 },
    ["@markup.danger"]                         = { fg = c.bg2, bg = c.red1 },
    ["@markup.diff.add"]                       = { link = "DiffAdd" },
    ["@markup.diff.delete"]                    = { link = "DiffDelete" },
    ["@markup.emphasis"]                       = { fg = c.yellow2, italic = true },
    ["@markup.environment"]                    = { fg = c.blue4 },
    ["@markup.environment.name"]               = { fg = c.yellow2 },
    ["@markup.link"]                           = { fg = c.cyan1 },
    ["@markup.link.label"]                     = { link = "Special" },
    ["@markup.link.url"]                       = { fg = c.aqua1, underline = true },
    ["@markup.list"]                           = { fg = c.aqua0 },
    ["@markup.math"]                           = { fg = c.gray2, bg = c.bg0 },
    ["@markup.note"]                           = { fg = c.bg2, bg = c.aqua0 },
    ["@markup.raw"]                            = { fg = c.orange0 },
    ["@markup.strikethrough"]                  = { strikethrough = true },
    ["@markup.strong"]                         = { bold = true },
    ["@markup.todo"]                           = { link = "Todo" },
    ["@markup.underline"]                      = { link = "Underlined" },
    ["@markup.warning"]                        = { fg = c.bg2, bg = c.yellow2 },
    ["@module"]                                = { fg = c.blue1 },
    ["@module.builtin"]                        = { fg = c.blue1, bold = true },
    ["@namespace.builtin"]                     = { link = "@variable.builtin" },
    ["@none"]                                  = {},
    ["@number"]                                = { link = "Number" },
    ["@number.float"]                          = { link = "Float" },
    ["@operator"]                              = { link = "Operator" },
    ["@property"]                              = { fg = c.fg1 },
    ["@punctuation.bracket"]                   = { fg = c.aqua0 },
    ["@punctuation.delimiter"]                 = { fg = c.aqua0 },
    ["@string"]                                = { link = "String" },
    ["@string.documentation"]                  = { link = "SpecialComment" },
    ["@string.escape"]                         = { fg = c.purple0 },
    ["@string.regexp"]                         = { fg = c.rose1 },
    ["@string.special"]                        = { link = "SpecialChar" },
    ["@string.special.symbol"]                 = { fg = c.blue1 },
    ["@structure"]                             = { link = "Structure" },
    ["@tag"]                                   = { link = "tag" },
    ["@tag.attribute"]                         = { fg = c.orange0 },
    ["@tag.delimiter"]                         = { link = "Delimiter" },
    ["@type"]                                  = { link = "Type" },
    ["@type.builtin"]                          = { bold = true },
    ["@type.definition"]                       = { link = "TypeDef" },
    ["@type.qualifier"]                        = { link = "Type" },
    ["@variable"]                              = { fg = c.fg1 },
    ["@variable.builtin"]                      = { fg = c.fg2, bold = true },
    ["@variable.member"]                       = { fg = c.fg1 },
    ["@variable.parameter"]                    = { fg = c.rose0 },
    ["@variable.parameter.builtin"]            = { fg = c.rose0, bold = true },
    ["@variable.parameter.reference"]          = { fg = c.rose0 },

    -- custom treesitter extended highlighting
    ["@markup.codeblock"]                      = { bg = ds.color.blend(c.blue4, c.bg0, 0.08) },
    ["@markup.dash"]                           = { fg = c.yellow0, bold = true },
    ["@markup.heading"]                        = { link = "htmlH1" },
    ["@markup.table"]                        = { link = "Special" },
    ["@variable.member.yaml"]                  = { fg = c.aqua1 },

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

    WinbarFilename                             = { fg = ds.color.lighten(c.gray2, 5), bg = c.bg2, bold = true },
    WinbarContext                              = { fg = ds.color.lighten(c.gray1, 15), bg = c.bg2 },
  }
end

---Sets the active neovim theme based on the provided `colorscheme`
---@param t Colorscheme
---@param b? Background
M.load = function(t, b)
  b = b or "dark"
  if not M._initialized then
    M._initialized = true
    local root = "theme/palette"
    ds.walk(root, function(path, name, type)
      if (type == "file" or type == "link") and name:match "%.lua$" then
        local mod = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
        name = name:sub(1, -5)
        if mod:match "%." then name = mod:gsub("%.", "-") end
        M.themes[name] = require(root:gsub("/", ".") .. "." .. mod)
      end
    end)
  end
  if t and M.themes[t] then
    vim.o.background = "dark"
    vim.g.colors_name = t ---@type Colorscheme
    vim.g.ds_colors = M.themes[t] ---@type ColorPalette
    ds.hl.apply(vim.g.ds_colors, M.defaults)
  end
end

return M
