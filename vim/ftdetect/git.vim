augroup ft_git
  autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal nobackup noswapfile noundofile
  autocmd BufRead,BufNewFile gitconfig setlocal filetype=.gitconfig
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.',[0, 1, 1, 0])
  autocmd FileType gitcommit startinsert
augroup END
