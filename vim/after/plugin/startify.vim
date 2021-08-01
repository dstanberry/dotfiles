"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Startify Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't change directory when opening a file
let g:startify_change_to_dir = 0

" specify where to save session data
let g:startify_session_dir = $XDG_DATA_HOME.'/vim/session'

let g:startify_bookmarks = []

" set landing page
let g:startify_lists = [
      \ { 'type': 'dir', 'header': [' MRU in '. getcwd() ] },
      \ { 'type': 'sessions', 'header': [' Sessions'] },
      \ { 'type': 'bookmarks', 'header': [' Bookmarks'] },
      \ ]

" ignore the following paths/files
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ 'startify.txt',
      \ ]
