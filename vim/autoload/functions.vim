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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => StatusLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#statusLineHighlighter()
	hi InsertMode         ctermfg=0  ctermbg=2
	hi NormalMode         ctermfg=0  ctermbg=4
	hi ReplaceMode        ctermfg=0  ctermbg=6
	hi VisualMode         ctermfg=0  ctermbg=9

	hi clear StatusLine
	hi clear StatusLineNC
	hi User1              ctermfg=12 ctermbg=0 guifg=#8f8f8f guibg=#434345
	hi User2 cterm=bold   ctermfg=7  ctermbg=0 guifg=#dfe3ec guibg=#434345
	hi User3 cterm=italic ctermfg=6  ctermbg=0 guifg=#b04b57 guibg=#434345
	hi User4 cterm=bold   ctermfg=6  ctermbg=0 guifg=#000000 guibg=#a2a2a2
	hi StatusLine                    ctermbg=0 guibg=#434345
	hi StatusLineNC                  ctermbg=10 guifg=#5f5f5f guibg=#393939
endfunction

function! functions#readOnly()
	if &readonly || !&modifiable
		return ''
	else
		return ''
endfunction

function! functions#getRelativeFilePath()
	let path = expand('%:h')
	if (path == '.')
		return ''
	else
		return path . '/'
endfunction