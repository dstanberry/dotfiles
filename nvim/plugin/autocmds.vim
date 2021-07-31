"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Highlight Yanked Text
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup lua_yank_highlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Disable smartcase when in command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup auto_smartcase
  autocmd!
  autocmd CmdLineEnter set nosmartcase
  autocmd CmdLineLeave set smartcase
augroup END
