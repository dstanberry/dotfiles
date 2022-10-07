local color = require "util.color"

local M = {}

local hi = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    vim.api.nvim_set_hl(0, hlgroup, args)
  end,
})

M.new = function(group, args)
  hi[group] = args
end

M.apply = function(c)
  -- vim editor colors
  hi.ColorColumn = { bg = c.bg_light }
  hi.Conceal = { fg = c.fg_conceal }
  hi.CurSearch = { bg = c.bg_search }
  hi.IncSearch = { fg = c.black, bg = c.orange }
  hi.Substitute = { fg = c.black, bg = c.red }
  hi.Search = { fg = c.orange, underline = true }
  hi.Cursor = { fg = c.bg, bg = c.fg }
  hi.CursorIM = { fg = c.bg, bg = c.fg }
  hi.lCursor = { fg = c.bg, bg = c.fg }
  hi.CursorColumn = { bg = c.bg_highlight }
  hi.CursorLine = { bg = c.bg_highlight }
  hi.CursorLineNr = { fg = c.blue_light }
  hi.Debug = { fg = c.blue_dark }
  hi.Directory = { fg = c.blue }
  hi.ErrorMsg = { fg = c.red }
  hi.FoldColumn = { fg = c.blue_light, bg = c.bg_light }
  hi.Folded = { fg = c.gray_lighter, bg = c.gray }
  hi.LineNr = { fg = c.gray_light }
  hi.Macro = { fg = c.blue_dark }
  hi.MatchParen = { fg = c.red, bold = true }
  hi.ModeMsg = { fg = c.fg_dark, bold = true }
  hi.MoreMsg = { fg = c.blue }
  hi.MsgArea = { fg = c.fg_dark }
  -- hi.MsgSeparator = { fg = c.fg_dark }
  hi.NonText = { fg = c.gray_alt }
  hi.Normal = { fg = c.fg, bg = c.bg }
  hi.NormalNC = { fg = c.fg, bg = c.bg }
  hi.NormalFloat = { fg = c.fg, bg = c.bg_float }
  hi.FloatBorder = { fg = c.fg_border }
  hi.NvimInternalError = { link = "Error" }
  hi.PMenu = { fg = c.fg, bg = c.gray_darker }
  hi.PMenuSel = { fg = c.bg_light, bg = c.blue_dark }
  hi.Question = { fg = c.blue }
  hi.QuickFixLine = { bg = c.bg_visual, bold = true }
  hi.qfLineNr = { fg = c.gray_lighter }
  hi.qfFileName = { fg = c.blue_dark }
  hi.SignColumn = { fg = c.gray_light }
  hi.SpecialKey = { fg = c.blue_lightest }
  hi.SpecialKeyWin = { fg = c.gray_light }
  hi.SpellBad = { sp = c.red_dark, undercurl = true }
  hi.SpellCap = { sp = c.yellow, undercurl = true }
  hi.SpellLocal = { sp = c.blue_alt, undercurl = true }
  hi.SpellRare = { sp = c.teal, undercurl = true }
  -- hi.TermCursor = { fg = c.bg, bg = c.fg_light }
  -- hi.TermCursorNC = { fg = c.bg, bg = c.fg_light }
  hi.Title = { fg = c.blue, bold = true }
  hi.VertSplit = { fg = c.bg_light }
  hi.WinSeparator = { link = "VertSplit" }
  hi.Visual = { bg = c.bg_visual }
  hi.VisualNOS = { fg = c.blue_dark }
  hi.WarningMsg = { fg = c.yellow_dark }
  hi.Whitespace = { link = "NonText" }
  hi.WildMenu = { link = "Visual" }
  -- alternate backgrounds
  hi.NormalSB = { fg = c.fg, bg = c.bg_alt }

  -- standard syntax highlighting
  hi.Constant = { fg = c.orange }
  hi.Boolean = { fg = c.yellow }
  hi.Character = { fg = c.green }
  hi.String = { fg = c.green }
  -- hi.Number = {}
  -- hi.Float = {}

  hi.Identifier = { fg = c.magenta }
  hi.Function = { fg = c.blue_light }

  hi.Statement = { fg = c.magenta }
  hi.Keyword = { fg = c.magenta }
  hi.Operator = { fg = c.fg }
  -- hi.Conditional = {}
  -- hi.Exception = {}
  -- hi.Label = {}
  -- hi.Repeat = {}

  hi.PreProc = { fg = c.teal }
  -- hi.Define = {}
  -- hi.Include = {}
  -- hi.Macro = {}
  -- hi.PreCondit = {}

  hi.Special = { fg = c.blue_light }
  -- hi.Delimiter = {}
  -- hi.SpecialChar = {}
  -- hi.SpecialComment = {}
  -- hi.Tag = {}

  hi.Type = { fg = c.blue_darker }
  -- hi.StorageClass = {}
  -- hi.Structure = {}
  -- hi.Typedef = {}

  hi.Comment = { fg = c.gray_light, italic = true }
  hi.Error = { fg = c.red }
  hi.Todo = { fg = c.yellow }

  hi.Underlined = { underline = true }
  hi.Bold = { bold = true }
  hi.Italic = { italic = true }

  hi.htmlH1 = { fg = c.magenta, bold = true }
  hi.htmlH2 = { fg = c.blue, bold = true }

  -- diff highlighting
  hi.DiffAdd = { bg = c.diff_add }
  hi.DiffChange = { bg = c.diff_change }
  hi.DiffDelete = { bg = c.diff_delete }
  hi.DiffText = { bg = c.diff_text }
  hi.DiffAdded = { fg = c.green }
  hi.DiffFile = { fg = c.blue_dark }
  hi.DiffNewFile = { fg = c.green }
  hi.DiffLine = { fg = c.blue }
  hi.DiffRemoved = { fg = c.red }

  -- git highlighting
  hi.gitcommitBlank = { fg = c.fg }
  hi.gitcommitOverflow = { fg = c.blue_dark }
  hi.gitcommitSummary = { fg = c.green }
  hi.gitcommitComment = { fg = c.gray_light, italic = true }
  hi.gitcommitUntracked = { fg = c.gray_light }
  hi.gitcommitDiscarded = { fg = c.gray_light }
  hi.gitcommitSelected = { fg = c.gray_light }
  hi.gitcommitHeader = { fg = c.magenta }
  hi.gitcommitSelectedType = { fg = c.blue }
  hi.gitcommitUnmergedType = { fg = c.blue }
  hi.gitcommitDiscardedType = { fg = c.blue }
  hi.gitcommitBranch = { fg = c.yellow, bold = true }
  hi.gitcommitUntrackedFile = { fg = c.yellow }
  hi.gitcommitUnmergedFile = { fg = c.blue_dark, bold = true }
  hi.gitcommitDiscardedFile = { fg = c.blue_dark, bold = true }
  hi.gitcommitSelectedFile = { fg = c.green, bold = true }

  -- lsp codelens highlighting
  hi.LspCodeLens = { fg = c.lsp_gray }
  hi.LspCodeLensText = { fg = c.lsp_gray }
  hi.LspCodeLensSeparator = { fg = c.lsp_gray }

  -- lsp document highlighting
  hi.LspReferenceText = { bg = c.lsp_text }
  hi.LspReferenceRead = { bg = c.lsp_read }
  hi.LspReferenceWrite = { bg = c.lsp_write }

  -- lsp diagnostic highlighting
  hi.DiagnosticError = { fg = c.red }
  hi.DiagnosticWarn = { fg = c.yellow }
  hi.DiagnosticInfo = { fg = c.blue_light }
  hi.DiagnosticHint = { fg = c.magenta }

  hi.DiagnosticStatusError = { fg = c.red, bg = c.gray }
  hi.DiagnosticStatusWarn = { fg = c.yellow, bg = c.gray }
  hi.DiagnosticStatusInfo = { fg = c.blue_light, bg = c.gray }
  hi.DiagnosticStatusHint = { fg = c.magenta, bg = c.gray }

  hi.DiagnosticUnderlineError = { undercurl = true, sp = c.red }
  hi.DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow }
  hi.DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue_light }
  hi.DiagnosticUnderlineHint = { undercurl = true, sp = c.magenta }

  -- lsp semantic tokens
  hi.LspParameter = { fg = c.rose }
  -- hi.LspClass = {}
  -- hi.LspComment = {}
  -- hi.LspDecorator = {}
  -- hi.LspEnum = {}
  -- hi.LspEnumMember = {}
  -- hi.LspEvent = {}
  -- hi.LspFunction = {}
  -- hi.LspInterface = {}
  -- hi.LspKeyword = {}
  -- hi.LspMacro = {}
  -- hi.LspMethod = {}
  -- hi.LspModifier = {}
  -- hi.LspNamespace = {}
  -- hi.LspNumber = {}
  -- hi.LspOperator = {}
  -- hi.LspProperty = {}
  -- hi.LspRegexp = {}
  -- hi.LspString = {}
  -- hi.LspStruct = {}
  -- hi.LspType = {}
  -- hi.LspTypeParameter = {}
  -- hi.LspVariable = {}

  -- lsp semantic modifier tokens
  hi.LspDeprecated = { fg = c.red_dark, italic = true, strikethrough = true }
  hi.LspAbstract = { fg = c.pink }
  -- hi.LspAsync = {}
  -- hi.LspDeclaration = {}
  -- hi.LspDefaultLibrary = {}
  -- hi.LspDefinition = {}
  -- hi.LspDocumentation = {}
  -- hi.LspModification = {}
  -- hi.LspReadonly = {}
  -- hi.LspStatic = {}

  -- treesitter highlighting
  hi.TreesitterContext = { bg = c.bg_light, italic = true }

  hi.TSAnnotation = { fg = c.yellow }
  hi.TSAttribute = { fg = c.yellow }
  hi.TSBoolean = { link = "Boolean" }
  hi.TSCharacter = { fg = c.blue_dark }
  hi.TSComment = { link = "Comment" }
  hi.TSConditional = { fg = c.red_light }
  hi.TSConstant = { link = "Constant" }
  hi.TSConstBuiltin = { link = "Constant" }
  hi.TSConstMacro = { fg = c.teal }
  hi.TSConstructor = { fg = c.blue_light }
  hi.TSCurrentScope = { bold = true }
  hi.TSDanger = { fg = c.bg, bg = c.red }
  hi.TSDefinition = { underline = true, sp = c.magenta }
  hi.TSDefinitionUsage = { bg = c.gray }
  hi.TSEmphasis = { fg = c.yellow, italic = true }
  hi.TSEnum = { bold = true }
  hi.TSEnvironment = { fg = c.blue_dark }
  hi.TSEnvironmentType = { fg = c.yellow }
  hi.TSError = { fg = c.red }
  hi.TSException = { fg = c.red }
  hi.TSField = { fg = c.fg_light }
  hi.TSFloat = { link = "Float" }
  hi.TSFuncBuiltin = { fg = c.blue, bold = true }
  hi.TSFuncMacro = { fg = c.blue_dark }
  hi.TSFunction = { link = "Function" }
  hi.TSInclude = { link = "Include" }
  hi.TSKeyword = { link = "Keyword" }
  hi.TSKeywordFunction = { fg = c.magenta }
  hi.TSKeywordOperator = { fg = c.magenta }
  hi.TSKeywordReturn = { fg = c.magenta_light }
  hi.TSLabel = { link = "Label" }
  hi.TSLiteral = { fg = c.orange }
  hi.TSMath = { fg = c.gray_lighter, bg = c.bg_dark }
  hi.TSMethod = { fg = c.blue_light }
  hi.TSNamespace = { fg = c.blue_dark }
  hi.TSNone = { fg = c.fg }
  hi.TSNote = { fg = c.bg, bg = c.blue_alt }
  hi.TSNumber = { link = "Number" }
  hi.TSOperator = { link = "Operator" }
  hi.TSParameter = { fg = c.yellow_darker }
  hi.TSParameterReference = { fg = c.yellow_darker }
  hi.TSProperty = { fg = c.fg_light }
  hi.TSPunctBracket = { fg = c.blue_alt }
  hi.TSPunctDelimiter = { fg = c.blue_alt }
  hi.TSPunctSpecial = { fg = c.blue_alt }
  hi.TSQueryLinterError = { fg = c.orange }
  hi.TSRepeat = { link = "Repeat" }
  hi.TSStrike = { fg = c.fg_dark, strikethrough = true }
  hi.TSString = { link = "String" }
  hi.TSStringEscape = { fg = c.purple }
  hi.TSStringRegex = { link = "String" }
  hi.TSStrong = { bold = true }
  hi.TSStructure = { fg = c.fg }
  hi.TSSymbol = { fg = c.blue_dark }
  hi.TSTag = { link = "Tag" }
  hi.TSTagAttribute = { fg = c.orange }
  hi.TSTagDelimiter = { link = "Tag" }
  hi.TSText = { fg = c.fg }
  hi.TSTextReference = { fg = c.teal }
  hi.TSTitle = { link = "Title" }
  hi.TSTodo = { link = "Todo" }
  hi.TSType = { link = "Type" }
  hi.TSTypeBuiltin = { fg = c.yellow, italic = true }
  hi.TSUnderline = { link = "Underlined" }
  hi.TSURI = { fg = c.blue_light, underline = true }
  hi.TSVariable = { fg = c.fg }
  hi.TSVariableBuiltin = { fg = c.red }
  hi.TSWarning = { fg = c.bg, bg = c.yellow }

  -- statusline highlighting
  hi.StatusLine = { fg = c.fg_dark, bg = c.gray }
  hi.StatusLineNC = { fg = c.gray_light, bg = c.gray }

  hi.User1 = { fg = c.green, bg = c.gray }
  hi.User2 = { fg = c.blue_dark, bg = c.gray }
  hi.User3 = { fg = c.blue_light, bg = c.gray }
  hi.User4 = { fg = c.red, bg = c.gray }
  hi.User5 = { fg = c.magenta, bg = c.gray }
  hi.User6 = { fg = c.orange, bg = c.gray }
  hi.User7 = { fg = c.white, bg = c.gray }
  hi.User8 = { fg = c.fg, bg = c.gray, bold = true }
  hi.User9 = { fg = c.gray_dark, bg = c.gray }

  -- tabline highlighting
  hi.TabLine = { fg = c.gray_light, bg = c.bg }
  hi.TabLineFill = { fg = c.gray_light, bg = c.bg }
  hi.TabLineSel = { fg = c.fg, bg = c.bg_dark, bold = true }

  -- winbar highlighting
  hi.Winbar = { fg = c.gray_light, bg = c.bg }
  hi.WinbarIcon = { fg = c.blue_dark, bg = c.bg }
  hi.WinbarNC = { bg = c.bg }

  -- ensure termguicolors is set (likely redundant)
  vim.opt.termguicolors = true
  -- set gui colors
  vim.g.terminal_color_0 = c.bg
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.magenta
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.gray_light
  vim.g.terminal_color_9 = c.red
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.yellow
  vim.g.terminal_color_12 = c.blue
  vim.g.terminal_color_13 = c.magenta
  vim.g.terminal_color_14 = c.blue_light
  vim.g.terminal_color_15 = c.cyan

  -- highlighting for special characters
  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"
end

return M
