"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" when idle, toggle cursor position to trigger autoread
autocmd CursorHold * checktime | call feedkeys("lh")

" remove all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

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
