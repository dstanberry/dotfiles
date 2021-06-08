augroup ft_git
  autocmd BufRead,BufNewFile gitconfig setlocal filetype=.gitconfig
  autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal nobackup noswapfile
augroup END
