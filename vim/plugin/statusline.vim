if exists("g:loaded_statusline")
	finish
endif

let g:loaded_statusline = 1

function! FocusStatusLine()
	" initialize statusline
	let l:statusline = ""
	" mode indicator
	let l:statusline .= "%7*%{(mode()=='n')?'\ \ normal\ ':''}"
	let l:statusline .= "%6*%{(mode()=='i')?'\ \ insert\ ':''}"
	let l:statusline .= "%8*%{(mode()=='R')?'\ \ replace\ ':''}"
	let l:statusline .= "%9*%{(mode()==#'v')?'\ \ visual\ ':''}"
	let l:statusline .= "%9*%{(mode()==#'V')?'\ \ v-line\ ':''}"
	" paste indicator
	let l:statusline .= "%3*%{(&paste)?'\ \ \(paste\)':''}"
	" relative file path
	let l:statusline .= "%1*\ %{functions#getRelativeFilePath()}"
	" filename
	let l:statusline .= "%2*%t%*"
	" read-only indicator, filetype, file format and encoding (if not unix || utf-8)
	let l:statusline .= "%3*\ %([%{functions#readOnly()}%{functions#getFileType()}%{functions#getFileFormat()}]%)"
	" right-hand side
	let l:statusline .= "%="
	" show coc status
	if has('nvim')
		let l:statusline .= "%1*%{coc#status()}\ "
	endif
	" line/column numbering
	let l:statusline .= "%4*\ ℓ\ %l/%L\ с\ %c\ "

	return l:statusline
endfunction

function! DimStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ \ \ \ \ \ \ %{functions#getRelativeFilePath()}"
	" filename
	let l:statusline .= "%3*%t%*"
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
	" filetype
	let l:statusline .= "%3*\ %y"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! s:CheckStatusLines(...) abort
	for winnum in range(1, winnr('$'))
		let l:ftype = getftype(bufname(winbufnr(winnum))) 
		if winnum != winnr()
			call setwinvar(winnum, '&statusline', '%!DimStatusLine()')
		endif
		if winnum == winnr() && l:ftype != "file"
			call setwinvar(winnum, '&statusline', '')
			echom l:ftype
		endif
	endfor
endfunction

function! s:SetStatusLine(mode)
	" get buffer name
	let l:bn = bufname("%")
	" get buffer type
	let l:ftype = getftype(bufname(winbufnr("%"))) 
	if &filetype == "qf"
		setlocal statusline=%!SetQuickfixStatusLine()
	elseif &filetype == "fzf"
		setlocal statusline=%!SetFzfStatusLine()
	elseif &filetype == "netrw" || &filetype == "help"
		setlocal statusline=%!SetExplorerStatusLine()
	elseif a:mode == "inactive"
		setlocal statusline=%!DimStatusLine()
		setlocal nocursorline
	elseif a:mode == "active" && l:ftype == "file"
		setlocal statusline=%!FocusStatusLine()
		setlocal cursorline
	else
		" don't set a status line for special windows.
		setlocal statusline=%=
	endif
endfunction

if exists('*timer_start')
	call timer_start(100, function('s:CheckStatusLines'))
else
	call s:CheckStatusLines()
endif

augroup Status
	autocmd!
	autocmd VimEnter * call s:CheckStatusLines()
	autocmd BufEnter,BufWinEnter * call s:CheckStatusLines()
	autocmd BufLeave,BufWinLeave * call s:SetStatusLine("inactive")
	autocmd FocusGained,WinEnter * call s:SetStatusLine("active")
	autocmd FocusLost,WinLeave * call s:SetStatusLine("inactive")
	autocmd User FzfStatusLine call <SID>SetStatusLine("active")
augroup END
