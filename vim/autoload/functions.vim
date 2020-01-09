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