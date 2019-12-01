" Zap trailing whitespace.
function! leader#trim() abort
	call functions#substitute('\s\+$', '', '')
endfunction