"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move between windows.
vnoremap <c-h> <c-w>h
vnoremap <c-j> <c-w>j
vnoremap <c-k> <c-w>k
vnoremap <c-l> <c-w>l

" begin substitution for current selection
vmap <c-r> :<bs><bs><bs><bs><bs>%s/<c-r>=functions#get_selection()<cr>/

" insert line break after parenthesis and comma
vnoremap gob  :s/\((\zs\\|,\ *\zs\\|)\)/\r&/g<cr><bar>:'[,']normal ==<cr>

" maintain selection after indentation
vmap < <gv
vmap > >gv

" enable very magic mode during search operations
vnoremap / /\v

" allow semi-colon to enter command mode
vmap ; :

" move selection to the beginning of the current line
vnoremap H ^
" move selection to the end of the current line
vnoremap L g_

" move selection vertically within buffer
vnoremap <silent> K :call functions#move_up()<cr>
vnoremap <silent> J :call functions#move_down()<cr>

" exit visual mode
vnoremap ZZ <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" preserve clipboard content after pasting
vnoremap <leader>p "_dp

" execute selected text
vnoremap <leader>x :call functions#execute_selection()<cr>
