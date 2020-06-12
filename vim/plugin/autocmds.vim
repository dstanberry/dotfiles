"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup DeferInit
	autocmd!
	if has('vim_starting')
		autocmd CursorHold,CursorHoldI * call functions#idleboot()
	endif
augroup END
"
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
