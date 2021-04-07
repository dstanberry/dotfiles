"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Startify Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't change directory when opening a file
let g:startify_change_to_dir = 0

" specify where to save session data
if has('nvim')
  let g:startify_session_dir = $XDG_DATA_HOME.'/nvim/session'
else
  let g:startify_session_dir = $XDG_DATA_HOME.'/vim-session'
endif

" set landing page
let g:startify_lists = [
      \ { 'type': 'files', 'header': [' MRU'] },
      \ { 'type': 'sessions', 'header': [' Sessions'] },
      \ ]

" ignore the following paths/files
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ 'startify.txt',
      \ ]

" add icons to filepaths
if has('nvim')
  function! StartifyEntryFormat() abort
    return 'v:lua.GetDevIcon(absolute_path) . " " . entry_path'
  endfunction
endif
