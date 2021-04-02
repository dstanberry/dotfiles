"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define default options
if executable('bat')
  let s:fzf_default_opts = $FZF_DEFAULT_OPTS
  let $FZF_DEFAULT_OPTS = s:fzf_default_opts .
        \ ' --preview "bat --color=always --style=header,' .
        \ 'grid --line-range :300 {}"'
endif

" define size and position of window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

" overload rg to support searching in arbitrary locations
function! fzf#rg(query, fullscreen)
  let command_fmt = 'rg --column' .
        \ ' --line-number' .
        \ ' --no-heading' .
        \ ' --color=always' .
        \ ' --smart-case' .
        \ ' -- %s || true'
  let initial_command = printf(command_fmt, a:query)
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(), a:fullscreen)
endfunction

" map custom function to a command
command! -nargs=* -bang RG call fzf#rg(<q-args>, <bang>0)

" fzf: search files available in the current directory
nnoremap <localleader>ff :Files<cr>
" fzf: search git files available in the current directory
nnoremap <localleader>fg :GFiles<cr>
" fzf: search all currently open file buffers
nnoremap <localleader>fb :Buffers<cr>
