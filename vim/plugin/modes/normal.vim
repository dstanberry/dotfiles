"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clear highlighted search matches
nnoremap <c-l> :nohl<cr><c-l> :echo "Search cleared"<cr>

" enable very magic mode during search operations
nnoremap / /\v

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" avoid unintentional switches to man(ual)
nnoremap K <nop>

" store relative jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" save to disk
nnoremap <leader>w :w<cr>
" close file after saving
nnoremap <leader>q :q<cr>
" save to disk and close the file
nnoremap <leader>x :x<cr>

" trim trailing whitespace
nmap <leader>zz :call leader#trim()<cr>

" fzf: list files available in the current directory
nnoremap <leader><leader> :Files<cr>
" fzf: list git files available in the current directory
nnoremap <leader>gi :GFiles<cr>
" fzf: list all currently open file buffers
nnoremap <leader><cr> :Buffers<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" create/edit file within the current directory
nnoremap <LocalLeader>e :edit <C-R>=expand('%:p:h') . '/'<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal, Visual, Select, Operator-pending
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yank to end of line
noremap Y y$