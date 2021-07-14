---------------------------------------------------------------
-- => Builitin Highlight Groups
---------------------------------------------------------------
-- initialize modules table
local M = {}

-- helper function to set highight group
local hi = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    local guifg, guibg, gui, guisp = args.guifg, args.guibg, args.gui, args.guisp
    local cmd = { "hi", hlgroup }
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

-- apply colors
M.apply = function(c)
  c.base10 = vim.fn["functions#darken"](c.base02, 40)
  c.base11 = vim.fn["functions#darken"](c.base03, 25)
  c.base12 = vim.fn["functions#lighten"](c.base04, 15)
  c.base13 = vim.fn["functions#lighten"](c.base08, 20)
  c.base14 = vim.fn["functions#darken"](c.base0C, 20)
  c.base15 = vim.fn["functions#lighten"](c.base0E, 30)
  c.base16 = vim.fn["functions#lighten"](c.base0F, 30)

  -- vim editor colors
  hi.Normal = { guifg = c.base05, guibg = c.base00, gui = nil, guisp = nil }
  hi.Bold = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.Debug = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Directory = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Error = { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil }
  hi.ErrorMsg = { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil }
  hi.Exception = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.FoldColumn = { guifg = c.base0C, guibg = c.base01, gui = nil, guisp = nil }
  hi.Folded = { guifg = c.base03, guibg = c.base01, gui = nil, guisp = nil }
  hi.IncSearch = { guifg = c.base01, guibg = c.base0A, gui = "none", guisp = nil }
  hi.Italic = { guifg = nil, guibg = nil, gui = "none", guisp = nil }
  hi.Macro = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.MatchParen = { guifg = c.base08, guibg = "", gui = "bold", guisp = nil }
  hi.ModeMsg = { guifg = c.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.MoreMsg = { guifg = c.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.Question = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Search = { guifg = c.base0E, guibg = c.base00, gui = "underline", guisp = nil }
  hi.Substitute = { guifg = c.base01, guibg = c.base0A, gui = "none", guisp = nil }
  hi.SpecialKey = { guifg = c.base03, guibg = nil, gui = nil, guisp = nil }
  hi.TooLong = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Underlined = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Visual = { guifg = c.base00, guibg = c.base0A, gui = nil, guisp = nil }
  hi.VisualNOS = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.WarningMsg = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.WildMenu = { guifg = c.base0F, guibg = c.base05, gui = nil, guisp = nil }
  hi.Title = { guifg = c.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.Conceal = { guifg = c.base0D, guibg = c.base00, gui = nil, guisp = nil }
  hi.Cursor = { guifg = c.base00, guibg = c.base05, gui = nil, guisp = nil }
  hi.NonText = { guifg = c.base11, guibg = nil, gui = nil, guisp = nil }
  hi.Whitespace = { guifg = c.base04, guibg = nil, gui = nil, guisp = nil }
  hi.LineNr = { guifg = c.base03, guibg = c.base00, gui = nil, guisp = nil }
  hi.SignColumn = { guifg = c.base03, guibg = c.base00, gui = nil, guisp = nil }
  hi.StatusLine = { guifg = c.base04, guibg = c.base02, gui = "none", guisp = nil }
  hi.StatusLineNC = { guifg = c.base03, guibg = c.base01, gui = "none", guisp = nil }
  hi.VertSplit = { guifg = c.base02, guibg = c.base02, gui = "none", guisp = nil }
  hi.ColorColumn = { guifg = nil, guibg = c.base01, gui = "none", guisp = nil }
  hi.CursorColumn = { guifg = nil, guibg = c.base01, gui = "none", guisp = nil }
  hi.CursorLine = { guifg = nil, guibg = c.base01, gui = "none", guisp = nil }
  hi.CursorLineNr = { guifg = c.base0C, guibg = c.base01, gui = nil, guisp = nil }
  hi.QuickFixLine = { guifg = c.base01, guibg = c.base0A, gui = "none", guisp = nil }
  hi.PMenu = { guifg = c.base05, guibg = c.base10, gui = "none", guisp = nil }
  hi.PMenuSel = { guifg = c.base01, guibg = c.base0F, gui = nil, guisp = nil }
  hi.TabLine = { guifg = c.base03, guibg = c.base00, gui = "none", guisp = nil }
  hi.TabLineFill = { guifg = c.base03, guibg = c.base00, gui = "none", guisp = nil }
  hi.TabLineSel = { guifg = c.base05, guibg = c.base00, gui = "none", guisp = nil }

  hi.NvimInternalError = { guifg = c.base08, guibg = c.base00, gui = "none", guisp = nil }

  hi.NormalFloat = { guifg = c.base05, guibg = c.base00, gui = nil, guisp = nil }
  hi.FloatBorder = { guifg = c.base05, guibg = c.base00, gui = nil, guisp = nil }
  hi.NormalNC = { guifg = c.base05, guibg = c.base00, gui = nil, guisp = nil }
  hi.TermCursor = { guifg = c.base00, guibg = c.base06, gui = "none", guisp = nil }
  hi.TermCursorNC = { guifg = c.base00, guibg = c.base06, gui = nil, guisp = nil }

  -- standard syntax highlighting
  hi.Boolean = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Character = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Comment = { guifg = c.base03, guibg = nil, gui = "italic", guisp = nil }
  hi.Conditional = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Constant = { guifg = c.base09, guibg = nil, gui = "bold", guisp = nil }
  hi.Define = { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.Delimiter = { guifg = c.base14, guibg = nil, gui = nil, guisp = nil }
  hi.Float = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Function = { guifg = c.base0C, guibg = nil, gui = nil, guisp = nil }
  hi.Identifier = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.Include = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Keyword = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Label = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Number = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Operator = { guifg = c.base05, guibg = nil, gui = "none", guisp = nil }
  hi.PreProc = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Repeat = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Special = { guifg = c.base0C, guibg = nil, gui = nil, guisp = nil }
  hi.SpecialChar = { guifg = c.base08, guibg = nil, gui = nil, guisp = nil }
  hi.Statement = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.StorageClass = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.String = { guifg = c.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.Structure = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Tag = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Todo = { guifg = c.base0A, guibg = c.base01, gui = nil, guisp = nil }
  hi.Type = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.Typedef = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }

  -- diff highlighting
  hi.DiffAdd = { guifg = c.base0B, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffChange = { guifg = c.base0A, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffDelete = { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffText = { guifg = c.base0D, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffAdded = { guifg = c.base0B, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffFile = { guifg = c.base0F, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffNewFile = { guifg = c.base0B, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffLine = { guifg = c.base0D, guibg = c.base00, gui = nil, guisp = nil }
  hi.DiffRemoved = { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil }

  -- git highlighting
  hi.gitcommitBlank = { guifg = c.base05, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitOverflow = { guifg = c.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSummary = { guifg = c.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitComment = { guifg = c.base03, guibg = nil, gui = "italic", guisp = nil }
  hi.gitcommitUntracked = { guifg = c.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscarded = { guifg = c.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelected = { guifg = c.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitHeader = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelectedType = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUnmergedType = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscardedType = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitBranch = { guifg = c.base0A, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitUntrackedFile = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUnmergedFile = { guifg = c.base0F, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitDiscardedFile = { guifg = c.base0F, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitSelectedFile = { guifg = c.base0B, guibg = nil, gui = "bold", guisp = nil }

  -- gitgutter highlighting
  hi.GitGutterAdd = { guifg = c.base0B, guibg = c.base00, gui = nil, guisp = nil }
  hi.GitGutterChange = { guifg = c.base0A, guibg = c.base00, gui = nil, guisp = nil }
  hi.GitGutterDelete = { guifg = c.base08, guibg = c.base00, gui = nil, guisp = nil }
  hi.GitGutterChangeDelete = { guifg = c.base09, guibg = c.base00, gui = nil, guisp = nil }

  -- spelling highlighting
  hi.SpellBad = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0F }
  hi.SpellLocal = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0C }
  hi.SpellCap = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0D }
  hi.SpellRare = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0E }

  -- lsp document highlighting
  hi.LspReferenceText = { guifg = c.base07, guibg = c.base0F, gui = nil, guisp = nil }
  hi.LspReferenceRead = { guifg = c.base07, guibg = c.base0F, gui = nil, guisp = nil }
  hi.LspReferenceWrite = { guifg = c.base07, guibg = c.base0F, gui = nil, guisp = nil }

  -- lsp diagnostic highlighting
  hi.LspDiagnosticsDefaultError = { guifg = c.base08, guibg = nil, gui = "none", guisp = nil }
  hi.LspDiagnosticsDefaultWarning = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.LspDiagnosticsDefaultInformation = { guifg = c.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.LspDiagnosticsDefaultHint = { guifg = c.base0E, guibj = nil, gui = "none", guisp = nil }
  hi.LspDiagnosticsUnderlineError = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base08 }
  hi.LspDiagnosticsUnderlineWarning = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0A }
  hi.LspDiagnosticsUnderlineInformation = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0C }
  hi.LspDiagnosticsUnderlineHint = { guifg = nil, guibg = nil, gui = "undercurl", guisp = c.base0E }
  hi.LspDiagnosticsStatusError = { guifg = c.base08, guibg = c.base02, gui = "none", guisp = nil }
  hi.LspDiagnosticsStatusWarning = { guifg = c.base0A, guibg = c.base02, gui = "none", guisp = nil }
  hi.LspDiagnosticsStatusInformation = { guifg = c.base0C, guibg = c.base02, gui = "none", guisp = nil }
  hi.LspDiagnosticsStatusHint = { guifg = c.base0E, guibg = c.base02, gui = "none", guisp = nil }

  -- treesitter highlighting
  hi.TSAnnotation = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSAttribute = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSBoolean = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSCharacter = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSComment = { guifg = c.base03, guibg = nil, gui = "italic", guisp = nil }
  hi.TSConstructor = { guifg = c.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.TSConditional = { guifg = c.base13, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstant = { guifg = c.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstBuiltin = { guifg = c.base09, guibg = nil, gui = "bold", guisp = nil }
  hi.TSConstMacro = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSError = { guifg = c.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSException = { guifg = c.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSField = { guifg = c.base12, guibg = nil, gui = "none", guisp = nil }
  hi.TSFloat = { guifg = c.base15, guibg = nil, gui = "none", guisp = nil }
  hi.TSFunction = { guifg = c.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSFuncBuiltin = { guifg = c.base0D, guibg = nil, gui = "bold", guisp = nil }
  hi.TSFuncMacro = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSInclude = { guifg = c.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeyword = { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordFunction = { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordOperator = { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSLabel = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSMethod = { guifg = c.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.TSNamespace = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSNone = { guifg = c.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSNumber = { guifg = c.base15, guibg = nil, gui = "none", guisp = nil }
  hi.TSOperator = { guifg = c.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameter = { guifg = c.base16, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameterReference = { guifg = c.base16, guibg = nil, gui = "none", guisp = nil }
  hi.TSProperty = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctDelimiter = { guifg = c.base14, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctBracket = { guifg = c.base14, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctSpecial = { guifg = c.base14, guibg = nil, gui = "none", guisp = nil }
  hi.TSRepeat = { guifg = c.base13, guibg = nil, gui = "none", guisp = nil }
  hi.TSString = { guifg = c.base0B, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringRegex = { guifg = c.base0B, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringEscape = { guifg = c.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSSymbol = { guifg = c.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSTag = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSTagDelimiter = { guifg = c.base14, guibg = nil, gui = "none", guisp = nil }
  hi.TSText = { guifg = c.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSStrong = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TSEmphasis = { guifg = c.base0A, guibg = nil, gui = "italic", guisp = nil }
  hi.TSUnderline = { guifg = c.base00, guibg = nil, gui = "underline", guisp = nil }
  hi.TSStrike = { guifg = c.base00, guibg = nil, gui = "strikethrough", guisp = nil }
  hi.TSTitle = { guifg = c.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSLiteral = { guifg = c.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSURI = { guifg = c.base0C, guibg = nil, gui = "underline", guisp = nil }
  hi.TSType = { guifg = c.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSTypeBuiltin = { guifg = c.base0A, guibg = nil, gui = "italic", guisp = nil }
  hi.TSVariable = { guifg = c.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSVariableBuiltin = { guifg = c.base0C, guibg = nil, gui = "bold", guisp = nil }
  hi.TSDefinition = { guifg = nil, guibg = nil, gui = "underline", guisp = c.base0E }
  hi.TSDefinitionUsage = { guifg = nil, guibg = nil, gui = "underline", guisp = c.base0A }
  hi.TSCurrentScope = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TreesitterContext = { guifg = nil, guibg = c.base01, gui = "italic", guisp = nil }

  c.stat00 = vim.fn["functions#lighten"](c.base05, 5)
  c.stat01 = vim.fn["functions#darken"](c.base06, 10)
  c.stat02 = vim.fn["functions#darken"](c.base06, 20)
  c.stat03 = vim.fn["functions#darken"](c.base06, 55)

  -- statusline highlighting
  hi.User1 = { guifg = c.stat01, guibg = c.base02, gui = "none", guisp = nil }
  hi.User2 = { guifg = c.stat00, guibg = c.base02, gui = "bold", guisp = nil }
  hi.User3 = { guifg = c.stat01, guibg = c.base02, gui = "italic", guisp = nil }
  hi.User4 = { guifg = c.base00, guibg = c.stat02, gui = "bold", guisp = nil }
  hi.User5 = { guifg = c.stat01, guibg = c.base02, gui = "italic", guisp = nil }
  hi.User6 = { guifg = c.base00, guibg = c.base0B, gui = "none", guisp = nil }
  hi.User7 = { guifg = c.base00, guibg = c.base0F, gui = "none", guisp = nil }
  hi.User8 = { guifg = c.base00, guibg = c.base0C, gui = "none", guisp = nil }
  hi.User9 = { guifg = c.base00, guibg = c.base08, gui = "none", guisp = nil }

  hi.Custom00 = { guifg = c.base08, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom0 = { guifg = c.stat02, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom1 = { guifg = c.base0B, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom2 = { guifg = c.base0F, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom3 = { guifg = c.base0C, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom4 = { guifg = c.base08, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom5 = { guifg = c.base0E, guibg = c.base02, gui = "none", guisp = nil }
  hi.Custom6 = { guifg = c.base09, guibg = c.base02, gui = "none", guisp = nil }

  c.sify00 = vim.fn["functions#darken"](c.base0A, 50)
  c.sify01 = vim.fn["functions#darken"](c.base0D, 35)

  -- vim-startify highlighting
  hi.StartifyBracket = { guifg = c.sify00, guibg = nil, gui = nil, guisp = nil }
  hi.StartifyFile = { guifg = c.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.StartifyFooter = { guifg = c.base04, guibg = nil, gui = nil, guisp = nil }
  hi.StartifyHeader = { guifg = c.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.StartifyNumber = { guifg = c.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.StartifyPath = { guifg = c.sify01, guibg = nil, gui = nil, guisp = nil }
  hi.StartifySection = { guifg = c.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.StartifySelect = { guifg = c.base0C, guibg = nil, gui = nil, guisp = nil }
  hi.StartifySlash = { guifg = c.sify01, guibg = nil, gui = nil, guisp = nil }
  hi.StartifySpecial = { guifg = c.base04, guibg = nil, gui = nil, guisp = nil }

  c.tele00 = vim.fn["functions#darken"](c.base0F, 43)

  -- telescope.nvim highlighting
  hi.TelescopeSelection = { guifg = nil, guibg = c.tele00, gui = "bold", guisp = nil }
  hi.TelescopeSelectionCaret = { guifg = c.base04, guibg = c.tele00, gui = "bold", guisp = nil }
  hi.TelescopeMultiSelection = { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TelescopeNormal = { guifg = c.base05, guibg = c.base00, gui = nil, guisp = nil }
  hi.TelescopeBorder = { guifg = c.base03, guibg = c.base00, gui = nil, guisp = nil }
  hi.TelescopePromptBorder = { guifg = c.base04, guibg = c.base00, gui = nil, guisp = nil }
  hi.TelescopeResultsBorder = { guifg = c.base04, guibg = c.base00, gui = nil, guisp = nil }
  hi.TelescopePreviewBorder = { guifg = c.base04, guibg = c.base00, gui = nil, guisp = nil }
  hi.TelescopeMatching = { guifg = c.base0C, guibg = nil, gui = nil, guisp = nil }
  hi.TelescopePromptPrefix = { guifg = c.base08, guibg = c.base00, gui = "none", guisp = nil }

  -- ensure termguicolors is set (likely redundant)
  vim.opt.termguicolors = true
  -- set gui colors
  vim.g.terminal_color_0 = c.base00
  vim.g.terminal_color_1 = c.base0F
  vim.g.terminal_color_2 = c.base0B
  vim.g.terminal_color_3 = c.base0A
  vim.g.terminal_color_4 = c.base0D
  vim.g.terminal_color_5 = c.base0E
  vim.g.terminal_color_6 = c.base0C
  vim.g.terminal_color_7 = c.base05
  vim.g.terminal_color_8 = c.base03
  vim.g.terminal_color_9 = c.base0F
  vim.g.terminal_color_10 = c.base0B
  vim.g.terminal_color_11 = c.base0A
  vim.g.terminal_color_12 = c.base0D
  vim.g.terminal_color_13 = c.base0E
  vim.g.terminal_color_14 = c.base0C
  vim.g.terminal_color_15 = c.base07
end

return M
