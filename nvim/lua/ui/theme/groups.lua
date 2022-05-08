local M = {}

local hi = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    local clear, guifg, guibg, gui, guisp = args.clear, args.guifg, args.guibg, args.gui, args.guisp
    local cmd = { "hi", hlgroup }
    if clear then
      cmd = { "hi!", hlgroup }
    end
    if guifg then
      table.insert(cmd, "guifg=" .. guifg)
    end
    if guibg then
      table.insert(cmd, "guibg=" .. guibg)
    end
    if gui then
      table.insert(cmd, "gui=" .. gui)
    end
    if guisp then
      table.insert(cmd, "guisp=" .. guisp)
    end
    vim.cmd(table.concat(cmd, " "))
  end,
})

M.new = function(group, args)
  hi[group] = args
end

M.apply = function(c)
  -- vim editor colors
  hi.Normal = { guifg = c.fg, guibg = c.bg, gui = nil, guisp = nil }
  hi.Bold = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.Debug = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.Directory = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.Error = { guifg = c.red, guibg = c.bg, gui = nil, guisp = nil }
  hi.ErrorMsg = { guifg = c.red, guibg = c.bg, gui = nil, guisp = nil }
  hi.Exception = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.FoldColumn = { guifg = c.blue_light, guibg = c.bg_light, gui = nil, guisp = nil }
  hi.Folded = { guifg = c.gray_lighter, guibg = c.gray, gui = nil, guisp = nil }
  hi.Italic = { guifg = nil, guibg = nil, gui = "none", guisp = nil }
  hi.Macro = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.MatchParen = { guifg = c.red, guibg = "", gui = "bold", guisp = nil }
  hi.ModeMsg = { guifg = c.green, guibg = nil, gui = nil, guisp = nil }
  hi.MoreMsg = { guifg = c.green, guibg = nil, gui = nil, guisp = nil }
  hi.Question = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.Search = { guifg = c.magenta, guibg = c.bg, gui = "underline", guisp = nil }
  hi.Substitute = { guifg = c.bg_light, guibg = c.yellow, gui = "none", guisp = nil }
  hi.SpecialKey = { guifg = c.blue_lightest, guibg = nil, gui = nil, guisp = nil }
  hi.SpecialKeyWin = { guifg = c.gray_light, guibg = nil, gui = nil, guisp = nil }
  hi.TooLong = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.Underlined = { guifg = c.blue_dark, guibg = nil, gui = "underline", guisp = nil }
  hi.Visual = { guifg = c.bg, guibg = c.yellow, gui = nil, guisp = nil }
  hi.VisualNOS = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.WarningMsg = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.WildMenu = { guifg = c.blue_dark, guibg = c.fg, gui = nil, guisp = nil }
  hi.Title = { guifg = c.blue, guibg = nil, gui = "none", guisp = nil }
  hi.Conceal = { guifg = c.blue, guibg = c.bg, gui = nil, guisp = nil }
  hi.Cursor = { guifg = c.bg, guibg = c.fg, gui = nil, guisp = nil }
  hi.NonText = { guifg = c.gray_alt, guibg = nil, gui = nil, guisp = nil }
  hi.Whitespace = { guifg = c.gray_alt, guibg = nil, gui = nil, guisp = nil }
  hi.LineNr = { guifg = c.gray_light, guibg = nil, gui = nil, guisp = nil }
  hi.SignColumn = { guifg = c.gray_light, guibg = c.bg, gui = nil, guisp = nil }
  hi.StatusLine = { guifg = c.fg_dark, guibg = c.gray, gui = "none", guisp = nil }
  hi.StatusLineNC = { guifg = c.gray_light, guibg = c.gray, gui = "none", guisp = nil }
  hi.VertSplit = { clear = true, guifg = c.cyan, guibg = "none", gui = "none", guisp = nil }
  hi.ColorColumn = { guifg = nil, guibg = c.bg_light, gui = "none", guisp = nil }
  hi.CursorColumn = { guifg = nil, guibg = c.bg_light, gui = "none", guisp = nil }
  hi.CursorLine = { guifg = nil, guibg = c.bg_light, gui = "none", guisp = nil }
  hi.CursorLineNr = { guifg = c.blue_light, guibg = c.bg_light, gui = nil, guisp = nil }
  hi.QuickFixLine = { guifg = c.bg_light, guibg = c.yellow, gui = "none", guisp = nil }
  hi.PMenu = { guifg = c.fg, guibg = c.gray_darker, gui = "none", guisp = nil }
  hi.PMenuSel = { guifg = c.bg_light, guibg = c.blue_dark, gui = nil, guisp = nil }
  hi.TabLine = { guifg = c.gray_light, guibg = c.gray_darker, gui = "none", guisp = nil }
  hi.TabLineFill = { guifg = c.gray_light, guibg = c.bg_dark, gui = "none", guisp = nil }
  hi.TabLineSel = { guifg = c.fg, guibg = c.bg, gui = "bold", guisp = nil }

  hi.NvimInternalError = { guifg = c.red, guibg = c.bg, gui = "none", guisp = nil }

  -- hi.NormalFloat = { guifg = c.fg, guibg = c.bg_dark, gui = nil, guisp = nil }
  hi.NormalFloat = { guifg = c.fg, guibg = c.bg, gui = nil, guisp = nil }
  hi.FloatBorder = { guifg = c.cyan, guibg = c.bg, gui = nil, guisp = nil }

  hi.NormalNC = { guifg = c.fg, guibg = c.bg, gui = nil, guisp = nil }
  hi.TermCursor = { guifg = c.bg, guibg = c.fg_light, gui = "none", guisp = nil }
  hi.TermCursorNC = { guifg = c.bg, guibg = c.fg_light, gui = nil, guisp = nil }

  -- standard syntax highlighting
  hi.Boolean = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.Character = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.Comment = { guifg = c.gray_light, guibg = nil, gui = "italic", guisp = nil }
  hi.Conditional = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.Constant = { guifg = c.orange, guibg = nil, gui = "bold", guisp = nil }
  hi.Define = { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil }
  hi.Delimiter = { guifg = c.blue_alt, guibg = nil, gui = nil, guisp = nil }
  hi.Float = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.Function = { guifg = c.blue_light, guibg = nil, gui = nil, guisp = nil }
  hi.Identifier = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.Include = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.Keyword = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.Label = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.Number = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.Operator = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.PreProc = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.Repeat = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.Special = { guifg = c.blue_light, guibg = nil, gui = nil, guisp = nil }
  hi.SpecialChar = { guifg = c.red, guibg = nil, gui = nil, guisp = nil }
  hi.Statement = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.StorageClass = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.String = { guifg = c.green, guibg = nil, gui = nil, guisp = nil }
  hi.Structure = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.Tag = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.Todo = { guifg = c.yellow, guibg = c.bg_light, gui = nil, guisp = nil }
  hi.Type = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.Typedef = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }

  -- diff highlighting
  c.diff_add = "#132e1f"
  c.diff_delete = "#361f21"
  c.diff_change = "#174061"
  c.diff_text = "#1b3956"

  hi.DiffAdd = { guifg = "none", guibg = c.diff_add, gui = "none", guisp = nil }
  hi.DiffChange = { guifg = "none", guibg = c.diff_change, gui = "none", guisp = nil }
  hi.DiffDelete = { guifg = "none", guibg = c.diff_delete, gui = "none", guisp = nil }
  hi.DiffText = { guifg = "none", guibg = c.diff_text, gui = "none", guisp = nil }
  hi.DiffAdded = { guifg = c.green, guibg = c.bg, gui = nil, guisp = nil }
  hi.DiffFile = { guifg = c.blue_dark, guibg = c.bg, gui = nil, guisp = nil }
  hi.DiffNewFile = { guifg = c.green, guibg = c.bg, gui = nil, guisp = nil }
  hi.DiffLine = { guifg = c.blue, guibg = c.bg, gui = nil, guisp = nil }
  hi.DiffRemoved = { guifg = c.red, guibg = c.bg, gui = nil, guisp = nil }

  -- git highlighting
  hi.gitcommitBlank = { guifg = c.fg, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitOverflow = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSummary = { guifg = c.green, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitComment = { guifg = c.gray_light, guibg = nil, gui = "italic", guisp = nil }
  hi.gitcommitUntracked = { guifg = c.gray_light, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscarded = { guifg = c.gray_light, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelected = { guifg = c.gray_light, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitHeader = { guifg = c.magenta, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelectedType = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUnmergedType = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscardedType = { guifg = c.blue, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitBranch = { guifg = c.yellow, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitUntrackedFile = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUnmergedFile = { guifg = c.blue_dark, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitDiscardedFile = { guifg = c.blue_dark, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitSelectedFile = { guifg = c.green, guibg = nil, gui = "bold", guisp = nil }

  -- spelling highlighting
  hi.SpellBad = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.blue_dark }
  hi.SpellLocal = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.blue_light }
  hi.SpellCap = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.blue }
  hi.SpellRare = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.magenta }

  -- lsp codelens highlighting
  hi.LspCodeLens = { clear = true, guifg = c.gray_lsp, guibg = nil, gui = "none", guisp = nil }
  hi.LspCodeLensText = { clear = true, guifg = c.gray_lsp, guibg = nil, gui = "none", guisp = nil }
  hi.LspCodeLensSeparator = { clear = true, guifg = c.gray_lsp, guibg = nil, gui = "none", guisp = nil }

  -- lsp document highlighting
  hi.LspReferenceText = { guifg = c.gray_darker, guibg = c.gray_light, gui = nil, guisp = nil }
  hi.LspReferenceRead = { guifg = c.gray_darker, guibg = c.cyan_lsp, gui = nil, guisp = nil }
  hi.LspReferenceWrite = { guifg = c.gray_darker, guibg = c.orange, gui = nil, guisp = nil }

  -- lsp diagnostic highlighting
  hi.DiagnosticError = { guifg = c.red, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticWarn = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticInfo = { guifg = c.blue_light, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticHint = { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticStatusError = { guifg = c.red, guibg = c.gray, gui = "none", guisp = nil }
  hi.DiagnosticStatusWarn = { guifg = c.yellow, guibg = c.gray, gui = "none", guisp = nil }
  hi.DiagnosticStatusInfo = { guifg = c.blue_light, guibg = c.gray, gui = "none", guisp = nil }
  hi.DiagnosticStatusHint = { guifg = c.magenta, guibg = c.gray, gui = "none", guisp = nil }
  hi.DiagnosticUnderlineError = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.red }
  hi.DiagnosticUnderlineWarn = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.yellow }
  hi.DiagnosticUnderlineInfo = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.blue_light }
  hi.DiagnosticUnderlineHint = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.magenta }

  -- treesitter highlighting
  hi.TreesitterContext = { guifg = nil, guibg = c.bg_light, gui = "italic", guisp = nil }
  hi.TSAnnotation = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSAttribute = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSBoolean = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSCharacter = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSComment = { guifg = c.gray_light, guibg = nil, gui = "italic", guisp = nil }
  hi.TSConditional = { guifg = c.red_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstant = { guifg = c.orange, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstBuiltin = { guifg = c.orange, guibg = nil, gui = "bold", guisp = nil }
  hi.TSConstMacro = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstructor = { guifg = c.blue_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSCurrentScope = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TSDanger = { guifg = c.red, guibg = c.bg, gui = "bold", guisp = nil }
  hi.TSDefinition = { guifg = nil, guibg = nil, gui = "underline", guisp = c.magenta }
  hi.TSDefinitionUsage = { guifg = nil, guibg = c.gray, gui = "none", guisp = nil }
  hi.TSEmphasis = { guifg = c.yellow, guibg = nil, gui = "italic", guisp = nil }
  hi.TSEnvironment = { guifg = c.blue_dark, guibg = nil, gui = nil, guisp = nil }
  hi.TSEnvironmentType = { guifg = c.yellow, guibg = nil, gui = nil, guisp = nil }
  hi.TSError = { guifg = c.red, guibg = nil, gui = "none", guisp = nil }
  hi.TSException = { guifg = c.red, guibg = nil, gui = "none", guisp = nil }
  hi.TSField = { guifg = c.fg_alt, guibg = nil, gui = "none", guisp = nil }
  hi.TSFloat = { guifg = c.magenta_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSFuncBuiltin = { guifg = c.blue, guibg = nil, gui = "bold", guisp = nil }
  hi.TSFuncMacro = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSFunction = { guifg = c.blue, guibg = nil, gui = "none", guisp = nil }
  hi.TSInclude = { guifg = c.blue, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeyword = { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordFunction = { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordOperator = { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordReturn = { guifg = c.magenta_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSLabel = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSLiteral = { guifg = c.orange, guibg = nil, gui = "none", guisp = nil }
  hi.TSMath = { guifg = c.gray_lighter, guibg = c.bg_dark, gui = nil, guisp = nil }
  hi.TSMethod = { guifg = c.blue_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSNamespace = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSNone = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.TSNote = { guifg = c.yellow, guibg = c.bg, gui = "bold", guisp = nil }
  hi.TSNumber = { guifg = c.orange, guibg = nil, gui = "none", guisp = nil }
  hi.TSOperator = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameter = { guifg = c.yellow_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameterReference = { guifg = c.yellow_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSProperty = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctBracket = { guifg = c.blue_alt, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctDelimiter = { guifg = c.blue_alt, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctSpecial = { guifg = c.blue_alt, guibg = nil, gui = "none", guisp = nil }
  hi.TSQueryLinterError = { guifg = c.orange, guibg = c.bg, gui = nil, guisp = nil }
  hi.TSRepeat = { guifg = c.red_light, guibg = nil, gui = "none", guisp = nil }
  hi.TSStrike = { guifg = c.fg_dark, guibg = nil, gui = "strikethrough", guisp = nil }
  hi.TSString = { guifg = c.green, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringEscape = { guifg = c.red, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringRegex = { guifg = c.green, guibg = nil, gui = "none", guisp = nil }
  hi.TSStrong = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TSStructure = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.TSSymbol = { guifg = c.blue_dark, guibg = nil, gui = "none", guisp = nil }
  hi.TSTag = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSTagAttribute = { guifg = c.orange, guibg = nil, gui = "none", guisp = nil }
  hi.TSTagDelimiter = { guifg = c.blue_alt, guibg = nil, gui = "none", guisp = nil }
  hi.TSText = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.TSTextReference = { guifg = c.orange, guibg = nil, gui = "bold", guisp = nil }
  hi.TSTitle = { guifg = c.blue, guibg = nil, gui = "bold", guisp = nil }
  hi.TSType = { guifg = c.yellow, guibg = nil, gui = "none", guisp = nil }
  hi.TSTypeBuiltin = { guifg = c.yellow, guibg = nil, gui = "italic", guisp = nil }
  hi.TSUnderline = { guifg = c.bg, guibg = nil, gui = "underline", guisp = nil }
  hi.TSURI = { guifg = c.blue_light, guibg = nil, gui = "underline", guisp = nil }
  hi.TSVariable = { guifg = c.fg, guibg = nil, gui = "none", guisp = nil }
  hi.TSVariableBuiltin = { guifg = c.blue_light, guibg = nil, gui = "bold", guisp = nil }
  hi.TSWarning = { guifg = c.orange, guibg = c.bg, gui = "bold", guisp = nil }

  -- statusline highlighting
  hi.User1 = { guifg = c.white_dark, guibg = c.gray, gui = "none", guisp = nil }
  hi.User2 = { guifg = c.white, guibg = c.gray, gui = "bold", guisp = nil }
  hi.User3 = { guifg = c.white_dark, guibg = c.gray, gui = "italic", guisp = nil }
  hi.User4 = { guifg = c.bg, guibg = c.white_darker, gui = "bold", guisp = nil }
  hi.User5 = { guifg = c.white_dark, guibg = c.gray, gui = "italic", guisp = nil }
  hi.User6 = { guifg = c.bg, guibg = c.green, gui = "none", guisp = nil }
  hi.User7 = { guifg = c.bg, guibg = c.blue_dark, gui = "none", guisp = nil }
  hi.User8 = { guifg = c.bg, guibg = c.blue_light, gui = "none", guisp = nil }
  hi.User9 = { guifg = c.bg, guibg = c.red, gui = "none", guisp = nil }

  hi.Custom00 = { guifg = c.red, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom0 = { guifg = c.white_darker, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom1 = { guifg = c.green, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom2 = { guifg = c.blue_dark, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom3 = { guifg = c.blue_light, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom4 = { guifg = c.red, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom5 = { guifg = c.magenta, guibg = c.gray, gui = "none", guisp = nil }
  hi.Custom6 = { guifg = c.orange, guibg = c.gray, gui = "none", guisp = nil }

  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"

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
