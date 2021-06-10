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
    return ' '
  else
    return ''
  endif
endfunction

function! statusline#get_filetype() abort
  if strlen(&ft)
    if has('nvim-0.5')
      return luaeval('require"nvim-web-devicons".get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"))') . ' ' . &ft
    else
      return &ft
    endif
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
    return join([format, encoding], ' | ')
  else
    return format . encoding
  endif
endfunction

function! statusline#show_modified() abort
  if &modified == 1
    return '●'
  else
    return ''
  endif
endfunction

function! statusline#get_lsp_errors() abort
  let l:sl = ''
  if has('nvim-0.5') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let l:sl .=' '
    let l:sl .= luaeval('vim.lsp.diagnostic.get_count(0, "Error")')
  endif
  return l:sl
endfunction

function! statusline#get_lsp_warnings() abort
  let l:sl = ''
  if has('nvim-0.5') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let l:sl .='𥉉'
    let l:sl .= luaeval('vim.lsp.diagnostic.get_count(0, "Warn")')
  endif
  return l:sl
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
  elseif mode() ==? 'v' || mode() ==? "\<c-v>"
    let l:statusline .= '%#Custom4#▊'
  elseif mode() ==? 'c'
    let l:statusline .= '%#Custom5#▊'
  elseif mode() ==? 's' || mode() ==? "\<c-s>"
    let l:statusline .= '%#Custom6#▊'
  endif
  if exists('g:loaded_fugitive')
    let l:branch = FugitiveHead()
    if len(l:branch) > 0
      " show branch name
      let l:statusline .= '  %{FugitiveHead()}'
    else
      " static icon
      let l:statusline .= '  '
    endif
  else
    " static icon
    let l:statusline .= '  '
  endif
  " relative file path
  let l:statusline .= '%1* %{statusline#get_relative_filepath()}'
  " filename
  let l:statusline .= '%2*%t%*'
  " modified
  let l:statusline .= '%2* %{statusline#show_modified()}'
  " show paste mode when active
  if &paste == 1
    let l:statusline .= '  '
  endif
  " right-hand side
  let l:statusline .= '%='
  " LSP diagnostic error count
  let l:statusline .='%1*%{statusline#get_lsp_errors()} '
  " LSP diagnostic warning count
  let l:statusline .='%1*%{statusline#get_lsp_warnings()}   '
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
  let l:statusline .= '%#Custom00#%{statusline#is_readonly()}'
  if l:readonly != ''
    let l:statusline .= '%#Custom0# | '
  endif
  " file format and encoding (if not unix || utf-8)
  let l:ff=statusline#get_fileformat()
  let l:statusline .= '%#Custom0#%{statusline#get_fileformat()}'
  if l:readonly != '' || l:ff != ''
    let l:statusline .= ' | '
  endif
  " filetype
  let l:ft=statusline#get_filetype()
  let l:statusline .= l:prefix . '%{statusline#get_filetype()}'
   if l:readonly != '' || l:ff != '' || l:ft != ''
    let l:statusline .= ' '
  endif
 " line and column numbering
  let l:statusline .= '%4* ℓ %l с %c '
  return l:statusline
endfunction

function! statusline#dim()
  " relative file path
  let l:statusline = '%3*  %{statusline#get_relative_filepath()}'
  " filename
  let l:statusline .= '%3*%t%*'
  " modified
  let l:statusline .= '%3* %{statusline#show_modified()}'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_quickfix()
  " relative file path
  let l:statusline = '%3*  [Quickfix]'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_fzf()
  " relative file path
  let l:statusline = '%3*  fzf'
  " right-hand side
  let l:statusline .= '%='
  return l:statusline
endfunction

function! statusline#set_explorer()
  " relative file path
  let l:statusline = '%3* %{statusline#get_filepath()}'
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
      elseif l:filetype ==# 'netrw' || l:filetype ==# 'dirvish' ||
            \ l:filetype ==# 'lir' || l:filetype ==# 'help'
        " special statusline for file explorers and help buffers
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

augroup statusline
  autocmd!
  autocmd VimEnter * call s:check_windows()
  autocmd BufEnter,BufWinEnter * call s:set_statusline('active')
  autocmd BufLeave,BufWinLeave * call s:set_statusline('inactive')
  autocmd FocusGained,WinEnter * call s:set_statusline('active')
  autocmd FocusLost,WinLeave * call s:set_statusline('inactive')
  autocmd User statusline call <sid>check_windows()
augroup END
