"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Seamless clipboard experience
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:copy(lines, ...)
  let str = join(a:lines, "\n")
  let enc = functions#b64_encode(str)
  let buf = "\e]52;0;" . enc . "\x07"

  execute 'silent! !echo ' . shellescape('print -l ' . str . ' | tmux load-buffer -')
  execute 'silent! !echo ' . shellescape('printf "'. buf . '" > /dev/stderr')
  redraw!
endfunction

function! s:paste(mode)
  let @" = system('paste')
  return a:mode
endfunction

function! s:tmux_paste(mode)
  let @" = system('tmux save-buffer -')
  return a:mode
endfunction

if !empty($SSH_CONNECTION) || !empty($SSH_TTY) || !empty($SSH_CLIENT)
  augroup clip
    autocmd!
    autocmd TextYankPost * call s:copy(split(@", "\n"))
  augroup END
  map <expr> p <SID>tmux_paste('p')
  map <expr> P <SID>tmux_paste('P')
elseif system('uname -r') =~? 'microsoft'
  augroup clip
    autocmd!
    autocmd TextYankPost * call system('clip.exe', @")
  augroup END
  map <expr> p <SID>paste('p')
  map <expr> P <SID>paste('P')
endif
