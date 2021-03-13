"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Move block selection up/down
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:move(address, should_move)
  if visualmode() == 'V' && a:should_move
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! visual#move_up() abort range
  let l:count=v:count ? -v:count : -1
  let l:max=(a:firstline - 1) * -1
  let l:movement=max([l:count, l:max])
  let l:address="'<" . (l:movement - 1)
  let l:should_move=l:movement < 0
  call s:move(l:address, l:should_move)
endfunction

function! visual#move_down() abort range
  let l:count=v:count ? v:count : 1
  let l:max=line('$') - a:lastline
  let l:movement=min([l:count, l:max])
  let l:address="'>+" . l:movement
  let l:should_move=l:movement > 0
  call s:move(l:address, l:should_move)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => send selection to clipboard
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! visual#get_selection() range
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save
  return selection
endfunction
