"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => String Substitution
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#substitute(pattern, replacement, flags) abort
	let l:number=1
	for l:line in getline(1, '$')
		call setline(l:number, substitute(l:line, a:pattern, a:replacement, a:flags))
		let l:number=l:number + 1
	endfor
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Cursor Position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#rescursor()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Toggle netrw buffer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#netrwToggle()
	if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
			if (getbufvar(i, "&filetype") == "netrw")
				silent exe "bwipeout " . i 
			endif
			let i-=1
		endwhile
		let g:NetrwIsOpen=0
	else
		let g:NetrwIsOpen=1
		silent Lexplore
	endif
endfunction
