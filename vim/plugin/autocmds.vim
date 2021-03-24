"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup DeferInit
  autocmd!
  if has('vim_starting')
    " CursorHold events have not been firing in neovim
    " ... so the following bad hack will have to do for now
    if has('nvim')
      autocmd CursorMoved,CursorMovedI * call functions#idleboot()
    else
      autocmd CursorHold,CursorHoldI * call functions#idleboot()
    endif
  endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.cnf set filetype=dosini
autocmd BufRead,BufNewFile *.conf set filetype=conf
autocmd BufRead,BufNewFile gitconfig set filetype=.gitconfig
autocmd BufRead,BufNewFile zprofile set filetype=zsh
autocmd BufRead,BufNewFile ~/.config/bash/rc/* set filetype=bash
autocmd BufRead,BufNewFile ~/.config/bash/rc.private/* set filetype=bash
autocmd BufRead,BufNewFile ~/.config/zsh/rc/* set filetype=zsh
autocmd BufRead,BufNewFile ~/.config/zsh/rc.private/* set filetype=zsh

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Last Cursor Position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup RestoreCursor
  autocmd!
  autocmd BufWinEnter * call functions#restore_cursor_position()
augroup END
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Highlight Yanked Text
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('##TextYankPost')
  augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
  augroup END
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Place cursor on first line of git commit message
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup GitCommitMsg
  autocmd!
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.',[0, 1, 1, 0])
  autocmd FileType gitcommit startinsert
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Attempt to populate loclist if ft supported by LSP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup LSP
  autocmd!
  autocmd BufWrite,BufEnter,InsertLeave * :call functions#vim_lsp_diagnostic_set_loclist()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Disable smartcase when in command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup CmdTabComplete
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END
