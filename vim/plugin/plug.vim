"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore GIT_DIR | GIT_WORK_TREE after vim-plug actions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" store the environment variables at startup
if exists("g:loaded_git_dir")
  finish
endif

if exists('$GIT_DIR')
  let s:loaded_git_dir = $GIT_DIR
  let s:loaded_git_worktree = $GIT_WORK_TREE
endif

" redefine the environment variables
function! s:set_git_env()
  " get filename
  let l:fname = expand('%:t')
  " get buffer type
  let l:ftype = getftype(bufname(winbufnr("%"))) 
  let l:git_dir = s:loaded_git_dir
  let l:git_worktree = s:loaded_git_worktree
  " restore variables if buffer is vim-plug
  if l:fname == "[Plugins]" || l:ftype == "vim-plug"
    if len(l:git_dir) > 0 && len(l:git_worktree) > 0
      let $GIT_DIR = l:git_dir
      let $GIT_WORK_TREE = l:git_worktree
    endif
  endif
endfunction

augroup RestoreGitDir
  autocmd!
  autocmd BufLeave,BufWinLeave * call s:set_git_env()
augroup END
