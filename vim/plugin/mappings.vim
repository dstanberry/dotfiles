"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keybinds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define a mapleader for more key coombinations
let mapleader = ' '

" exit insert mode
inoremap jk <esc>

" save to disk
nnoremap <leader>w :w<cr>
" close file after saving
nnoremap <leader>q :q<cr>
" save to disk and close the file
nnoremap <leader>x :x<cr>

" remove extra whitespace
nmap <leader><space> :%s/\s\+$<cr>
nmap <leader><space><space> :%s/\n\{2,}/\r\r/g<cr>

" clear highlighted search matches
nnoremap <c-l> :nohl<cr><c-l> :echo "Search cleared"<cr>

" maintain selection after indentation
vmap < <gv
vmap > >gv

" enable very magic mode during search operations
nnoremap / /\v
vnoremap / /\v

" move between windows.
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l

" move to the beginning of the command
cnoremap <C-a> <Home>
" move to the end of the command
cnoremap <C-e> <End>

" enable cycling through matches using <tab> / <s-tab>
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'
