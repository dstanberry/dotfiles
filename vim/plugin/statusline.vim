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
	let l:statusline .= "%3*%{(&paste)?'\ \ 📋':''}"
	" relative file path
	let l:statusline .= "%1*\ %{functions#getRelativeFilePath()}"
	" filename
	let l:statusline .= "%2*%t%*"
	" read-only indicator, filetype, file format and encoding (if not unix || utf-8)
	let l:statusline .= "%3*\ %([%{functions#readOnly()}%{functions#getFileType()}%{functions#getFileFormat()}]%)"
	" right-hand side
	let l:statusline .= "%="
	" line/column numbering
	let l:statusline .= "%4*\ ℓ\ %l/%L\ с\ %c\ %3p%%\ "

	return l:statusline
endfunction

function! BlurStatusLine()
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

function! BlurExplorerStatusLine()
	" initialize statusline
	let l:statusline = ""
	" relative file path
	let l:statusline .= "%3*\ %{functions#getFilePath()}"
	" right-hand side
	let l:statusline .= "%="

	return l:statusline
endfunction

function! s:BlurWindows()
	for winnum in range(1, winnr('$'))
		if winnum != winnr()
			call setwinvar(winnum, '&statusline', '%!BlurStatusLine()')
		endif
	endfor
endfunction

function! s:setStatusLine(mode)
	let l:bn = bufname("%")
	if l:bn ==? "netrwtreelisting" || &filetype == "netrw"
		setlocal statusline=%!BlurExplorerStatusLine()
	elseif &buftype == "nofile" || &filetype == "vim-plug" || l:bn == "[BufExplorer]" || l:bn == "undotree_2"
		" don't set a status line for special windows.
		setlocal statusline=%=
	elseif a:mode == "inactive"
		setlocal statusline=%!BlurStatusLine()
	else
		setlocal statusline=%!FocusStatusLine()
	endif
endfunction

augroup Status
	autocmd!
	autocmd VimEnter * call s:BlurWindows()
	autocmd BufWinEnter,WinEnter * call s:setStatusLine("active")
	autocmd FocusLost,WinLeave * call s:setStatusLine("inactive")
	autocmd CmdwinEnter,CmdlineEnter * call s:setStatusLine("command") | redraw
augroup END
