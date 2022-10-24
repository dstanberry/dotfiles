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
  hi.Debug = { fg = c.gray_lighter }
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
  hi.FloatBorder = { fg = c.bg_dark, bg = c.bg_dark }
  hi.NormalFloat = { fg = c.white, bg = c.bg_dark }
  hi.NvimInternalError = { link = "Error" }
  hi.PMenu = { link = "NormalFloat" }
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
  hi["@annotation"] = { fg = c.yellow }
  hi["@attribute"] = { fg = c.yellow }
  hi["@boolean"] = { link = "Boolean" }
  hi["@character"] = { fg = c.blue_dark }
  hi["@character.special"] = { link = "SpecialChar" }
  hi["@comment"] = { link = "Comment" }
  hi["@conceal"] = { link = "Conceal" }
  hi["@conditional"] = { fg = c.red_light }
  hi["@constant"] = { link = "Constant" }
  hi["@constant.builtin"] = { link = "Constant" }
  hi["@constant.macro"] = { fg = c.teal }
  hi["@constructor"] = { fg = c.blue_light }
  hi["@debug"] = { link = "Debug" }
  hi["@define"] = { link = "Define" }
  hi["@definition.enum"] = { bold = true }
  hi["@error"] = { fg = c.red }
  hi["@exception"] = { fg = c.red }
  hi["@field"] = { fg = c.fg_light }
  hi["@float"] = { link = "Float" }
  hi["@function"] = { link = "Function" }
  hi["@function.call"] = { link = "Function" }
  hi["@function.builtin"] = { fg = c.blue, bold = true }
  hi["@function.macro"] = { fg = c.blue_dark }
  hi["@include"] = { link = "Include" }
  hi["@keyword"] = { link = "Keyword" }
  hi["@keyword.function"] = { fg = c.magenta }
  hi["@keyword.operator"] = { fg = c.magenta }
  hi["@keyword.return"] = { fg = c.magenta_light }
  hi["@label"] = { link = "Label" }
  hi["@method"] = { fg = c.blue_light }
  hi["@method.call"] = { fg = c.blue_light }
  hi["@namespace"] = { fg = c.blue_dark }
  hi["@none"] = { fg = c.fg }
  hi["@number"] = { link = "Number" }
  hi["@operator"] = { link = "Operator" }
  hi["@parameter"] = { fg = c.rose }
  hi["@parameter.reference"] = { fg = c.rose }
  hi["@preproc"] = { link = "PreProc" }
  hi["@property"] = { fg = c.fg_light }
  hi["@punctuation.bracket"] = { fg = c.blue_alt }
  hi["@punctuation.delimiter"] = { fg = c.blue_alt }
  hi["@punctuation.special"] = { fg = c.blue_alt }
  hi["@repeat"] = { link = "Repeat" }
  hi["@spell"] = { link = "SpellBad" }
  hi["@storageclass"] = { link = "Type" }
  hi["@string"] = { link = "String" }
  hi["@string.escape"] = { fg = c.purple }
  hi["@string.regex"] = { link = "String" }
  hi["@string.special"] = { link = "Special" }
  hi["@symbol"] = { fg = c.blue_dark }
  hi["@tag"] = { link = "tag" }
  hi["@tag.attribute"] = { fg = c.orange }
  hi["@tag.delimiter"] = { link = "Delimiter" }
  hi["@text"] = { fg = c.fg }
  hi["@text.danger"] = { fg = c.bg, bg = c.red }
  hi["@text.diff.add"] = { bg = c.diff_add }
  hi["@text.diff.delete"] = { bg = c.diff_delete }
  hi["@text.emphasis"] = { fg = c.yellow, italic = true }
  hi["@text.environment"] = { fg = c.blue_dark }
  hi["@text.environment.name"] = { fg = c.yellow }
  hi["@text.literal"] = { fg = c.orange }
  hi["@text.math"] = { fg = c.gray_lighter, bg = c.bg_dark }
  hi["@text.note"] = { fg = c.bg, bg = c.blue_alt }
  hi["@text.reference"] = { fg = c.teal }
  hi["@text.strike"] = { fg = c.fg_dark, strikethrough = true }
  hi["@text.strong"] = { bold = true }
  hi["@text.title"] = { link = "Title" }
  hi["@text.underline"] = { link = "Underlined" }
  hi["@text.uri"] = { fg = c.blue_light, underline = true }
  hi["@text.warning"] = { fg = c.bg, bg = c.yellow }
  hi["@todo"] = { link = "Todo" }
  hi["@type"] = { link = "Type" }
  hi["@type.builtin"] = { fg = c.yellow, italic = true }
  hi["@type.qualifier"] = { link = "Type" }
  hi["@type.definition"] = { link = "TypeDef" }
  hi["@variable"] = { fg = c.fg }
  hi["@variable.builtin"] = { fg = c.red }

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
