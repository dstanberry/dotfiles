local color = require "util.color"

---@class HighlighAttrs
---@field fg string?
---@field bg string?
---@field bold boolean?
---@field italic boolean?
---@field undercurl boolean?
---@field underline boolean?
---@field underdotted boolean?
---@field underdashed boolean?
---@field underdouble boolean?
---@field strikethrough boolean?
---@field reverse boolean?
---@field nocombine boolean?
---@field link string?
---@field default boolean?

local M = {}

local hi = setmetatable({}, {
  ---@param name string
  ---@param args? HighlighAttrs
  __newindex = function(_, name, args) vim.api.nvim_set_hl(0, name, args) end,
})

---@param name string
---@param args? HighlighAttrs
M.new = function(name, args) hi[name] = args end

---@param c ColorPalette
M.apply = function(c)
  -- vim editor colors
  hi.ColorColumn = { bg = c.bg3 }
  hi.Conceal = { fg = c.fg_conceal }
  hi.CurSearch = { fg = c.black, bg = c.orange0 }
  hi.IncSearch = { fg = c.black, bg = c.orange0 }
  hi.Substitute = { fg = c.black, bg = c.red1 }
  hi.Search = { fg = c.orange0, underline = true }
  hi.Cursor = { fg = c.bg2, bg = c.fg1 }
  hi.CursorIM = { fg = c.bg2, bg = c.fg1 }
  hi.lCursor = { fg = c.bg2, bg = c.fg1 }
  hi.CursorColumn = { bg = c.bg3 }
  hi.CursorLine = { bg = c.bg3 }
  hi.CursorLineNr = { fg = c.aqua1 }
  hi.Debug = { fg = c.gray2 }
  hi.Directory = { fg = c.blue1 }
  hi.ErrorMsg = { fg = c.red1 }
  hi.FoldColumn = { link = "SignColumn" }
  hi.Folded = { fg = c.gray2, bg = c.gray0 }
  hi.LineNr = { fg = c.gray1 }
  hi.MatchParen = { fg = c.red1, bold = true }
  hi.ModeMsg = { fg = c.fg0, bold = true }
  hi.MoreMsg = { fg = c.blue3 }
  hi.MsgArea = { fg = c.fg0 }
  -- hi.MsgSeparator = { fg = c.fg0 }
  hi.NonText = { fg = c.grayX }
  hi.Normal = { fg = c.fg1, bg = c.bg2 }
  hi.NormalNC = { fg = c.fg1, bg = c.bg2 }
  hi.FloatBorder = { fg = c.bg0, bg = c.bg0 }
  hi.NormalFloat = { fg = c.white, bg = c.bg0 }
  hi.NvimInternalError = { link = "Error" }
  hi.PMenu = { link = "NormalFloat" }
  hi.PMenuSbar = { fg = c.gray0, bg = c.bg0 }
  hi.PMenuSel = { fg = c.bg3, bg = c.blue1 }
  hi.Question = { fg = c.blue3 }
  hi.QuickFixLine = { bg = c.bg_visual, bold = true }
  hi.qfLineNr = { fg = c.gray2 }
  hi.qfFileName = { fg = c.blue3 }
  hi.SignColumn = { fg = c.gray1 }
  hi.SpecialKey = { fg = c.aqua2 }
  hi.SpecialKeyWin = { fg = c.gray1 }
  hi.SpellBad = { sp = c.red0, undercurl = true }
  hi.SpellCap = { sp = c.yellow2, undercurl = true }
  hi.SpellLocal = { sp = c.aqua0, undercurl = true }
  hi.SpellRare = { sp = c.purple0, undercurl = true }
  -- hi.TermCursor = { fg = c.bg2, bg = c.fg2 }
  -- hi.TermCursorNC = { fg = c.bg2, bg = c.fg2 }
  hi.Title = { fg = c.blue0, bold = true }
  hi.VertSplit = { fg = c.bg3 }
  hi.WinSeparator = { link = "VertSplit" }
  hi.Visual = { bg = c.bg_visual }
  hi.VisualNOS = { fg = c.blue1 }
  hi.WarningMsg = { fg = c.yellow1 }
  hi.Whitespace = { link = "NonText" }
  hi.WildMenu = { link = "Visual" }
  -- alternate backgrounds
  hi.FloatBorderSB = { fg = c.gray1, bg = c.bg0 }
  hi.NormalSB = { fg = c.fg1, bg = c.bgX }

  -- standard syntax highlighting
  hi.Constant = { fg = c.orange0 }
  hi.Boolean = { fg = c.yellow2 }
  hi.Character = { fg = c.green2 }
  hi.String = { fg = c.green2 }
  hi.Number = { fg = c.orange1 }
  -- hi.Float = { fg = orange1 }

  hi.Identifier = { fg = c.magenta1 }
  hi.Function = { fg = c.blue2 }

  hi.Statement = { fg = c.magenta1 }
  hi.Keyword = { fg = c.magenta1 }
  hi.Operator = { fg = c.fg1 }
  -- hi.Conditional = {}
  -- hi.Exception = {}
  -- hi.Label = {}
  -- hi.Repeat = {}

  hi.PreProc = { fg = c.cyan1 }
  -- hi.Define = {}
  -- hi.Include = {}
  hi.Macro = { fg = c.cyan0 }
  -- hi.PreCondit = {}

  hi.Special = { fg = c.aqua1 }
  -- hi.Delimiter = {}
  hi.SpecialChar = { fg = c.rose1 }
  hi.SpecialComment = { fg = c.fg_comment, italic = true }
  -- hi.Tag = {}

  hi.Type = { fg = c.red2 }
  -- hi.StorageClass = {}
  hi.Structure = { fg = c.cyan2 }
  -- hi.Typedef = {}

  hi.Comment = { fg = c.gray1, italic = true }
  hi.Error = { fg = c.red1 }
  hi.Todo = { fg = c.yellow2 }

  hi.Underlined = { underline = true }
  hi.Bold = { bold = true }
  hi.Italic = { italic = true }

  hi.htmlH1 = { fg = c.blue3, bold = true }
  hi.htmlH2 = { fg = c.magenta1, bold = true }
  hi.htmlH3 = { fg = c.fg2, bold = true }

  -- diff highlighting
  hi.DiffAdd = { bg = c.diff_add }
  hi.DiffChange = { bg = c.diff_change }
  hi.DiffDelete = { bg = c.diff_delete }
  hi.DiffText = { bg = c.diff_text }
  hi.DiffAdded = { fg = c.green2 }
  hi.DiffFile = { fg = c.blue1 }
  hi.DiffNewFile = { fg = c.green2 }
  hi.DiffLine = { fg = c.blue2 }
  hi.DiffRemoved = { fg = c.red1 }

  -- git highlighting
  hi.gitcommitBlank = { fg = c.fg1 }
  hi.gitcommitOverflow = { fg = c.blue1 }
  hi.gitcommitSummary = { fg = c.green2 }
  hi.gitcommitComment = { fg = c.gray1, italic = true }
  hi.gitcommitUntracked = { fg = c.gray1 }
  hi.gitcommitDiscarded = { fg = c.gray1 }
  hi.gitcommitSelected = { fg = c.gray1 }
  hi.gitcommitHeader = { fg = c.magenta1 }
  hi.gitcommitSelectedType = { fg = c.blue2 }
  hi.gitcommitUnmergedType = { fg = c.blue2 }
  hi.gitcommitDiscardedType = { fg = c.blue2 }
  hi.gitcommitBranch = { fg = c.yellow2, bold = true }
  hi.gitcommitUntrackedFile = { fg = c.yellow2 }
  hi.gitcommitUnmergedFile = { fg = c.blue1, bold = true }
  hi.gitcommitDiscardedFile = { fg = c.blue1, bold = true }
  hi.gitcommitSelectedFile = { fg = c.green2, bold = true }

  -- lsp codelens highlighting
  hi.LspCodeLens = { fg = color.lighten(c.gray1, 20) }
  hi.LspCodeLensText = { fg = color.lighten(c.gray1, 20) }
  hi.LspCodeLensSeparator = { fg = color.lighten(c.gray1, 20) }

  -- lsp inlay hints
  hi.LspInlayHint = { link = "Comment" }

  -- lsp document highlighting
  hi.LspReferenceText = { underline = true, sp = c.gray1 }
  hi.LspReferenceRead = { underline = true, sp = c.gray1 }
  hi.LspReferenceWrite = { bold = true, italic = true, underline = true, sp = c.gray1 }

  -- lsp diagnostic highlighting
  hi.DiagnosticDeprecated = { sp = c.red3, italic = true, strikethrough = true }
  hi.DiagnosticUnnecessary = { fg = c.gray2, italic = true }

  hi.DiagnosticError = { fg = c.red1 }
  hi.DiagnosticWarn = { fg = c.yellow2 }
  hi.DiagnosticInfo = { fg = c.aqua1 }
  hi.DiagnosticHint = { fg = c.magenta1 }

  hi.DiagnosticStatusError = { fg = c.red1, bg = c.gray0 }
  hi.DiagnosticStatusWarn = { fg = c.yellow2, bg = c.gray0 }
  hi.DiagnosticStatusInfo = { fg = c.aqua1, bg = c.gray0 }
  hi.DiagnosticStatusHint = { fg = c.magenta1, bg = c.gray0 }

  hi.DiagnosticUnderlineError = { undercurl = true, sp = c.red1 }
  hi.DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow2 }
  hi.DiagnosticUnderlineInfo = { undercurl = true, sp = c.aqua1 }
  hi.DiagnosticUnderlineHint = { undercurl = true, sp = c.magenta1 }

  -- lsp semantic tokens
  hi["@lsp.type.boolean"] = { link = "@boolean" }
  hi["@lsp.type.builtinType"] = { link = "@type.builtin" }
  hi["@lsp.type.class"] = { link = "@class" }
  hi["@lsp.type.comment"] = { link = "@comment" }
  hi["@lsp.type.decorator"] = { link = "@constant.macro" }
  hi["@lsp.type.deriveHelper"] = { link = "@attribute" }
  hi["@lsp.type.enum"] = { link = "@constructor" }
  hi["@lsp.type.enumMember"] = { link = "@constant" }
  hi["@lsp.type.escapeSequence"] = { link = "@string.escape" }
  hi["@lsp.type.event"] = { link = "Identifier" }
  hi["@lsp.type.formatSpecifier"] = { link = "@markup.list" }
  hi["@lsp.type.function"] = { link = "@function" }
  hi["@lsp.type.generic"] = { link = "@variable" }
  hi["@lsp.type.interface"] = { fg = color.lighten(c.cyan1, 20) }
  hi["@lsp.type.lifetime"] = { link = "@keyword.storage" }
  hi["@lsp.type.method"] = { link = "@function.method" }
  hi["@lsp.type.modifier"] = { link = "Identifier" }
  hi["@lsp.type.namespace"] = { link = "@module" }
  hi["@lsp.type.number"] = { link = "@number" }
  hi["@lsp.type.operator"] = { link = "@operator" }
  hi["@lsp.type.parameter"] = { link = "@variable.parameter" }
  hi["@lsp.type.property"] = { link = "@property" }
  hi["@lsp.type.regexp"] = { link = "@string.regexp" }
  hi["@lsp.type.selfKeyword"] = { link = "@variable.builtin" }
  hi["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" }
  hi["@lsp.type.string"] = { link = "@string" }
  hi["@lsp.type.struct"] = { link = "@structure" }
  hi["@lsp.type.type"] = { link = "@type" }
  hi["@lsp.type.typeAlias"] = { link = "@type.definition" }
  hi["@lsp.type.typeParameter"] = { link = "@lsp.type.class" }
  hi["@lsp.type.unresolvedReference"] = { link = "DiagnosticUnderlineError" }
  hi["@lsp.type.variable"] = {} -- fallback to treesitter

  -- lsp semantic modifier tokens
  hi["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" }
  hi["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" }
  hi["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" }
  hi["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" }
  hi["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" }
  hi["@lsp.typemod.keyword.injected"] = { link = "@keyword" }
  hi["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" }
  hi["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" }
  hi["@lsp.typemod.operator.injected"] = { link = "@operator" }
  hi["@lsp.typemod.string.injected"] = { link = "@string" }
  hi["@lsp.typemod.struct.defaultLibrary"] = { link = "@type.builtin" }
  hi["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" }
  hi["@lsp.typemod.typeAlias.defaultLibrary"] = { link = "@type.builtin" }
  hi["@lsp.typemod.variable.callable"] = { link = "@function" }
  hi["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" }
  hi["@lsp.typemod.variable.injected"] = { link = "@variable" }
  hi["@lsp.typemod.variable.static"] = { link = "@constant" }

  -- treesitter highlighting
  hi["@annotation"] = { fg = c.yellow2 }
  hi["@attribute"] = { fg = c.yellow2 }
  hi["@boolean"] = { link = "Boolean" }
  hi["@character"] = { link = "Character" }
  hi["@character.special"] = { link = "SpecialChar" }
  hi["@class"] = { fg = c.cyan1 }
  hi["@comment"] = { link = "Comment" }
  hi["@comment.documentation"] = { link = "SpecialComment" }
  hi["@comment.error"] = { link = "Error" }
  hi["@comment.hint"] = { link = "DiagnosticHint" }
  hi["@comment.info"] = { link = "DiagnosticInfo" }
  hi["@comment.note"] = { link = "DiagnosticInfo" }
  hi["@comment.todo"] = { link = "Todo" }
  hi["@comment.warning"] = { link = "WarningMsg" }
  hi["@conceal"] = { link = "Conceal" }
  hi["@constant"] = { link = "Constant" }
  hi["@constant.builtin"] = { bold = true }
  hi["@constant.macro"] = { fg = c.cyan0, italic = true }
  hi["@constructor"] = { fg = c.aqua1 }
  hi["@definition.enum"] = { bold = true }
  hi["@diff.delta"] = { link = "DiffChange" }
  hi["@diff.minus"] = { link = "DiffDelete" }
  hi["@diff.plus"] = { link = "DiffAdd" }
  hi["@error"] = { fg = c.red1 }
  hi["@function"] = { link = "Function" }
  hi["@function.builtin"] = { bold = true }
  hi["@function.call"] = { link = "Function" }
  hi["@function.macro"] = { fg = c.blue1 }
  hi["@function.method"] = { link = "Function" }
  hi["@function.method.call"] = { link = "Function" }
  hi["@keyword"] = { link = "Keyword" }
  hi["@keyword.coroutine"] = { link = "@keyword" }
  hi["@keyword.conditional"] = { link = "Conditional" }
  hi["@keyword.debug"] = { link = "Debug" }
  hi["@keyword.directive"] = { link = "PreProc" }
  hi["@keyword.directive.define"] = { link = "Define" }
  hi["@keyword.exception"] = { link = "Exception" }
  hi["@keyword.function"] = { fg = c.magenta1 }
  hi["@keyword.import"] = { link = "Include" }
  hi["@keyword.operator"] = { fg = c.magenta1 }
  hi["@keyword.repeat"] = { link = "Repeat" }
  hi["@keyword.return"] = { fg = c.red2 }
  hi["@keyword.storage"] = { link = "StorageClass" }
  hi["@label"] = { link = "Label" }
  hi["@markup"] = { fg = c.fg1 }
  hi["@markup.danger"] = { fg = c.bg2, bg = c.red1 }
  hi["@markup.diff.add"] = { link = "DiffAdd" }
  hi["@markup.diff.delete"] = { link = "DiffDelete" }
  hi["@markup.emphasis"] = { fg = c.yellow2, italic = true }
  hi["@markup.environment"] = { fg = c.blue4 }
  hi["@markup.environment.name"] = { fg = c.yellow2 }
  hi["@markup.link"] = { fg = c.cyan1 }
  hi["@markup.link.label"] = { link = "Special" }
  hi["@markup.link.url"] = { fg = c.aqua1, underline = true }
  hi["@markup.list"] = { fg = c.aqua0 }
  hi["@markup.math"] = { fg = c.gray2, bg = c.bg0 }
  hi["@markup.note"] = { fg = c.bg2, bg = c.aqua0 }
  hi["@markup.raw"] = { fg = c.orange0 }
  hi["@markup.strikethrough"] = { strikethrough = true }
  hi["@markup.strong"] = { bold = true }
  hi["@markup.todo"] = { link = "Todo" }
  hi["@markup.underline"] = { link = "Underlined" }
  hi["@markup.warning"] = { fg = c.bg2, bg = c.yellow2 }
  hi["@module"] = { fg = c.blue1 }
  hi["@module.builtin"] = { fg = c.blue1, bold = true }
  hi["@none"] = {}
  hi["@number"] = { link = "Number" }
  hi["@number.float"] = { link = "Float" }
  hi["@operator"] = { link = "Operator" }
  hi["@property"] = { fg = c.fg1 }
  hi["@punctuation.bracket"] = { fg = c.aqua0 }
  hi["@punctuation.delimiter"] = { fg = c.aqua0 }
  hi["@string"] = { link = "String" }
  hi["@string.documentation"] = { link = "SpecialComment" }
  hi["@string.escape"] = { fg = c.purple0 }
  hi["@string.regexp"] = { fg = c.rose1 }
  hi["@string.special"] = { link = "SpecialChar" }
  hi["@string.special.symbol"] = { fg = c.blue1 }
  hi["@structure"] = { link = "Structure" }
  hi["@tag"] = { link = "tag" }
  hi["@tag.attribute"] = { fg = c.orange0 }
  hi["@tag.delimiter"] = { link = "Delimiter" }
  hi["@type"] = { link = "Type" }
  hi["@type.builtin"] = { bold = true }
  hi["@type.definition"] = { link = "TypeDef" }
  hi["@type.qualifier"] = { link = "Type" }
  hi["@variable"] = { fg = c.fg1 }
  hi["@variable.builtin"] = { fg = c.fg2, bold = true }
  hi["@variable.member"] = { fg = c.fg1 }
  hi["@variable.parameter"] = { fg = c.rose0 }
  hi["@variable.parameter.builtin"] = { fg = c.rose0, bold = true }
  hi["@variable.parameter.reference"] = { fg = c.rose0 }

  -- custom treesitter extended highlighting
  hi["@markup.codeblock"] = { bg = color.blend(c.grayX, c.bg2, 0.44) }
  hi["@markup.dash"] = { fg = c.yellow0, bold = true }
  hi["@markup.heading"] = { link = "htmlH1" }
  hi["@markup.heading"] = { link = "htmlH2" }
  hi["@variable.member.yaml"] = { fg = c.aqua1 }

  -- statusline highlighting
  hi.StatusLine = { fg = c.fg0, bg = c.gray0 }
  hi.StatusLineNC = { fg = c.gray1, bg = c.gray0 }

  -- tabline highlighting
  hi.TabLine = { fg = c.gray1, bg = c.bg2 }
  hi.TabLineFill = { fg = c.gray1, bg = c.bg2 }
  hi.TabLineSel = { fg = c.fg1, bg = c.bg0, bold = true }

  -- winbar highlighting
  hi.Winbar = { fg = color.lighten(c.gray1, 10), bg = c.bg2 }
  hi.WinbarNC = { bg = c.bg2 }

  hi.WinbarFilename = { fg = color.lighten(c.gray2, 5), bg = c.bg2, bold = true }
  hi.WinbarContext = { fg = color.lighten(c.gray1, 15), bg = c.bg2 }

  -- ensure termguicolors is set (likely redundant)
  vim.o.termguicolors = true
  -- set gui colors
  vim.g.terminal_color_0 = c.bg2
  vim.g.terminal_color_1 = c.red1
  vim.g.terminal_color_2 = c.green2
  vim.g.terminal_color_3 = c.yellow2
  vim.g.terminal_color_4 = c.blue2
  vim.g.terminal_color_5 = c.magenta1
  vim.g.terminal_color_6 = c.cyan2
  vim.g.terminal_color_7 = c.fg1
  vim.g.terminal_color_8 = c.gray1
  vim.g.terminal_color_9 = c.red1
  vim.g.terminal_color_10 = c.green2
  vim.g.terminal_color_11 = c.yellow2
  vim.g.terminal_color_12 = c.blue2
  vim.g.terminal_color_13 = c.magenta1
  vim.g.terminal_color_14 = c.cyan2
  vim.g.terminal_color_15 = c.fg2

  -- highlighting for special characters
  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"
end

return M
