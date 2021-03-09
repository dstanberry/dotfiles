""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Prettier Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" disable auto formatting of files with '@format' tag
let g:prettier#autoformat = 0

" always execute asynchonously
let g:prettier#exec_cmd_async = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" max line length that prettier will wrap on
let g:prettier#config#print_width = 80

" number of spaces per indentation level
let g:prettier#config#tab_width = 4

" use tabs over spaces
let g:prettier#config#use_tabs = 'true'

" define default parser
let g:prettier#config#parser = 'babylon'

" print semicolons
let g:prettier#config#semi = 'true'

" single quotes over double quotes
let g:prettier#config#single_quote = 'false'

" print spaces between brackets
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line = 'true'

" avoid|always
let g:prettier#config#arrow_parens = 'always'

" none|es5|all
let g:prettier#config#trailing_comma = 'none'
