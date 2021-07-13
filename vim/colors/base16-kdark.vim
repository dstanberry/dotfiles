"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorscheme Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color palette
let s:gui00        = '373737' " #373737
let s:gui01        = '404040' " #404040
let s:gui02        = '434345' " #434345
let s:gui03        = '5f5f5f' " #5f5f5f
let s:gui04        = '8f8f8f' " #8f8f8f
let s:gui05        = 'c9d1d9' " #c9d1d9
let s:gui06        = 'd8dee9' " #d8dee9
let s:gui07        = 'e7ebf1' " #e7ebf1
let s:gui08        = 'bf616a' " #bf616a
let s:gui09        = 'e6c274' " #e6c274
let s:gui0A        = 'e5c179' " #e5c179
let s:gui0B        = '93b379' " #93b379
let s:gui0C        = '77b3c5' " #77b3c5
let s:gui0D        = '6d8eb5' " #6d8eb5
let s:gui0E        = 'a4799d' " #a4799d
let s:gui0F        = '6f8fb4' " #6f8fb4

" terminal color definitions
let s:cterm00        = '00'
let s:cterm03        = '08'
let s:cterm05        = '07'
let s:cterm07        = '15'
let s:cterm08        = '01'
let s:cterm0A        = '03'
let s:cterm0B        = '02'
let s:cterm0C        = '06'
let s:cterm0D        = '04'
let s:cterm0E        = '05'
let s:cterm01        = '10'
let s:cterm02        = '11'
let s:cterm04        = '12'
let s:cterm06        = '13'
let s:cterm09        = '09'
let s:cterm0F        = '14'

let g:terminal_ansi_colors = [
      \ '#373737',
      \ '#bf616a',
      \ '#93b379',
      \ '#e5c179',
      \ '#6d8eb5',
      \ '#a4799d',
      \ '#77b3c5',
      \ '#cfd6e4',
      \ '#5f5f5f',
      \ '#bf616a',
      \ '#93b379',
      \ '#e5c179',
      \ '#6d8eb5',
      \ '#a4799d',
      \ '#77b3c5',
      \ '#dfe3ec',
      \ ]

" theme setup
hi clear
syntax reset
let g:colors_name = 'base16-kdark'

" highlighting function
" optional variables are attributes and guisp
function! g:Highlight(group, guifg, guibg, ctermfg, ctermbg, ...)
  let l:attr = get(a:, 1, '')
  let l:guisp = get(a:, 2, '')
  if a:guifg != ''
    exec 'hi ' . a:group . ' guifg=#' . a:guifg
  endif
  if a:guibg != ''
    exec 'hi ' . a:group . ' guibg=#' . a:guibg
  endif
  if a:ctermfg != ''
    exec 'hi ' . a:group . ' ctermfg=' . a:ctermfg
  endif
  if a:ctermbg != ''
    exec 'hi ' . a:group . ' ctermbg=' . a:ctermbg
  endif
  if l:attr != ''
    exec 'hi ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
  endif
  if l:guisp != ''
    exec 'hi ' . a:group . ' guisp=#' . l:guisp
  endif
endfunction

function <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Highlight(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfunction

let s:gui10 = substitute(functions#darken(s:gui02, 40), '#', '', 'g')
let s:gui11 = substitute(functions#darken(s:gui03, 25), '#', '', 'g')

" vim editor colors
call <sid>hi('Normal',        s:gui05, s:gui00, s:cterm05, s:cterm00, '', '')
call <sid>hi('Bold',          '', '', '', '', 'bold', '')
call <sid>hi('Debug',         s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('Directory',     s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('Error',         s:gui08, s:gui00, s:cterm0F, s:cterm00, '', '')
call <sid>hi('ErrorMsg',      s:gui08, s:gui00, s:cterm0F, s:cterm00, '', '')
call <sid>hi('Exception',     s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('FoldColumn',    s:gui0C, s:gui01, s:cterm0C, s:cterm01, '', '')
call <sid>hi('Folded',        s:gui03, s:gui01, s:cterm03, s:cterm01, '', '')
call <sid>hi('IncSearch',     s:gui01, s:gui09, s:cterm01, s:cterm09, 'none', '')
call <sid>hi('Italic',        '', '', '', '', 'none', '')
call <sid>hi('Macro',         s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('MatchParen',    s:gui0A, s:gui00, '', s:cterm0A,  '', '')
call <sid>hi('ModeMsg',       s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('MoreMsg',       s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('Question',      s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('Search',        s:gui0E, s:gui00, s:cterm0E, s:cterm00,  'underline', '')
call <sid>hi('Substitute',    s:gui01, s:gui09, s:cterm01, s:cterm09, 'none', '')
call <sid>hi('SpecialKey',    s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('TooLong',       s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('Underlined',    s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('Visual',        s:gui00, s:gui0A, s:gui00, s:cterm0A, '', '')
call <sid>hi('VisualNOS',     s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('WarningMsg',    s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('WildMenu',      s:gui0F, s:gui05, s:cterm08, s:cterm05, '', '')
call <sid>hi('Title',         s:gui0D, '', s:cterm0D, '', 'none', '')
call <sid>hi('Conceal',       s:gui0D, s:gui00, s:cterm0D, s:cterm00, '', '')
call <sid>hi('Cursor',        s:gui00, s:gui05, s:cterm00, s:cterm05, '', '')
call <sid>hi('NonText',       s:gui11, '', s:cterm03, '', '', '')
call <sid>hi('LineNr',        s:gui03, s:gui00, s:cterm03, s:cterm00, '', '')
call <sid>hi('SignColumn',    s:gui03, s:gui00, s:cterm03, s:cterm00, '', '')
call <sid>hi('StatusLine',    s:gui04, s:gui02, s:cterm04, s:cterm02, 'none', '')
call <sid>hi('StatusLineNC',  s:gui03, s:gui01, s:cterm03, s:cterm01, 'none', '')
call <sid>hi('VertSplit',     s:gui02, s:gui02, s:cterm02, s:cterm02, 'none', '')
call <sid>hi('ColorColumn',   '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('CursorColumn',  '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('CursorLine',    '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('CursorLineNr',  s:gui0C, s:gui01, s:cterm0C, s:cterm01, 'bold', '')
call <sid>hi('QuickFixLine',  s:gui01, s:gui0A, s:cterm01, s:cterm0A, 'none', '')
call <sid>hi('PMenu',         s:gui05, s:gui10, s:cterm05, s:cterm01, 'none', '')
call <sid>hi('PMenuSel',      s:gui01, s:gui0F, s:cterm01, s:cterm08, '', '')
call <sid>hi('Whitespace',    s:gui04, '', s:cterm03, '', '', '')
call <sid>hi('TabLine',       s:gui03, s:gui00, s:cterm03, s:cterm00, 'none', '')
call <sid>hi('TabLineFill',   s:gui03, s:gui00, s:cterm03, s:cterm00, 'none', '')
call <sid>hi('TabLineSel',    s:gui05, s:gui00, s:cterm05, s:cterm00, 'none', '')

" lsp highlight groups
let s:sui00 = substitute(functions#darken(s:gui0C, 20), '#', '', 'g')

" standard syntax highlighting
call <sid>hi('Boolean',      s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('Character',    s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('Comment',      s:gui03, '', s:cterm03, '', 'italic', '')
call <sid>hi('Conditional',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('Constant',     s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('Define',       s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Delimiter',    s:sui00, '', s:cterm05, '', '', '')
call <sid>hi('Float',        s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('Function',     s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('Identifier',   s:gui0F, '', s:cterm08, '', 'none', '')
call <sid>hi('Include',      s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('Keyword',      s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('Label',        s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('Number',       s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('Operator',     s:gui05, '', s:cterm05, '', 'none', '')
call <sid>hi('PreProc',      s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('Repeat',       s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('Special',      s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('SpecialChar',  s:gui08, '', s:cterm0F, '', '', '')
call <sid>hi('Statement',    s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('StorageClass', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('String',       s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('Structure',    s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('Tag',          s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('Todo',         s:gui0A, s:gui01, s:cterm0A, s:cterm01, '', '')
call <sid>hi('Type',         s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('Typedef',      s:gui0A, '', s:cterm0A, '', '', '')

" c highlighting
call <sid>hi('cOperator',   s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('cPreCondit',  s:gui0E, '', s:cterm0E, '', '', '')

" c# highlighting
call <sid>hi('csClass',                 s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('csAttribute',             s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('csModifier',              s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('csType',                  s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('csUnspecifiedStatement',  s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('csContextualStatement',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('csNewDecleration',        s:gui0F, '', s:cterm08, '', '', '')

" css highlighting
call <sid>hi('cssBraces',      s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('cssClassName',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('cssColor',       s:gui0C, '', s:cterm0C, '', '', '')

" diff highlighting
call <sid>hi('DiffAdd',      s:gui0B, s:gui00,  s:cterm0B, s:cterm00, '', '')
call <sid>hi('DiffChange',   s:gui09, s:gui00,  s:cterm09, s:cterm00, '', '')
call <sid>hi('DiffDelete',   s:gui08, s:gui00,  s:cterm0F, s:cterm00, '', '')
call <sid>hi('DiffText',     s:gui0D, s:gui00,  s:cterm0D, s:cterm00, '', '')
call <sid>hi('DiffAdded',    s:gui0B, s:gui00,  s:cterm0B, s:cterm00, '', '')
call <sid>hi('DiffFile',     s:gui0F, s:gui00,  s:cterm08, s:cterm00, '', '')
call <sid>hi('DiffNewFile',  s:gui0B, s:gui00,  s:cterm0B, s:cterm00, '', '')
call <sid>hi('DiffLine',     s:gui0D, s:gui00,  s:cterm0D, s:cterm00, '', '')
call <sid>hi('DiffRemoved',  s:gui08, s:gui00,  s:cterm0F, s:cterm00, '', '')

" git highlighting
call <sid>hi('gitcommitBlank',          s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('gitcommitOverflow',       s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('gitcommitSummary',        s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('gitcommitComment',        s:gui03, '', s:cterm03, '', 'italic', '')
call <sid>hi('gitcommitUntracked',      s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitDiscarded',      s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitSelected',       s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitHeader',         s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('gitcommitSelectedType',   s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('gitcommitUnmergedType',   s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('gitcommitDiscardedType',  s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('gitcommitBranch',         s:gui09, '', s:cterm09, '', 'bold', '')
call <sid>hi('gitcommitUntrackedFile',  s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('gitcommitUnmergedFile',   s:gui0F, '', s:cterm08, '', 'bold', '')
call <sid>hi('gitcommitDiscardedFile',  s:gui0F, '', s:cterm08, '', 'bold', '')
call <sid>hi('gitcommitSelectedFile',   s:gui0B, '', s:cterm0B, '', 'bold', '')

" git gutter highlighting
call <sid>hi('GitGutterAdd',     s:gui0B, s:gui01, s:cterm0B, s:cterm01, '', '')
call <sid>hi('GitGutterChange',  s:gui0D, s:gui01, s:cterm0D, s:cterm01, '', '')
call <sid>hi('GitGutterDelete',  s:gui0F, s:gui01, s:cterm08, s:cterm01, '', '')
call <sid>hi('GitGutterChangeDelete',  s:gui0E, s:gui01, s:cterm0E, s:cterm01, '', '')

" html highlighting
call <sid>hi('htmlBold',    s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('htmlItalic',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('htmlEndTag',  s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('htmlTag',     s:gui05, '', s:cterm05, '', '', '')

" java highlighting
call <sid>hi('javaOperator',     s:gui0D, '', s:cterm0D, '', '', '')

" javascript highlighting
call <sid>hi('javaScript',        s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('javaScriptBraces',  s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('javaScriptNumber',  s:gui09, '', s:cterm09, '', '', '')
" pangloss/vim-javascript highlighting
call <sid>hi('jsOperator',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsStatement',         s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsReturn',            s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsThis',              s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('jsClassDefinition',   s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsFunction',          s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsFuncName',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsFuncCall',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsClassFuncName',     s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsClassMethodType',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsRegexpString',      s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('jsGlobalObjects',     s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsGlobalNodeObjects', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsExceptions',        s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsBuiltins',          s:gui0A, '', s:cterm0A, '', '', '')

" mail highlighting
call <sid>hi('mailQuoted1',  s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('mailQuoted2',  s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('mailQuoted3',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('mailQuoted4',  s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('mailQuoted5',  s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('mailQuoted6',  s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('mailURL',      s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('mailEmail',    s:gui0D, '', s:cterm0D, '', '', '')

" markdown highlighting
call <sid>hi('markdownCode',              s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('markdownError',             s:gui05, s:gui00, s:cterm05, s:cterm00, '', '')
call <sid>hi('markdownCodeBlock',         s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('markdownHeadingDelimiter',  s:gui0D, '', s:cterm0D, '', '', '')

" php highlighting
call <sid>hi('phpMemberSelector',  s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpComparison',      s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpParent',          s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpMethodsVar',      s:gui0C, '', s:cterm0C, '', '', '')

" python highlighting
call <sid>hi('pythonOperator',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonRepeat',    s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonInclude',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonStatement', s:gui0E, '', s:cterm0E, '', '', '')

" ruby highlighting
call <sid>hi('rubyAttribute',               s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('rubyConstant',                s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('rubyInterpolationDelimiter',  s:gui08, '', s:cterm0F, '', '', '')
call <sid>hi('rubyRegexp',                  s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('rubySymbol',                  s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('rubyStringDelimiter',         s:gui0B, '', s:cterm0B, '', '', '')

" sass highlighting
call <sid>hi('sassidChar',     s:gui0F, '', s:cterm08, '', '', '')
call <sid>hi('sassClassChar',  s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('sassInclude',    s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('sassMixing',     s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('sassMixinName',  s:gui0D, '', s:cterm0D, '', '', '')

" spelling highlighting
call <sid>hi('SpellBad',     '', '', '', '', 'undercurl', s:gui0F)
call <sid>hi('SpellLocal',   '', '', '', '', 'undercurl', s:gui0C)
call <sid>hi('SpellCap',     '', '', '', '', 'undercurl', s:gui0D)
call <sid>hi('SpellRare',    '', '', '', '', 'undercurl', s:gui0E)

" startify highlight groups
let s:sfy00 = substitute(functions#darken(s:gui09, 50), '#', '', 'g')
let s:sfy01 = substitute(functions#darken(s:gui0D, 35), '#', '', 'g')

" startify highlighting
call <sid>hi('StartifyBracket',  s:sfy00, '', s:cterm03, '', '', '')
call <sid>hi('StartifyFile',     s:gui0D, '', s:cterm07, '', '', '')
call <sid>hi('StartifyFooter',   s:gui04, '', s:cterm03, '', '', '')
call <sid>hi('StartifyHeader',   s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('StartifyNumber',   s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('StartifyPath',     s:sfy01, '', s:cterm03, '', '', '')
call <sid>hi('StartifySection',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('StartifySelect',   s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('StartifySlash',    s:sfy01, '', s:cterm03, '', '', '')
call <sid>hi('StartifySpecial',  s:gui04, '', s:cterm03, '', '', '')

" statusline highlight groups
let s:sl00 = substitute(functions#lighten(s:gui05, 5), '#', '', 'g')
let s:sl01 = substitute(functions#darken(s:gui07, 20), '#', '', 'g')
let s:sl02 = substitute(functions#darken(s:gui07, 30), '#', '', 'g')
let s:sl03 = substitute(functions#darken(s:gui07, 65), '#', '', 'g')

call <sid>hi('User1',        s:sl01, s:gui02, s:cterm04, s:cterm00, '', '')
call <sid>hi('User2',        s:sl00, s:gui02, s:cterm05, s:cterm00, 'bold', '')
call <sid>hi('User3',        s:sl01, s:gui02, s:cterm0C, s:cterm00, 'italic', '')
call <sid>hi('User4',        s:gui00, s:sl02, s:cterm0C, s:cterm00, 'bold', '')
call <sid>hi('User5',        s:sl01, s:gui02, s:cterm04, s:cterm00, 'italic', '')
call <sid>hi('User6',        s:gui00, s:gui0B, s:cterm00, s:cterm0D, '', '')
call <sid>hi('User7',        s:gui00, s:gui0F, s:cterm00, s:cterm0D, '', '')
call <sid>hi('User8',        s:gui00, s:gui0C, s:cterm00, s:cterm0D, '', '')
call <sid>hi('User9',        s:gui00, s:gui08, s:cterm00, s:cterm0D, '', '')

call <sid>hi('Custom00',       s:gui08, s:gui02, s:cterm0F, s:cterm02, '', '')
call <sid>hi('Custom0',        s:sl02, s:gui02, s:cterm0D, s:cterm02, '', '')
call <sid>hi('Custom1',        s:gui0B, s:gui02, s:cterm0B, s:cterm02, '', '')
call <sid>hi('Custom2',        s:gui0F, s:gui02, s:cterm08, s:cterm02, '', '')
call <sid>hi('Custom3',        s:gui0C, s:gui02, s:cterm0C, s:cterm02, '', '')
call <sid>hi('Custom4',        s:gui08, s:gui02, s:cterm0F, s:cterm02, '', '')
call <sid>hi('Custom5',        s:gui0E, s:gui02, s:cterm0E, s:cterm02, '', '')
call <sid>hi('Custom6',        s:gui09, s:gui02, s:cterm09, s:cterm02, '', '')

" remove functions
delfunction <sid>hi
