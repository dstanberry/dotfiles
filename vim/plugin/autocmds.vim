"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup defer_init
  autocmd!
  if has('vim_starting')
    autocmd CursorHold,CursorHoldI * call functions#idleboot()
  endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Disable smartcase when in command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup auto_smartcase
  autocmd!
  autocmd CmdLineEnter set nosmartcase
  autocmd CmdLineLeave set smartcase
augroup END
