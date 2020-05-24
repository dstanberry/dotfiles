function! normal#trim() abort
	call functions#substitute('\s\+$', '', '')
endfunction
