local M = {}

local hi = setmetatable({}, {
  __newindex = function(_, hlgroup, args) vim.api.nvim_set_hl(0, hlgroup, args) end,
})

M.new = function(group, args) hi[group] = args end

M.apply = function(c)
  -- vim editor colors
  hi.ColorColumn = { bg = c.bg3 }
  hi.Conceal = { fg = c.fg_conceal }
  hi.CurSearch = { fg = c.black, bg = c.orange0 }
  hi.IncSearch = { fg = c.black, bg = c.bg_search }
  hi.Substitute = { fg = c.black, bg = c.red1 }
  hi.Search = { fg = c.orange0, underline = true }
  hi.Cursor = { fg = c.bg2, bg = c.fg1 }
  hi.CursorIM = { fg = c.bg2, bg = c.fg1 }
  hi.lCursor = { fg = c.bg2, bg = c.fg1 }
  hi.CursorColumn = { bg = c.bg3 }
  hi.CursorLine = { bg = c.bg3 }
  hi.CursorLineNr = { fg = c.aqua1 }
  hi.Debug = { fg = c.gray2 }
  hi.Directory = { fg = c.blue0 }
  hi.ErrorMsg = { fg = c.red1 }
  hi.FoldColumn = { fg = c.aqua1, bg = c.bg3 }
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
  hi.SpecialComment = { fg = c.green0, italic = true }
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

  hi.htmlH1 = { fg = c.blue2, bold = true }
  hi.htmlH2 = { fg = c.magenta1, bold = true }

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
  hi.LspCodeLens = { fg = c.lsp_fg }
  hi.LspCodeLensText = { fg = c.lsp_fg }
  hi.LspCodeLensSeparator = { fg = c.lsp_fg }

  -- lsp document highlighting
  hi.LspReferenceText = { bg = c.lsp_text }
  hi.LspReferenceRead = { bg = c.lsp_read }
  hi.LspReferenceWrite = { bg = c.lsp_write }

  -- lsp diagnostic highlighting
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
  hi["@lsp.type.class"] = { fg = c.cyan1 }
  hi["@lsp.type.decorator"] = { link = "@constant.macro" }
  hi["@lsp.type.enum"] = { link = "@constructor" }
  hi["@lsp.type.enumMember"] = { link = "@constant" }
  hi["@lsp.type.event"] = { link = "Identifier" }
  hi["@lsp.type.function"] = { link = "@function" }
  hi["@lsp.type.interface"] = { link = "@lsp.type.class" }
  hi["@lsp.type.method"] = { link = "@method" }
  hi["@lsp.type.modifier"] = { link = "Identifier" }
  hi["@lsp.type.namespace"] = { link = "@namespace" }
  hi["@lsp.type.parameter"] = { link = "@parameter" }
  hi["@lsp.type.property"] = { link = "@property" }
  hi["@lsp.type.regexp"] = { link = "@string.regex" }
  hi["@lsp.type.struct"] = { link = "@structure" }
  hi["@lsp.type.type"] = { link = "@type" }
  hi["@lsp.type.typeParameter"] = { link = "@lsp.type.class" }
  hi["@lsp.type.variable"] = { link = "@variable" }

  -- lsp semantic modifier tokens
  -- hi["@lsp.mod.async"] = {}
  -- hi["@lsp.mod.abstract"] = {}
  -- hi["@lsp.mod.declaration"] = {}
  hi["@lsp.mod.defaultLibrary"] = { italic = true }
  -- hi["@lsp.mod.definition"] = {}
  hi["@lsp.mod.deprecated"] = { fg = c.red3, italic = true, strikethrough = true }
  hi["@lsp.mod.documentation"] = { link = "SpecialComment" }
  -- hi["@lsp.mod.modification"] = {}
  hi["@lsp.mod.readonly"] = { italic = true }
  hi["@lsp.mod.static"] = { bold = true }
  hi["@lsp.mod.unnecessary"] = { fg = c.gray2, italic = true }

  -- treesitter highlighting
  hi["@annotation"] = { fg = c.yellow2 }
  hi["@attribute"] = { fg = c.yellow2 }
  hi["@boolean"] = { link = "Boolean" }
  hi["@character"] = { link = "Character" }
  hi["@character.special"] = { link = "SpecialChar" }
  hi["@comment"] = { link = "Comment" }
  hi["@comment.documentation"] = { link = "SpecialComment" }
  hi["@conceal"] = { link = "Conceal" }
  hi["@conditional"] = { fg = c.red2 }
  hi["@constant"] = { link = "Constant" }
  hi["@constant.builtin"] = { bold = true }
  hi["@constant.macro"] = { fg = c.cyan0, italic = true }
  hi["@constructor"] = { fg = c.aqua1 }
  hi["@debug"] = { link = "Debug" }
  hi["@define"] = { link = "Define" }
  hi["@definition.enum"] = { bold = true }
  hi["@error"] = { fg = c.red1 }
  hi["@exception"] = { fg = c.red1 }
  hi["@field"] = { fg = c.fg1 }
  hi["@float"] = { link = "Float" }
  hi["@function"] = { link = "Function" }
  hi["@function.call"] = { link = "Function" }
  hi["@function.builtin"] = { bold = true }
  hi["@function.macro"] = { fg = c.blue1 }
  hi["@include"] = { link = "Include" }
  hi["@keyword"] = { link = "Keyword" }
  hi["@keyword.function"] = { fg = c.magenta1 }
  hi["@keyword.operator"] = { fg = c.magenta1 }
  hi["@keyword.return"] = { fg = c.red2 }
  hi["@label"] = { link = "Label" }
  hi["@method"] = { link = "Function" }
  hi["@method.call"] = { link = "Function" }
  hi["@namespace"] = { fg = c.blue1 }
  hi["@none"] = { fg = c.fg1 }
  hi["@number"] = { link = "Number" }
  hi["@operator"] = { link = "Operator" }
  hi["@parameter"] = { fg = c.rose0 }
  hi["@parameter.reference"] = { fg = c.rose0 }
  hi["@preproc"] = { link = "PreProc" }
  hi["@property"] = { fg = c.fg1 }
  hi["@punctuation.bracket"] = { fg = c.aqua0 }
  hi["@punctuation.delimiter"] = { fg = c.aqua0 }
  hi["@punctuation.special"] = { fg = c.aqua0 }
  hi["@repeat"] = { link = "Repeat" }
  hi["@storageclass"] = { link = "Type" }
  hi["@string"] = { link = "String" }
  hi["@string.documentation"] = { fg = c.green0, italic = true }
  hi["@string.escape"] = { fg = c.purple0 }
  hi["@string.regex"] = { fg = c.rose1 }
  hi["@string.special"] = { link = "Special" }
  hi["@structure"] = { link = "Structure" }
  hi["@symbol"] = { fg = c.blue1 }
  hi["@tag"] = { link = "tag" }
  hi["@tag.attribute"] = { fg = c.orange0 }
  hi["@tag.delimiter"] = { link = "Delimiter" }
  hi["@text"] = { fg = c.fg1 }
  hi["@text.danger"] = { fg = c.bg2, bg = c.red1 }
  hi["@text.diff.add"] = { bg = c.diff_add }
  hi["@text.diff.delete"] = { bg = c.diff_delete }
  hi["@text.emphasis"] = { fg = c.yellow2, italic = true }
  hi["@text.environment"] = { fg = c.blue4 }
  hi["@text.environment.name"] = { fg = c.yellow2 }
  hi["@text.literal"] = { fg = c.orange0 }
  hi["@text.math"] = { fg = c.gray2, bg = c.bg0 }
  hi["@text.note"] = { fg = c.bg2, bg = c.aqua0 }
  hi["@text.reference"] = { fg = c.cyan1 }
  hi["@text.strike"] = { strikethrough = true }
  hi["@text.strong"] = { bold = true }
  hi["@text.title"] = { link = "Title" }
  hi["@text.todo"] = { link = "Todo" }
  hi["@text.underline"] = { link = "Underlined" }
  hi["@text.uri"] = { fg = c.aqua1, underline = true }
  hi["@text.warning"] = { fg = c.bg2, bg = c.yellow2 }
  hi["@type"] = { link = "Type" }
  hi["@type.builtin"] = { bold = true }
  hi["@type.qualifier"] = { link = "Type" }
  hi["@type.definition"] = { link = "TypeDef" }
  hi["@variable"] = { fg = c.fg1 }
  hi["@variable.builtin"] = { fg = c.fg2, bold = true }

  -- statusline highlighting
  hi.StatusLine = { fg = c.fg0, bg = c.gray0 }
  hi.StatusLineNC = { fg = c.gray1, bg = c.gray0 }

  -- tabline highlighting
  hi.TabLine = { fg = c.gray1, bg = c.bg2 }
  hi.TabLineFill = { fg = c.gray1, bg = c.bg2 }
  hi.TabLineSel = { fg = c.fg1, bg = c.bg0, bold = true }

  -- winbar highlighting
  hi.Winbar = { fg = c.gray1, bg = c.bg2 }
  hi.WinbarNC = { bg = c.bg2 }

  -- ensure termguicolors is set (likely redundant)
  vim.opt.termguicolors = true
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
