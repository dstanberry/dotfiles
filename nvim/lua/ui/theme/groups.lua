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
  hi.Normal = { fg = c.fg, bg = c.bg }
  hi.Bold = { bold = true }
  hi.Debug = { fg = c.blue_dark }
  hi.Directory = { fg = c.blue }
  hi.Error = { fg = c.red, bg = c.bg }
  hi.ErrorMsg = { fg = c.red, bg = c.bg }
  hi.Exception = { fg = c.blue_dark }
  hi.FoldColumn = { fg = c.blue_light, bg = c.bg_light }
  hi.Folded = { fg = c.gray_lighter, bg = c.gray }
  hi.Macro = { fg = c.blue_dark }
  hi.MatchParen = { fg = c.red, bold = true }
  hi.ModeMsg = { fg = c.green }
  hi.MoreMsg = { fg = c.green }
  hi.Question = { fg = c.blue }
  hi.Search = { fg = c.magenta, bg = c.bg, underline = true }
  hi.CurSearch = { fg = c.bg_light, bg = c.yellow }
  hi.IncSearch = { fg = c.bg_light, bg = c.yellow }
  hi.Substitute = { fg = c.bg_light, bg = c.yellow }
  hi.SpecialKey = { fg = c.blue_lightest }
  hi.SpecialKeyWin = { fg = c.gray_light }
  hi.TooLong = { fg = c.blue_dark }
  hi.Underlined = { fg = c.blue_dark, underline = true }
  hi.Visual = { fg = c.bg, bg = c.yellow }
  hi.VisualNOS = { fg = c.blue_dark }
  hi.WarningMsg = { fg = c.blue_dark }
  hi.WildMenu = { fg = c.blue_dark, bg = c.fg }
  hi.Title = { fg = c.blue }
  hi.Conceal = { fg = c.blue, bg = c.bg }
  hi.Cursor = { fg = c.bg, bg = c.fg }
  hi.NonText = { fg = c.gray_alt }
  hi.Whitespace = { fg = c.gray_alt }
  hi.LineNr = { fg = c.gray_light }
  hi.SignColumn = { fg = c.gray_light, bg = c.bg }
  hi.StatusLine = { fg = c.fg_dark, bg = c.gray }
  hi.StatusLineNC = { fg = c.gray_light, bg = c.gray }
  hi.VertSplit = { fg = c.gray }
  hi.ColorColumn = { bg = c.bg_light }
  hi.CursorColumn = { bg = c.bg_light }
  hi.CursorLine = { bg = c.bg_light }
  hi.CursorLineNr = { fg = c.blue_light, bg = c.bg_light }
  hi.QuickFixLine = { fg = c.bg_light, bg = c.yellow }
  hi.PMenu = { fg = c.fg, bg = c.gray_darker }
  hi.PMenuSel = { fg = c.bg_light, bg = c.blue_dark }
  hi.TabLine = { fg = c.gray_light, bg = c.bg }
  hi.TabLineFill = { fg = c.gray_light, bg = c.bg }
  hi.TabLineSel = { fg = c.fg, bg = c.bg_dark, bold = true }

  hi.NvimInternalError = { fg = c.red, bg = c.bg }

  hi.NormalFloat = { fg = c.fg, bg = c.bg_dark }
  hi.FloatBorder = { fg = c.cyan, bg = c.bg }

  hi.NormalNC = { fg = c.fg, bg = c.bg }
  hi.TermCursor = { fg = c.bg, bg = c.fg_light }
  hi.TermCursorNC = { fg = c.bg, bg = c.fg_light }

  -- standard syntax highlighting
  hi.Boolean = { fg = c.yellow }
  hi.Character = { fg = c.blue_dark }
  hi.Comment = { fg = c.gray_light, italic = true }
  hi.Conditional = { fg = c.magenta }
  hi.Constant = { fg = c.orange, bold = true }
  hi.Define = { fg = c.magenta }
  hi.Delimiter = { fg = c.blue_alt }
  hi.Float = { fg = c.magenta }
  hi.Function = { fg = c.blue_light }
  hi.Identifier = { fg = c.blue_dark }
  hi.Include = { fg = c.blue }
  hi.Keyword = { fg = c.magenta }
  hi.Label = { fg = c.yellow }
  hi.Number = { fg = c.magenta }
  hi.Operator = { fg = c.fg }
  hi.PreProc = { fg = c.yellow }
  hi.Repeat = { fg = c.yellow }
  hi.Special = { fg = c.blue_light }
  hi.SpecialChar = { fg = c.red }
  hi.Statement = { fg = c.blue_dark }
  hi.StorageClass = { fg = c.yellow }
  hi.String = { fg = c.green }
  hi.Structure = { fg = c.magenta }
  hi.Tag = { fg = c.yellow }
  hi.Todo = { fg = c.yellow, bg = c.bg_light }
  hi.Type = { fg = c.yellow }
  hi.Typedef = { fg = c.yellow }

  -- diff highlighting
  c.diff_add = "#132e1f"
  c.diff_delete = "#361f21"
  c.diff_change = "#174061"
  c.diff_text = "#1b3956"

  hi.DiffAdd = { bg = c.diff_add }
  hi.DiffChange = { bg = c.diff_change }
  hi.DiffDelete = { bg = c.diff_delete }
  hi.DiffText = { bg = c.diff_text }
  hi.DiffAdded = { fg = c.green, bg = c.bg }
  hi.DiffFile = { fg = c.blue_dark, bg = c.bg }
  hi.DiffNewFile = { fg = c.green, bg = c.bg }
  hi.DiffLine = { fg = c.blue, bg = c.bg }
  hi.DiffRemoved = { fg = c.red, bg = c.bg }

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

  -- spelling highlighting
  hi.SpellBad = { undercurl = true, sp = c.blue_dark }
  hi.SpellLocal = { undercurl = true, sp = c.blue_light }
  hi.SpellCap = { undercurl = true, sp = c.blue }
  hi.SpellRare = { undercurl = true, sp = c.magenta }

  -- lsp codelens highlighting
  hi.LspCodeLens = { fg = c.gray_lsp }
  hi.LspCodeLensText = { fg = c.gray_lsp }
  hi.LspCodeLensSeparator = { fg = c.gray_lsp }

  -- lsp document highlighting
  hi.LspReferenceText = { fg = c.gray_darker, bg = c.yellow_dark }
  hi.LspReferenceRead = { fg = c.gray_darker, bg = c.cyan_lsp }
  hi.LspReferenceWrite = { fg = c.gray_darker, bg = c.orange }

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

  -- treesitter highlighting
  hi.TreesitterContext = { bg = c.bg_light, italic = true }
  hi.TSAnnotation = { fg = c.yellow }
  hi.TSAttribute = { fg = c.yellow }
  hi.TSBoolean = { fg = c.yellow }
  hi.TSCharacter = { fg = c.blue_dark }
  hi.TSComment = { fg = c.gray_light, italic = true }
  hi.TSConditional = { fg = c.red_light }
  hi.TSConstant = { fg = c.orange }
  hi.TSConstBuiltin = { fg = c.orange, bold = true }
  hi.TSConstMacro = { fg = c.blue_dark }
  hi.TSConstructor = { fg = c.blue_light }
  hi.TSCurrentScope = { bold = true }
  hi.TSDanger = { fg = c.red, bg = c.bg, bold = true }
  hi.TSDefinition = { underline = true, sp = c.magenta }
  hi.TSDefinitionUsage = { bg = c.gray }
  hi.TSEmphasis = { fg = c.yellow, italic = true }
  hi.TSEnvironment = { fg = c.blue_dark }
  hi.TSEnvironmentType = { fg = c.yellow }
  hi.TSError = { fg = c.red }
  hi.TSException = { fg = c.red }
  hi.TSField = { fg = c.fg_alt }
  hi.TSFloat = { fg = c.magenta_light }
  hi.TSFuncBuiltin = { fg = c.blue, bold = true }
  hi.TSFuncMacro = { fg = c.blue_dark }
  hi.TSFunction = { fg = c.blue }
  hi.TSInclude = { fg = c.blue }
  hi.TSKeyword = { fg = c.magenta }
  hi.TSKeywordFunction = { fg = c.magenta }
  hi.TSKeywordOperator = { fg = c.magenta }
  hi.TSKeywordReturn = { fg = c.magenta_light }
  hi.TSLabel = { fg = c.yellow }
  hi.TSLiteral = { fg = c.orange }
  hi.TSMath = { fg = c.gray_lighter, bg = c.bg_dark }
  hi.TSMethod = { fg = c.blue_light }
  hi.TSNamespace = { fg = c.blue_dark }
  hi.TSNone = { fg = c.fg }
  hi.TSNote = { fg = c.yellow, bg = c.bg, bold = true }
  hi.TSNumber = { fg = c.orange }
  hi.TSOperator = { fg = c.fg }
  hi.TSParameter = { fg = c.yellow_dark }
  hi.TSParameterReference = { fg = c.yellow_dark }
  hi.TSProperty = { fg = c.blue_dark }
  hi.TSPunctBracket = { fg = c.blue_alt }
  hi.TSPunctDelimiter = { fg = c.blue_alt }
  hi.TSPunctSpecial = { fg = c.blue_alt }
  hi.TSQueryLinterError = { fg = c.orange, bg = c.bg }
  hi.TSRepeat = { fg = c.red_light }
  hi.TSStrike = { fg = c.fg_dark, strikethrough = true }
  hi.TSString = { fg = c.green }
  hi.TSStringEscape = { fg = c.red }
  hi.TSStringRegex = { fg = c.green }
  hi.TSStrong = { bold = true }
  hi.TSStructure = { fg = c.fg }
  hi.TSSymbol = { fg = c.blue_dark }
  hi.TSTag = { fg = c.yellow }
  hi.TSTagAttribute = { fg = c.orange }
  hi.TSTagDelimiter = { fg = c.blue_alt }
  hi.TSText = { fg = c.fg }
  hi.TSTextReference = { fg = c.orange, bold = true }
  hi.TSTitle = { fg = c.blue, bold = true }
  hi.TSType = { fg = c.yellow }
  hi.TSTypeBuiltin = { fg = c.yellow, italic = true }
  hi.TSUnderline = { fg = c.bg, underline = true }
  hi.TSURI = { fg = c.blue_light, underline = true }
  hi.TSVariable = { fg = c.fg }
  hi.TSVariableBuiltin = { fg = c.blue_light, bold = true }
  hi.TSWarning = { fg = c.orange, bg = c.bg, bold = true }

  -- statusline highlighting
  hi.User1 = { fg = c.white_dark, bg = c.gray }
  hi.User2 = { fg = c.white, bg = c.gray, bold = true }
  hi.User3 = { fg = c.white_dark, bg = c.gray, italic = true }
  hi.User4 = { fg = c.bg, bg = c.white_darker, bold = true }
  hi.User5 = { fg = c.white_dark, bg = c.gray, italic = true }
  hi.User6 = { fg = c.bg, bg = c.green }
  hi.User7 = { fg = c.bg, bg = c.blue_dark }
  hi.User8 = { fg = c.bg, bg = c.blue_light }
  hi.User9 = { fg = c.bg, bg = c.red }

  hi.Custom00 = { fg = c.red, bg = c.gray }
  hi.Custom0 = { fg = c.white_darker, bg = c.gray }
  hi.Custom1 = { fg = c.green, bg = c.gray }
  hi.Custom2 = { fg = c.blue_dark, bg = c.gray }
  hi.Custom3 = { fg = c.blue_light, bg = c.gray }
  hi.Custom4 = { fg = c.red, bg = c.gray }
  hi.Custom5 = { fg = c.magenta, bg = c.gray }
  hi.Custom6 = { fg = c.orange, bg = c.gray }

  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"

  -- winbar highlighting
  hi.Winbar = { fg = c.gray_light, bg = c.bg }
  hi.WinbarIcon = { fg = c.blue_dark, bg = c.bg }
  hi.WinbarNC = { bg = c.bg }

  -- ensure termguicolors is set (likely redundant)
  vim.opt.termguicolors = true
  -- set gui colors
  vim.g.terminal_color_0 = c.bg
  vim.g.terminal_color_1 = c.blue_dark
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.magenta
  vim.g.terminal_color_6 = c.blue_light
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.gray_light
  vim.g.terminal_color_9 = c.blue_dark
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.yellow
  vim.g.terminal_color_12 = c.blue
  vim.g.terminal_color_13 = c.magenta
  vim.g.terminal_color_14 = c.blue_light
  vim.g.terminal_color_15 = c.cyan
end

return M
