"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NETRW Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define location for netrw history file
if has('nvim')
  let g:netrw_home=$XDG_DATA_HOME."/nvim/netrw"
else
  let g:netrw_home=$XDG_DATA_HOME."/vim/netrw"
endif

" suppress banner
let g:netrw_banner=0
" use tree listing
let g:netrw_liststyle=3
" open file in existing window
let g:netrw_browse_split=0
