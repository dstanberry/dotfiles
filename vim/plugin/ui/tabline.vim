"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8

function! s:get_bufnames(tabCount)
  let bufNames = {}
  for i in range(a:tabCount)
    let tabNum = i + 1
    let winNum = tabpagewinnr(tabNum)
    let buflist = tabpagebuflist(tabNum)
    let bufNum = buflist[winNum - 1]
    let bufName = bufname(bufNum)
    if bufName !=# ''
      let bufName = fnamemodify(bufName, ':~:.')
    endif
    let baseName = fnamemodify(bufName, ':t')
    let bufNames[tabNum] = {}
    let bufNames[tabNum]['fn'] = bufName
    let bufNames[tabNum]['bn'] = baseName
    let bufNames[tabNum]['sn'] = baseName
  endfor
  let bnGroup = {}
  for [tabNum, name] in items(bufNames)
    let bn = name['bn']
    if !has_key(bnGroup, bn)
      let bnGroup[bn] = []
    endif
    let bnGroup[bn] = add(bnGroup[bn], tabNum)
  endfor
  for tabNums in values(bnGroup)
    if len(tabNums) > 1
      for tabNum in tabNums
        let bufNames[tabNum]['sn'] = bufNames[tabNum]['fn']
      endfor
    endif
  endfor
  return bufNames
endfunction

function! tabline#set_tabline()
  let s = ''
  let tabCount = tabpagenr('$')
  let bufNames = s:get_bufnames(tabCount)
  for i in range(tabCount)
    let tabNum = i + 1
    let winNum = tabpagewinnr(tabNum)
    let buflist = tabpagebuflist(tabNum)
    let bufNum = buflist[winNum - 1]
    let bufName = bufNames[tabNum]['sn']
    let bufmodified = 0
    for b in buflist
      if getbufvar(b, '&modified')
        let bufmodified = 1
        break
      endif
    endfor
    let fname = ''
    let buftype = getbufvar(bufNum, '&buftype')
    if buftype ==# ''
      let fname = bufName !=# '' ? bufName : '[No Name]'
    elseif buftype ==# 'quickfix'
      let fname = '[Quickfix]'
    elseif buftype ==# 'help'
      let fname = '[Help]'
    else
      let fname = '[' . bufName . ']'
    endif
    " select the highlighting
    let hl = tabNum == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    let s .= hl
    " set the tab page number (for mouse clicks)
    let s .= '%' . tabNum . 'T'
    " let s .= ' [' . tabNum . '] '
    let s .= '   '
    let s .= fname . '   '
    if bufmodified
      let s .= '● '
    endif
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabCount > 1
    let s .= '%=%#TabLine#%999X'
  endif
  return s
endfunction

augroup tabline
  autocmd!
  autocmd VimEnter * set tabline=%!tabline#set_tabline()
augroup END
