let g:coc_global_extensions = [
	\ 'coc-css',
	\ 'coc-highlight',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-pairs',
	\ 'coc-prettier',
	\ 'coc-python',
	\ 'coc-svg',
	\ 'coc-tsserver',
	\ 'coc-vimlsp',
	\ 'coc-xml',
	\ 'coc-yaml'
	\ ]

command! -nargs=0 Prettier :CocCommand prettier.formatFile
