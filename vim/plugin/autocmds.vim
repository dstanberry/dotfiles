"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" when idle, toggle cursor position to trigger autoread
autocmd CursorHold * checktime | call feedkeys("\<right>\<left>")

" enable clipboard support within wsl
if system('uname -r') =~ "microsoft"
	augroup Yank
		autocmd!
		autocmd TextYankPost * :call system('clip.exe ',@")
	augroup END
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.cnf set filetype=dosini
autocmd BufRead,BufNewFile *.conf set filetype=conf
autocmd BufRead,BufNewFile gitconfig set filetype=.gitconfig
autocmd BufRead,BufNewFile zprofile set filetype=zsh

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Last Cursor Position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup RestoreCursor
	autocmd!
	autocmd BufWinEnter * call functions#rescursor()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Cursor Shape on Exit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup RestoreCursorShape
	autocmd!
	autocmd VimLeave * :!printf '\e[5 q'
augroup END