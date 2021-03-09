"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load custom lua scripts/functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
lua << EOF
require('plugin.telescope')
EOF
endif
