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

function! DimQuickfixStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ [Quickfix]"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! DimFzfStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ \ fzf"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! DimExplorerStatusLine()
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
		if winnum != winnr()
			call setwinvar(winnum, '&statusline', '%!DimStatusLine()')
		endif
	endfor
endfunction

function! s:setStatusLine(mode)
	let l:bn = bufname("%")
	if &filetype == "qf"
		setlocal statusline=%!DimQuickfixStatusLine()
	elseif &filetype == "fzf"
		setlocal statusline=%!DimFzfStatusLine()
	elseif &filetype == "netrw" || &filetype == "help"
		setlocal statusline=%!DimExplorerStatusLine()
	elseif &buftype == "nofile" || &filetype == "vim-plug" || l:bn == "[BufExplorer]" || l:bn == "undotree_2"
		" don't set a status line for special windows.
		setlocal statusline=%=
	elseif a:mode == "inactive"
		setlocal statusline=%!DimStatusLine()
		setlocal nocursorline
	else
		setlocal statusline=%!FocusStatusLine()
		setlocal cursorline
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
	autocmd User FzfStatusLine call <SID>setStatusLine("active")
	autocmd BufWinEnter,WinEnter,ShellCmdPost,BufWritePost * call s:setStatusLine("active")
	autocmd FocusLost,WinLeave * call s:setStatusLine("inactive")
	autocmd CmdwinEnter,CmdlineEnter * call s:setStatusLine("command") | redraw
augroup END
