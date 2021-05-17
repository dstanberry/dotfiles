" recognize vim-plug
syntax keyword Function Plug

" recognize autloaded function names
syntax match vimAutoloadFuncName '\v(\w*)(#\w*)+' containedin=ALL

" highlight settings
hi def link vimAutoloadFuncName Function
