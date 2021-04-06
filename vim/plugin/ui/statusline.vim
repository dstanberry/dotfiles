"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8

if exists('g:loaded_statusline')
  finish
endif

let g:loaded_statusline = 1

function! statusline#is_readonly() abort
  if &readonly || !&modifiable
    return '∅'
  else
    return ''
  endif
endfunction

function! statusline#get_filetype() abort
  if strlen(&ft)
    return &ft
  else
    return ''
  endif
endfunction

function! statusline#get_filepath() abort
  return expand('%:p:h')
endfunction

function! statusline#get_relative_filepath() abort
  let path = expand('%:h')
  if (path == '.')
    return ''
  elseif (path == '')
    return ''
  else
    return path . '/'
  endif
endfunction

function! statusline#get_fileformat() abort
  let format = ''
  let encoding = ''
  if strlen(&ff) && &ff !=# 'unix'
    let format = &ff
  endif
  if strlen(&fenc) && &fenc !=# 'utf-8'
    let encoding = &fenc
  endif

  if format != '' && encoding != ''
    return ',' . join([format, encoding], ',')
  elseif format == '' && encoding == ''
    return ''
  else
    return ',' . format . encoding
  endif
endfunction

function! statusline#show_modified() abort
  if &modified == 1
    return '●'
  else
    return ''
  endif
endfunction

function! statusline#focus()
  " initialize statusline
  let l:statusline = ''
  " mode indicator
  if mode() ==? 'n'
    let l:statusline .= '%#Custom2#▊'
  elseif mode() ==? 'i'
    let l:statusline .= '%#Custom1#▊'
  elseif mode() ==? 'r'
    let l:statusline .= '%#Custom3#▊'
  elseif mode() ==? 'v'
    let l:statusline .= '%#Custom4#▊'
  elseif mode() ==? 'c'
    let l:statusline .= '%#Custom5#▊'
  endif
  let l:statusline .= ' %n'
  if &paste == 1
    let l:statusline .= '📋'
  endif
  " relative file path
  let l:statusline .= '%1* %{statusline#get_relative_filepath()}'
  " filename
  let l:statusline .= '%2*%t%*'
  " modified
  let l:statusline .= '%2* %{statusline#show_modified()}'
  " right-hand side
  let l:statusline .= '%='
  let l:prefix = ''
  " colorize metadata based on mode
  if mode() ==? 'n'
    let l:statusline .= '%#Custom2#'
    let l:prefix .= '%#Custom2#'
  elseif mode() ==? 'i'
    let l:statusline .= '%#Custom1#'
    let l:prefix .= '%#Custom1#'
  elseif mode() ==? 'r'
    let l:statusline .= '%#Custom3#'
    let l:prefix .= '%#Custom3#'
  elseif mode() ==? 'v'
    let l:statusline .= '%#Custom4#'
    let l:prefix .= '%#Custom4#'
  elseif mode() ==? 'c'
    let l:statusline .= '%#Custom5#'
    let l:prefix .= '%#Custom5#'
  endif
  " read-only indicator
  let l:readonly=statusline#is_readonly()
  if l:readonly != ''
    let l:statusline .= '%(%{statusline#is_readonly()}%)'
  endif
  " filetype
  let l:ft=statusline#get_filetype()
  if l:ft != ''
    if l:readonly != ''
      let l:statusline .= '%#SpecialText# • ' . l:prefix
    endif
    let l:statusline .= '%(%{statusline#get_filetype()}%)'
  endif
  " file format and encoding (if not unix || utf-8)
  let l:ff=statusline#get_fileformat()
  if l:ff != ''
    if l:ft != ''
      let l:statusline .= '%#SpecialText# • ' . l:prefix
    endif
    let l:statusline .= '%(%{statusline#get_fileformat()}%)'
  endif
  if l:readonly != '' || l:ft != '' || l:ff != ''
    let l:statusline .= ' '
  endif
  " line and column numbering
  let l:statusline .= '%4* ℓ %l с %c '
  return l:statusline
endfunction

function! statusline#dim()
  " initialize statusline
  let l:statusline = ''
  " relative file path
  let l:statusline .= '%3*  %{statusline#get_relative_filepath()}'
  " filename
  let l:statusline .= '%3*%t%*'
  " modified
  let l:statusline .= '%3* %{statusline#show_modified()}'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_quickfix()
  " initialize statusline
  let l:statusline = ''
  " relative file path
  let l:statusline .= '%3*  [Quickfix]'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_fzf()
  " initialize statusline
  let l:statusline = ''
  " relative file path
  let l:statusline .= '%3*  fzf'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_explorer()
  " initialize statusline
  let l:statusline = ''
  " relative file path
  let l:statusline .= '%3* %{statusline#get_filepath()}'
  " right-hand side
  let l:statusline .= '%='

  return l:statusline
endfunction

function! s:check_windows(...) abort
  for winnum in range(1, winnr('$'))
    " get buffer filetype
    let l:filetype = getbufvar(winbufnr(winnum),'&filetype')
    " get buffer type
    let l:ftype = getftype(bufname(winbufnr(winnum))) 

    " dim statusline if appropriate
    if winnum != winnr()
      if l:filetype ==# 'qf'
        " special statusline for quickfix list
        call setwinvar(winnum, '&statusline', '%!statusline#set_quickfix()')
      elseif l:filetype ==# 'fzf'
        " special statusline for fzf
        call setwinvar(winnum, '&statusline', '%!statusline#set_fzf()')
      elseif l:filetype ==# 'netrw' || l:filetype ==# 'help'
        " special statusline for netrw and help buffers
        call setwinvar(winnum, '&statusline', '%!statusline#set_explorer()')
      elseif l:ftype ==# 'file'
        " dim statusline
        call setwinvar(winnum, '&statusline', '%!statusline#dim()')
      else
        " don't set a statusline for special windows.
        call setwinvar(winnum, '&statusline', '%=')
      endif
    endif
    if winnum == winnr()
      " focus statusline
      call s:set_statusline('active')
    endif
  endfor
endfunction

function! s:set_statusline(mode)
  " get buffer name
  let l:bn = bufname('%')
  " get buffer type
  let l:ftype = getftype(bufname(winbufnr('%'))) 
  " get filename
  let l:fname = expand('%:t')

  if &filetype ==# 'qf'
    " special statusline for quickfix list
    setlocal statusline=%!statusline#set_quickfix()
  elseif &filetype ==# 'fzf'
    " special statusline for fzf
    setlocal statusline=%!statusline#set_fzf()
  elseif &filetype ==# 'netrw' || &filetype ==# 'help'
    " special statusline for netrw and help buffers
    setlocal statusline=%!statusline#set_explorer()
  elseif a:mode ==# 'inactive' && l:ftype ==# 'file'
    " dim the statusline for standard text buffers
    setlocal statusline=%!statusline#dim()
    setlocal nocursorline
  elseif l:fname ==# '[Plugins]'
    " don't set a statusline for vim-plug
    setlocal statusline=%=
  elseif a:mode ==# 'active' && l:ftype ==# 'file' || strlen(l:fname) > 0
    " focus the statusline for standard text buffers
    setlocal statusline=%!statusline#focus()
    setlocal cursorline
  else
    " don't set a statusline for special windows.
    setlocal statusline=%=
  endif
endfunction

if exists('*timer_start')
  call timer_start(100, function('s:check_windows'))
else
  call s:check_windows()
endif

augroup StatusLine
  autocmd!
  autocmd VimEnter * call s:check_windows()
  autocmd BufEnter,BufWinEnter * call s:check_windows()
  autocmd BufLeave,BufWinLeave * call s:set_statusline('inactive')
  autocmd FocusGained,WinEnter * call s:set_statusline('active')
  autocmd FocusLost,WinLeave * call s:set_statusline('inactive')
  autocmd User FzfStatusLine call <sid>set_statusline('active')
augroup END
