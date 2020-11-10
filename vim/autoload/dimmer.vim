"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Setup vimade to work inside tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dimmer#init() abort
		autocmd! FocusGained * VimadeUnfadeActive
		autocmd! FocusLost * VimadeFadeActive
endfunction
