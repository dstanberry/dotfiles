"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("g:loaded_statusline")
	finish
endif

let g:loaded_statusline = 1

function! FocusStatusLine()
	" initialize statusline
	let l:statusline = ""
	" mode indicator
	if mode() == 'n'
		let l:statusline .= "%7*%{functions#getMode()}"
	elseif mode() == 'i'
		let l:statusline .= "%6*%{functions#getMode()}"
	elseif mode() == 'R'
		let l:statusline .= "%8*%{functions#getMode()}"
	elseif mode() == 'v' || mode() == 'V'
		let l:statusline .= "%9*%{functions#getMode()}"
	endif
	" relative file path
	let l:statusline .= "%1*\ %{functions#getRelativeFilePath()}"
	" filename
	let l:statusline .= "%2*%t%*"
	" modified
	let l:statusline .= "%2*\ %{functions#getModifiedSymbol()}"
	" right-hand side
	let l:statusline .= "%="
	let l:prefix = ""
	" colorize meatdata based on mode
	if mode() == 'n'
		let l:statusline .= "%#Custom2#"
		let l:prefix .= "%#Custom2#"
	elseif mode() == 'i'
		let l:statusline .= "%#Custom1#"
		let l:prefix .= "%#Custom1#"
	elseif mode() == 'R'
		let l:statusline .= "%#Custom3#"
		let l:prefix .= "%#Custom3#"
	elseif mode() == 'v' || mode() == 'V'
		let l:statusline .= "%#Custom4#"
		let l:prefix .= "%#Custom4#"
	endif
	" read-only indicator
	let l:readonly=functions#getReadOnly()
	if l:readonly != ''
		let l:statusline .= "%(%{functions#getReadOnly()}%)"
	endif
	" filetype
	let l:ft=functions#getFileType()
	if l:ft != ''
		if l:readonly != ''
			let l:statusline .= "%#SpecialText#\ •\ " . l:prefix
		endif
		let l:statusline .= "%(%{functions#getFileType()}%)"
	endif
	" file format and encoding (if not unix || utf-8)
	let l:ff=functions#getFileFormat()
	if l:ff != ''
		if l:ft != ''
			let l:statusline .= "%#SpecialText#\ \•\ " . l:prefix
		endif
		let l:statusline .= "%(%{functions#getFileFormat()}%)"
	endif
	if l:readonly != '' || l:ft != '' || l:ff != ''
		let l:statusline .= "\ "
	endif
	" line/column numbering
	let l:statusline .= "%4*\ ℓ\ %l/%L\ с\ %c\ "

	return l:statusline
endfunction

function! DimStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ \ \ \ \ \ \ \ %{functions#getRelativeFilePath()}"
	" filename
	let l:statusline .= "%3*%t%*"
	" modified
	let l:statusline .= "%3*\ %{functions#getModifiedSymbol()}"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! SetQuickfixStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ [Quickfix]"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! SetFzfStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ fzf"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! SetExplorerStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ %{functions#getFilePath()}"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! s:CheckStatusLines(...) abort
	for winnum in range(1, winnr('$'))
		" get buffer filetype
		let l:filetype = getbufvar(winbufnr(winnum),'&filetype')
		" get buffer type
		let l:ftype = getftype(bufname(winbufnr(winnum))) 

		" dim statusline if appropriate
		if winnum != winnr()
			if l:filetype == "qf"
				" special statusline for quickfix list
				call setwinvar(winnum, '&statusline', '%!SetQuickfixStatusLine()')
			elseif l:filetype == "fzf"
				" special statusline for fzf
				call setwinvar(winnum, '&statusline', '%!SetFzfStatusLine()')
			elseif l:filetype == "netrw" || l:filetype == "help"
				" special statusline for netrw and help buffers
				call setwinvar(winnum, '&statusline', '%!SetExplorerStatusLine()')
			elseif l:ftype == "file"
				" dim statusline
				call setwinvar(winnum, '&statusline', '%!DimStatusLine()')
			else
				" don't set a statusline for special windows.
				call setwinvar(winnum, '&statusline', '%=')
			endif
		endif
		if winnum == winnr()
			" focus statusline
			call s:SetStatusLine("active")
		endif
	endfor
endfunction

function! s:SetStatusLine(mode)
	" get buffer name
	let l:bn = bufname("%")
	" get buffer type
	let l:ftype = getftype(bufname(winbufnr("%"))) 
	" get filename
	let l:fname = expand('%:t')

	if &filetype == "qf"
		" special statusline for quickfix list
		setlocal statusline=%!SetQuickfixStatusLine()
	elseif &filetype == "fzf"
		" special statusline for fzf
		setlocal statusline=%!SetFzfStatusLine()
	elseif &filetype == "netrw" || &filetype == "help"
		" special statusline for netrw and help buffers
		setlocal statusline=%!SetExplorerStatusLine()
	elseif a:mode == "inactive" && l:ftype == "file"
		" dim the statusline for standard text buffers
		setlocal statusline=%!DimStatusLine()
		setlocal nocursorline
	elseif l:fname == "[Plugins]"
		" don't set a statusline for vim-plug
		setlocal statusline=%=
	elseif a:mode == "active" && l:ftype == "file" || strlen(l:fname) > 0
		" focus the statusline for standard text buffers
		setlocal statusline=%!FocusStatusLine()
		setlocal cursorline
	else
		" don't set a statusline for special windows.
		setlocal statusline=%=
	endif
endfunction

if exists('*timer_start')
	call timer_start(100, function('s:CheckStatusLines'))
else
	call s:CheckStatusLines()
endif

augroup StatusLine
	autocmd!
	autocmd VimEnter * call s:CheckStatusLines()
	autocmd BufEnter,BufWinEnter * call s:CheckStatusLines()
	autocmd BufLeave,BufWinLeave * call s:SetStatusLine("inactive")
	autocmd FocusGained,WinEnter * call s:SetStatusLine("active")
	autocmd FocusLost,WinLeave * call s:SetStatusLine("inactive")
	autocmd User FzfStatusLine call <SID>SetStatusLine("active")
augroup END
