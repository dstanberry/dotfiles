"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load custom lua scripts/functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
lua << EOF
require('remote.telescope')
EOF
endif
