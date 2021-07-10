"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GIT_DIR | GIT_WORK_TREE Management
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" store the environment variables if defined at startup
if exists('g:loaded_git_workspace')
  finish
endif
let g:loaded_git_workspace = 1

if exists('$GIT_DIR')
  let s:env_git_dir = $GIT_DIR
  let s:env_git_wt = $GIT_WORK_TREE
endif

let s:saved_worktrees = readfile(expand($HOME.'/.config/git/worktrees'))
let s:key = ''
let s:dict = {}
for str in s:saved_worktrees
  let s:tuple = split(str,',')
  if len(s:tuple) == 2
    if isdirectory(expand(s:tuple[0]))
      let s:dict[s:tuple[0]] = s:tuple[1]
    endif
  endif
endfor

function! git#disable()
  if exists('$GIT_DIR') | unlet $GIT_DIR | endif
  if exists('$GIT_WORK_TREE') | unlet $GIT_WORK_TREE | endif
  return
endfunction

function! s:configure(...)
  if a:0 == 2 && a:2
    if exists('$GIT_DIR') | unlet $GIT_DIR | endif
    if exists('$GIT_WORK_TREE') | unlet $GIT_WORK_TREE | endif
    return
  endif
  if exists('s:env_git_dir') | let l:git_dir = s:env_git_dir | endif
  if exists('s:env_git_wt') | let l:git_worktree = s:env_git_wt | endif
  let l:is_git_dir = 0
  for [k, v] in items(s:dict)
    if stridx(a:1, expand(v)) != -1
      let $GIT_DIR = k
      let $GIT_WORK_TREE = v
      let l:is_git_dir = 1
    endif
  endfor
  if !l:is_git_dir
    if exists('$GIT_DIR') | unlet $GIT_DIR | endif
    if exists('$GIT_WORK_TREE') | unlet $GIT_WORK_TREE | endif
    return
  endif
  if exists('l:git_worktree') && len(l:git_worktree)
    let $GIT_WORK_TREE = l:git_worktree
  endif
  if exists('l:git_dir') && len(l:git_dir)
    let $GIT_DIR = l:git_dir
  else
  endif
  if exists('g:loaded_signify')
    execute 'SignifyDisable | SignifyEnable'
  endif
endfunction

function! s:on_buf_enter()
  let l:fname = expand('%:t')
  let l:ftype = getftype(bufname(winbufnr('%'))) 
  let l:path = expand('%:p:h')
  if l:fname ==# '[Plugins]' || l:ftype ==# 'vim-plug' || l:fname ==# '[packer]'
    if exists('$GIT_DIR') | unlet $GIT_DIR | endif
    if exists('$GIT_WORK_TREE') | unlet $GIT_WORK_TREE | endif
  else
    return s:configure(l:path)
  endif
endfunction

function! s:on_buf_leave()
  let l:fname = expand('%:t')
  let l:ftype = getftype(bufname(winbufnr('%'))) 
  let l:path = expand('%:p:h')
  if l:fname ==#'[Plugins]' || l:ftype ==# 'vim-plug' || l:fname ==# '[packer]'
    return s:configure(l:path)
  endif
endfunction

command! Gtoggle call <sid>configure(expand('%:p:h'), 1)

augroup git_worktree
  autocmd!
  autocmd VimEnter,BufEnter * call <sid>on_buf_enter()
  autocmd BufLeave * call s:on_buf_leave()
  autocmd FileType vim-plug call git#disable()
  autocmd FileType packer call git#disable()
  autocmd CmdlineLeave : if getcmdline() =~# '\v^Packer%[Update]%[Sync]%[Status]%[Profile]%[Load]%[Install]%[Compile]%[Clean]$'
        \|  call git#disable()
        \| endif
  autocmd CmdlineLeave : if getcmdline() =~# '\v^Plug%[Clean]%[Install]%[Status]%[Update]%[Upgrade]$'
        \|  call git#disable()
        \| endif
augroup END
