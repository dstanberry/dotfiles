if system('uname -r') =~ 'microsoft'
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
