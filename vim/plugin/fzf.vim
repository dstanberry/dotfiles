" define default options
if executable('bat')
	let s:fzf_default_opts = $FZF_DEFAULT_OPTS
	let $FZF_DEFAULT_OPTS = s:fzf_default_opts.' --preview "bat --color=always --style=header,grid --line-range :300 {}"'
endif

" define size and position of window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

" overload rg to support searching in arbitrary locations
function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_command = printf(command_fmt, a:query)
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
