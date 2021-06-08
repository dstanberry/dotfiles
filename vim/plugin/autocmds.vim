"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup defer_init
  autocmd!
  if has('vim_starting')
    if has('nvim')
      if exists('g:loaded_fix_cursorhold_nvim')
        autocmd CursorHold,CursorHoldI * call functions#idleboot()
      else
        " CursorHold events have not been firing in neovim
        " ... so the following bad hack will have to do for now
        autocmd CursorMoved,CursorMovedI * call functions#idleboot()
      endif
    else
      autocmd CursorHold,CursorHoldI * call functions#idleboot()
    endif
  endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Last Cursor Position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup cursor_position
  autocmd!
  autocmd BufWinEnter * call functions#restore_cursor_position()
augroup END
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Highlight Yanked Text
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('##TextYankPost')
  augroup lua_yank_highlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
  augroup END
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Place cursor on first line of git commit message
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup gitcommit
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.',[0, 1, 1, 0])
  autocmd FileType gitcommit startinsert
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Disable smartcase when in command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup auto_smartcase
  autocmd!
  autocmd CmdLineEnter : set nosmartcase
  autocmd CmdLineLeave : set smartcase
augroup END
