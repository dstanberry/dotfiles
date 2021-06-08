augroup ft_zsh
  autocmd BufRead,BufNewFile zprofile setlocal filetype=zsh
  autocmd BufRead,BufNewFile ~/.config/zsh/rc.private/* setlocal filetype=zsh
augroup END
