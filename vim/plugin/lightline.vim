""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
\	 'colorscheme': 'wombat',
\	'active': {
\	'left':[ [ 'mode', 'paste' ],
\			[ 'gitbranch', 'readonly', 'filename', 'modified' ]
\		]
\	},
\	'component_function': {
\		'gitbranch': 'fugitive#head',
\	}
\}

let g:lightline.tabline = {
\	'left': [ ['tabs'] ],
\	'right': [ [] ]
\}

let s:base03 = '#242424'
let s:base023 = '#353535'
let s:base02 = '#444444'
let s:base01 = '#585858'
let s:base00 = '#666666'
let s:base0 = '#808080'
let s:base1 = '#969696'
let s:base2 = '#a8a8a8'
let s:base3 = '#d0d0d0'
let s:yellow = '#e5c179'
let s:orange = '#e5786d'
let s:red = '#b04b57'
let s:magenta = '#a4799d'
let s:blue = '#6f8fb4'
let s:cyan = s:blue
let s:green = '#95e454'

let s:cbase03 = 235
let s:cbase023 = 236
let s:cbase02 = 238
let s:cbase01 = 240
let s:cbase00 = 242 
let s:cbase0 = 244
let s:cbase1 = 247
let s:cbase2 = 248
let s:cbase3 = 252
let s:cyellow = 180
let s:corange = 173
let s:cred = 203
let s:cmagenta = 216
let s:cblue = 117
let s:ccyan = s:cblue
let s:cgreen = 119

let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.left = [ [ s:base02, s:blue, s:cbase3, s:cbase01 ] ]
let s:palette.normal.right = [ [ s:base02, s:base0, s:cbase1, s:cbase01 ] ]
let s:palette.inactive.right = [ [ s:base023, s:base01, s:cbase00, s:cbase02 ] ]
let s:palette.inactive.left =  [ [ s:base1, s:base02, s:cbase00, s:cbase023 ] ]
let s:palette.insert.left = [ [ s:base02, s:green, s:cbase3, s:cbase01 ] ]
let s:palette.replace.left = [ [ s:base023, s:red, s:cbase3, s:cbase01 ] ]
let s:palette.visual.left = [ [ s:base02, s:magenta, s:cbase3, s:cbase01 ] ]
let s:palette.normal.middle = [ [ s:base2, s:base02, 0, 0 ] ]
let s:palette.inactive.middle = [ [ s:base1, s:base023, 0, 0 ] ]
let s:palette.tabline.left = [ [ s:base3, s:base00, 0, 0 ] ]
let s:palette.tabline.tabsel = [ [ s:base3, s:base03, 0, 0 ] ]
let s:palette.tabline.middle = [ [ s:base2, s:base02, 0, 0 ] ]
let s:palette.tabline.right = [ [ s:base2, s:base00, 0, 0 ] ]
let s:palette.normal.error = [ [ s:base03, s:red, 0, 0 ] ]
let s:palette.normal.warning = [ [ s:base023, s:yellow, 0, 0 ] ]