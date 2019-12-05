"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nord-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme nord

" highliht current line number background
let g:nord_cursor_line_number__background = 1
" use foreground colors to denote file differences
let g:nord_uniform_diff_background = 1
" enable underline vt sequence
let g:nord_underline = 1

augroup nord-theme-overrides
	autocmd!
	autocmd ColorScheme nord highlight Normal guibg=#373737
	autocmd ColorScheme nord highlight SignColumn guibg=#373737
	autocmd ColorScheme nord highlight CursorLine guibg=#434345
	autocmd ColorScheme nord highlight CursorLineNr guibg=#373737 cterm=bold
	autocmd ColorScheme nord highlight LineNr guibg=#373737 guifg=#5a5a5a
	autocmd ColorScheme nord highlight VertSplit guibg=#373737 guifg=#5a5a5a
	autocmd ColorScheme nord highlight Statement ctermfg=3
augroup END
