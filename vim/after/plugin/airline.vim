"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" display all buffers
let g:airline#extensions#tabline#enabled = 1
" define file path label
let g:airline#extensions#tabline#formatter = 'unique_tail'
" disable powerline glyphs
let g:airline_powerline_fonts = 1
" cache syntax highlight groups
let g:airline_highlighting_cache = 1
" hide empty sections
let g:airline_skip_empty_sections = 1
" define left separator
let g:airline_left_sep = ' '
" define alternate left separator
let g:airline_alt_left_sep = '|'
" define right separator
let g:airline_right_sep = ' '
" define alternate right separator
let g:airline_alt_right_sep = '|'
