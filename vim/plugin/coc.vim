let g:coc_general = {
		\ "http.proxyStrictSSL": v:true,
		\ "prettier.arrowParens": "always",
		\ "prettier.bracketSpacing": v:true,
		\ "prettier.endOfLine": "lf",
		\ "prettier.printWidth": 80,
		\ "prettier.semi": v:true,
		\ "prettier.singleQuote": v:false,
		\ "prettier.tabWidth": 4,
		\ "prettier.trailingComma": "es5",
		\ "prettier.useTabs": v:true
	\}

let g:coc_languageservers = {
		\ "languageserver": {
			\ "bash": {
				\ "command": "bash-language-server",
				\ "args": ["start"],
				\ "filetypes": ["sh"],
				\ "ignoredRootPaths": ["~"]
			\ }
		\ },
	\ }

let g:coc_user_config = extend(g:coc_general, g:coc_languageservers)

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
