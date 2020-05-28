" initialize statusline
set statusline=
" mode indicator
set statusline+=%7*%{(mode()=='n')?'\ \ N\ ':''}
set statusline+=%6*%{(mode()=='i')?'\ \ I\ ':''}
set statusline+=%8*%{(mode()=='R')?'\ \ R\ ':''}
set statusline+=%9*%{(mode()=='v')?'\ \ V\ ':''}
" Read-only indicator
set statusline+=%3*\ %{functions#readOnly()}
" relative file path
set statusline+=%1*\ %{functions#getRelativeFilePath()}
" filename
set statusline+=%2*%t%*
" right-hand side
set statusline+=%=
" file format and encoding (if not unix || utf-8)
set statusline+=%5*\ %{functions#getFileFormat()}\ 
" line/column numbering
set statusline+=%4*\ ℓ\ %l\ с\ %c\ %3p%%\ 