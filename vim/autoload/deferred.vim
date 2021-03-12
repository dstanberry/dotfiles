"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load private directory hashes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! deferred#load_dir_hash() abort
	let l:shell = trim(system('echo "${SHELL##/*/}"'))
	let l:path = '~/.config/' . l:shell . '/rc.private/hashes'
	let l:cmd = 'zsh -c "' .
		\ 'test -e ' . l:path . ' && ' . 'source ' . l:path . '; ' .
		\ 'hash -d"'
	let l:dirs=system(l:cmd)
	let l:lines=split(l:dirs, '\n')
	for l:line in l:lines
		let l:pair=split(l:line, '=')
		let l:var=l:pair[0]
		let l:dir=l:pair[1]
		if !exists('$' . l:var)
			execute 'let $' . l:var . '="' . l:dir . '"'
		endif
	endfor
endfunction
