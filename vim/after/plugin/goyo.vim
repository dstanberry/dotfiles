"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GoYo Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    silent !tmux set status off
  endif
  set noshowmode
  set noshowcmd
  set nocursorline
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set cursorline
  Limelight!
endfunction

augroup goyo_setup
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END
