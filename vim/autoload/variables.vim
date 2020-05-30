"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load private directory hashes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! variables#init() abort
	" set up shortcut variables for "hash -d" directories.
	let l:dirs=system(
		\ 'zsh -c "' .
		\ 'test -e ~/.config/zsh/rc.private/hashes && ' .
		\ 'source ~/.config/zsh/rc.private/hashes; ' .
		\ 'hash -d"'
		\ )
	let l:lines=split(l:dirs, '\n')
	for l:line in l:lines
		let l:pair=split(l:line, '=')
		let l:var=l:pair[0]
		let l:dir=l:pair[1]

		" don't clobber any pre-existing variables.
		if !exists('$' . l:var)
			execute 'let $' . l:var . '="' . l:dir . '"'
		endif
	endfor
endfunction