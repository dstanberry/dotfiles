function s:copy(lines, ...)
	let str = join(a:lines, "\n")
	let jid = jobstart('tmux load-buffer -')

	call chansend(jid, str)
	call chanclose(jid)

	let str = functions#b64encode(str)

	call chansend(v:stderr, "\033]52;;" . str . "\007")
endfunction

function! s:paste(mode)
	let @" = system('pbpaste')
	return a:mode
endfunction

function! s:tmux_paste(mode)
	let @" = system('tmux save-buffer -')
	return a:mode
endfunction

if !empty($SSH_CONNECTION) || !empty($SSH_TTY) || !empty($SSH_CLIENT)
	autocmd TextYankPost * call s:copy(split(@"), "\n"))

	map <expr> p <SID>tmux_paste('p')
	map <expr> P <SID>tmux_paste('P')
elseif system('uname -r') =~ 'microsoft'
	autocmd TextYankPost * call system('clip.exe', @")

	map <expr> p <SID>paste('p')
	map <expr> P <SID>paste('P')
endif
