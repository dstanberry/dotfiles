"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Terminal Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable true color within tmux
if has('termguicolors')
  if &term =~# 'tmux-256color'
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  endif
endif

" use solid block cursor in normal mode
let &t_EI="\<Esc>[2 q"
" use blinking vertical bar in insert mode
let &t_SI="\<Esc>[5 q"
" use blinking underscore cursor in replace mode
let &t_SR="\<Esc>[3 q"
