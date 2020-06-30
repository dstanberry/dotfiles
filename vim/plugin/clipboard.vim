function s:copy(lines, regtype)
	let str = join(a:lines, "\n")
	let jid = jobstart('tmux load-buffer -')

	call chansend(jid, str)
	call chanclose(jid)

	let str = functions#b64encode(str)

	call chansend(v:stderr, "\033]52;;" . str . "\007")
endfunction

if !empty($SSH_CONNECTION) || !empty($SSH_TTY) || !empty($SSH_CLIENT)
	let g:clipboard = {
		\ 'name': 'SSHClipboard',
		\ 'copy': {
		\   '+': function('s:copy'),
		\   '*': function('s:copy'),
		\   },
		\ 'paste': {
		\   '+': 'tmux save-buffer -',
		\   '*': 'tmux save-buffer -',
		\   },
		\ 'cache_enabled': 0
		\ }
elseif system('uname -r') =~ 'microsoft'
	let g:clipboard = {
		\ 'name': 'WSLClipboard',
		\ 'copy': {
		\   '+': 'clip.exe',
		\   '*': 'clip.exe',
		\   },
		\ 'paste': {
		\   '+': 'pbpaste',
		\   '*': 'pbpaste',
		\   },
		\ 'cache_enabled': 1
		\ }
endif
