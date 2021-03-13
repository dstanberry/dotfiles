"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undotree: toggle the undo-tree panel
nnoremap <F5> :UndotreeToggle<cr>

" bind ctl-c to escape key
nnoremap <c-c> <esc>

" navigate quickfix list using arrow keys
nnoremap <silent> <up> :cprevious<cr>
nnoremap <silent> <down> :cnext<cr>
nnoremap <silent> <left> :cpfile<cr>
nnoremap <silent> <right> :cnfile<cr>

" switch to next tab
nnoremap <c-right> gt
" switch to previous tab
nnoremap <c-left> gT

" enable very magic mode during search operations
nnoremap / /\v

" allow semi-colon to enter command mode
nnoremap ; :

" move to the beginningof the current line
nnoremap H ^

" avoid unintentional switches to man(ual)
nnoremap K <nop>

" move to the end of the current line
nnoremap L g_

" insert newline without entering insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" disable recording to a register
nnoremap q <nop>

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" yank to end of line
noremap Y y$

" show directory of current file in explorer
nnoremap <silent> - :silent edit <c-r>=empty(expand('%')) ? '.' : expand('%:p:h')<cr><cr>

" store relative jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" clear hlsearch if set, otherwise send default
nnoremap <expr> <cr> {-> v:hlsearch ? ":nohl\<cr>" : "\<cr>"}()

" find all occurences in file of word under cursor
nnoremap <c-f>f /\v<c-r><c-w>

" begin substitution for word under cursor
nnoremap <c-f>r :%s/\<<c-r><c-w>\>//gc<left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define a mapleader for more key combinations
let mapleader="\<space>"

" write current buffer to disk
nnoremap <leader>w :w<cr>
" close app
nnoremap <leader>q :q<cr>
" write current buffer to disk and close app
nnoremap <leader>x :x<cr>

" save current buffer to disk and source it
nnoremap <silent> <leader>0 :call functions#load_file()<cr>

" close the current buffer
nnoremap <silent> <leader>z :bd<cr>
" switch to next buffer
nnoremap <silent> <tab> :bnext<cr>
" switch to previous buffer
nnoremap <silent> <s-tab> :bprevious<cr>

" switch to left window
nmap <silent> <leader>h :wincmd h<cr>
" switch to top window
nmap <silent> <leader>k :wincmd k<cr>
" switch to right window
nmap <silent> <leader>l :wincmd l<cr>
" switch to bottom window
nmap <silent> <leader>j :wincmd j<cr>

" increment window width
nnoremap <silent> <leader>= :vertical resize +5<cr>
" decrement window width
nnoremap <silent> <leader>- :vertical resize -5<cr>
" increment window height
nnoremap <silent> <leader>+ :resize +5<cr>
" decrement window height
nnoremap <silent> <leader>_ :resize -5<cr>

" trim trailing whitespace
nmap <leader>zz :call  normal#trim()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lsp: jump to the declaration of the symbol under the cursor
nnoremap <silent> gd :lua vim.lsp.buf.declaration()<cr>
" lsp: jump to the definition of the symbol under the cursor
nnoremap <silent> <c-]> :lua vim.lsp.buf.definition()<cr>
" lsp: display hover information about the symbol under the cursor
nnoremap <silent> K :lua vim.lsp.buf.hover()<cr>
" lsp: list all implementations for the symbol under the cursor
nnoremap <silent> gD :lua vim.lsp.buf.implementation()<cr>
" lsp: display signature information under the cursor
nnoremap <silent> <c-k> :lua vim.lsp.buf.signature_help()<cr>
" lsp: jump to the definition of the type of the symbol under the cursor
nnoremap <silent> 1gD :lua vim.lsp.buf.type_definition()<cr>
" lsp: list all references to the symbol under the cursor in the quickfix list
nnoremap <silent> gr :lua vim.lsp.buf.references()<cr>
" lsp: list all symbols in the current buffer in the quickfix list
nnoremap <silent> g0 :lua vim.lsp.buf.document_symbol()<cr>
" lsp: list all symbols in the current workspace in the quickfix list
nnoremap <silent> gW :lua vim.lsp.buf.workspace_symbol()<cr>
" lsp: get the next diagnostic closest to the cursor
nnoremap <silent> gn :lua vim.lsp.buf.workspace_symbol()<cr>
" lsp: get the previous diagnostic closest to the cursor
nnoremap <silent> gp :lua vim.lsp.buf.workspace_symbol()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" telescope: search all currently open file buffers
nnoremap <silent> <leader>fb :Telescope buffers<cr>
" telescope: search all currently open file buffers
nnoremap <silent> <leader>ff :lua R('remote.telescope').current_buffer()<cr>
" telescope: search files available in the current directory
nnoremap <silent> <leader><leader> :lua R('remote.telescope').search_cwd()<cr>
" telescope: search git files available in the current directory
nnoremap <silent> <leader>fg :lua R('remote.telescope').git_files()<cr>
" telescope: search files available in dotfiles repository
nnoremap <silent> <leader>fd :lua R('remote.telescope').search_dotfiles()<cr>
" telescope: open file browser at current directory
nnoremap <silent> <leader>fe :lua R('remote.telescope').file_browser()<cr>
" telescope: search files available in vim remote plugin directory
nnoremap <silent> <leader>fp :lua R('remote.telescope').installed_plugins()<cr>
" telescope: search files available in vim remote plugin directory
nnoremap <silent> <leader>fh :lua R('remote.telescope').help_tags()<cr>
" telescope: grep files in current directory
nnoremap <silent> <leader>gf :lua R('remote.telescope').grep_files()<cr>
" telescope: grep all files in current directory
nnoremap <silent> <leader>gg :lua R('remote.telescope').grep_all_files()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define a maplocalleader for more key combinations
let maplocalleader="\\"

" create/edit file within the current directory
nnoremap <localleader>e :edit <C-R>=expand('%:p:h') . '/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf: search files available in the current directory
nnoremap <localleader>ff :Files<cr>
" fzf: search git files available in the current directory
nnoremap <localleader>fg :GFiles<cr>
" fzf: search all currently open file buffers
nnoremap <localleader>fb :Buffers<cr>

"vim-fugitive: execute git diff
nnoremap <localleader>gd :GVdiff<cr>

"vim-fugitive: execute git status
nnoremap <localleader>gs :Gstatus<cr>

"vim-fugitive: resolve git conflict using left hunk
nnoremap <localleader>gh :diffget //2<cr>

"vim-fugitive: resolve git conflict using right hunk
nnoremap <localleader>gl :diffget //3<cr>
