"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NETRW Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define location for netrw history file
let g:netrw_home=$XDG_DATA_HOME.'/vim/netrw'

" disable plugin
let g:loaded_netrwPlugin=1
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
let g:loaded_netrwSettings=1
let g:loaded_netrwFileHandlers=1

" suppress banner
let g:netrw_banner=0
" use tree listing
let g:netrw_liststyle=3
" open file in existing window
let g:netrw_browse_split=0

" show directory of current file in explorer
" nnoremap <silent>
" 	  \ - :silent edit <c-r>=empty(expand('%')) ? '.' : expand('%:p:h')<cr><cr>
