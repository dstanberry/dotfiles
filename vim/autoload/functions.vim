"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8

" entrypoint
function! functions#init() abort
  " ensure XDG_CACHE_HOME is defined
  if empty($XDG_CACHE_HOME)
    let $XDG_CACHE_HOME=$HOME.'/.cache'
  endif

  " ensure XDG_DATA_HOME is defined
  if empty($XDG_DATA_HOME)
    let $XDG_DATA_HOME=$HOME.'/.local/share'
  endif

  if has('nvim')
    " ensure backup directory exists
    if !isdirectory($XDG_CACHE_HOME . '/nvim/backup')
      call mkdir($XDG_CACHE_HOME . '/nvim/backup', 'p')
    endif
    " ensure swap directory exists
    if !isdirectory($XDG_CACHE_HOME . '/nvim/swap')
      call mkdir($XDG_CACHE_HOME . '/nvim/swap', 'p')
    endif
    " ensure undo directory exists
    if !isdirectory($XDG_CACHE_HOME . '/nvim/undo')
      call mkdir($XDG_CACHE_HOME . '/nvim/undo', 'p')
    endif
    " ensure shada directory exists
    if !isdirectory($XDG_DATA_HOME . '/nvim/shada')
      call mkdir($XDG_DATA_HOME . '/nvim/shada', 'p')
    endif
    " ensure netrw directory exists
    if !isdirectory($XDG_DATA_HOME . '/nvim/netrw')
      call mkdir($XDG_DATA_HOME . '/nvim/netrw', 'p')
    endif

    " set viminfo
    set viminfo+=n$XDG_DATA_HOME/nvim/shada/main.shada
  else
    " ensure backup directory exists
    if !isdirectory($XDG_CACHE_HOME . '/vim/backup')
      call mkdir($XDG_CACHE_HOME . '/vim/backup', 'p')
    endif
    " ensure swap directory exists
    if !isdirectory($XDG_CACHE_HOME . '/vim/swap')
      call mkdir($XDG_CACHE_HOME . '/vim/swap', 'p')
    endif
    " ensure undo directory exists
    if !isdirectory($XDG_CACHE_HOME . '/vim/undo')
      call mkdir($XDG_CACHE_HOME . '/vim/undo', 'p')
    endif
    " ensure shada directory exists
    if !isdirectory($XDG_DATA_HOME . '/vim/shada')
      call mkdir($XDG_DATA_HOME . '/vim/shada', 'p')
    endif
    " ensure netrw directory exists
    if !isdirectory($XDG_DATA_HOME . '/vim/netrw')
      call mkdir($XDG_DATA_HOME . '/vim/netrw', 'p')
    endif

    " set viminfo
    set viminfo='10,\"100,:20,%,n$XDG_DATA_HOME/vim/shada/viminfo
  endif
endfunction

" lazy loading of expensive operations
function! functions#idleboot() abort
  " make sure functions#idleboot is called only once.
  augroup defer_init
    autocmd!
  augroup END

  " make sure deferred tasks are run exactly once.
  doautocmd User lazy_load
  augroup singleton
    autocmd! User lazy_load
  augroup END
endfunction

" lazy loading of expensive operations
function! functions#defer(callable) abort
  if has('autocmd') && has('vim_starting')
    execute 'autocmd User lazy_load ' . a:callable
  else
    execute a:callable
  endif
endfunction

" string substitution
function! functions#substitute(pattern, replacement, flags) abort
  let l:number=1
  for l:line in getline(1, '$')
    call setline(l:number, substitute(l:line, a:pattern, a:replacement, a:flags))
    let l:number=l:number + 1
  endfor
endfunction

" trim whitespace
function! functions#trim() abort
  call functions#substitute('\s\+$', '', '')
endfunction

"  restore cursor position
function! functions#restore_cursor_position()
  if &filetype !=# 'netrw' && &filetype !=# 'help'
    if line("'\"") <= line('$')
      normal! g`"
      return 1
    endif
  endif
endfunction

" color manipulation
let s:patterns = {}
let s:patterns['hex']      = '\v#?(\x{2})(\x{2})(\x{2})'
let s:patterns['shortHex'] = '\v#(\x{1})(\x{1})(\x{1})'

" convert rgb to hex
function! functions#rgb_to_hex (...)
  let [r, g, b] = ( a:0==1 ? a:1 : a:000 )
  let num = printf('%02x', float2nr(r)) . ''
        \ . printf('%02x', float2nr(g)) . ''
        \ . printf('%02x', float2nr(b)) . ''
  return '#' . num
endfunction

" convert hex to rgb
function! functions#hex_to_rgb (color)
  if type(a:color) == 2
    let color = printf('%x', a:color)
  else
    let color = a:color | end

  let matches = matchlist(color, s:patterns['hex'])
  let factor  = 0x1

  if empty(matches)
    let matches = matchlist(color, s:patterns['shortHex'])
    let factor  = 0x10
  end

  if len(matches) < 4
    echohl Error
    echom 'Couldnt parse ' . string(color) . ' ' .  string(matches)
    echohl None
    return | end

  let r = str2nr(matches[1], 16) * factor
  let g = str2nr(matches[2], 16) * factor
  let b = str2nr(matches[3], 16) * factor
  return [r, g, b]
endfunction

" lighten color (#rrggbb)
function! functions#lighten(color, ...)
  let amount = a:0 ?
        \(type(a:1) < 2 ?
        \str2float(a:1) : a:1 )
        \: 5.0

  if(amount < 1.0)
    let amount = 1.0 + amount
  else
    let amount = 1.0 + (amount / 100.0)
  end

  let rgb = functions#hex_to_rgb(a:color)
  let rgb = map(rgb, 'v:val * amount')
  let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
  let rgb = map(rgb, 'float2nr(v:val)')
  let hex = functions#rgb_to_hex(rgb)
  return hex
endfunction

" darken color (#rrggbb)
function! functions#darken(color, ...)
  let amount = a:0 ?
        \(type(a:1) < 2 ?
        \str2float(a:1) : a:1 )
        \: 5.0

  if(amount < 1.0)
    let amount = 1.0 - amount
  else
    let amount = 1.0 - (amount / 100.0)
  end

  if(amount < 0.0)
    let amount = 0.0 | end

  let rgb = functions#hex_to_rgb(a:color)
  let rgb = map(rgb, 'v:val * amount')
  let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
  let rgb = map(rgb, 'float2nr(v:val)')
  let hex = functions#rgb_to_hex(rgb)
  return hex
endfunction

" check file for disk changes
function! functions#check_file(timer)
  silent! checktime
  call timer_start(1000, 'functions#check_file')
endfunction

" convert string to bytes
function! functions#str_to_bytes(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

" base64 encode string
function! functions#b64_encode(str)
  let s:b64_table = [
        \ 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        \ 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
        \ 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
        \ 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/']
  let bytes = functions#str_to_bytes(a:str)
  let b64 = []

  for i in range(0, len(bytes) - 1, 3)
    let n = bytes[i] * 0x10000
          \ + get(bytes, i + 1, 0) * 0x100
          \ + get(bytes, i + 2, 0)
    call add(b64, s:b64_table[n / 0x40000])
    call add(b64, s:b64_table[n / 0x1000 % 0x40])
    call add(b64, s:b64_table[n / 0x40 % 0x40])
    call add(b64, s:b64_table[n % 0x40])
  endfor

  if len(bytes) % 3 == 1
    let b64[-1] = '='
    let b64[-2] = '='
  endif

  if len(bytes) % 3 == 2
    let b64[-1] = '='
  endif

  return join(b64, '')
endfunction

" get the range of selected text
function! functions#get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  if lnum1 > lnum2
    let [lnum1, col1, lnum2, col2] = [lnum2, col2, lnum1, col1]
  endif
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection ==# 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")."\n"
endfunction

" move selected vertically within buffer
function! s:move_selection(address, should_move)
  if visualmode() ==? 'v' && a:should_move
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

" shift text selection up
function! functions#move_up() abort range
  let l:count=v:count ? -v:count : -1
  let l:max=(a:firstline - 1) * -1
  let l:movement=max([l:count, l:max])
  let l:address="'<" . (l:movement - 1)
  let l:should_move=l:movement < 0
  call s:move_selection(l:address, l:should_move)
endfunction

" shift text selection down
function! functions#move_down() abort range
  let l:count=v:count ? v:count : 1
  let l:max=line('$') - a:lastline
  let l:movement=min([l:count, l:max])
  let l:address="'>+" . l:movement
  let l:should_move=l:movement > 0
  call s:move_selection(l:address, l:should_move)
endfunction

" send selection to clipboard
function! functions#get_selection() range
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save
  return selection
endfunction

" save and execute vim/lua file
function! functions#execute_file() abort
  if &filetype ==# 'vim'
    :silent! write
    :source %
  elseif &filetype ==# 'lua'
    :silent! write
    :luafile %
  endif
  return
endfunction

" save and execute vim/lua line
function! functions#execute_line() abort
  if &filetype ==# 'vim'
    execute getline('.')
  elseif &filetype ==# 'lua'
    execute(printf(':echo luaeval("%s")', getline('.')))
  endif
  return
endfunction

" lsp send diagnostics info to loclist
if has('nvim')
  function! functions#vim_lsp_diagnostic_set_loclist() abort
    lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
  endfunction
end

"return OS specific path separator
function! functions#get_separator() abort
  if has('win32')
    return '\'
  endif
  return '/'
endfunction


" add item to list if not present in list
function! functions#pack_unique(list, value) abort
  let matching = filter(copy(a:list), 'v:val == a:value')
  if empty(matching)
    call add (a:list, a:value)
  endif
  return a:list
endfunction
