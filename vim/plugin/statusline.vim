" initialize statusline
set statusline=
" mode indicator
set statusline+=%#NormalMode#%{(mode()=='n')?'\ \ N\ ':''}
set statusline+=%#InsertMode#%{(mode()=='i')?'\ \ I\ ':''}
set statusline+=%#ReplaceMode#%{(mode()=='R')?'\ \ R\ ':''}
set statusline+=%#VisualMode#%{(mode()=='v')?'\ \ V\ ':''}
" Read-only indicator
set statusline+=%3*\ %{functions#readOnly()}
" relative file path
set statusline+=%1*\ %{functions#getRelativeFilePath()}
" filename
set statusline+=%2*%t%*
" right-hand side
set statusline+=%=
" file encoding (only show when dos)
set statusline+=%1*\ %{&ff!='unix'?'['.&ff.']':''}\ 
" file format
"set statusline+=\ (%{&ff})\ 
" line/column numbering
set statusline+=%4*\ ℓ\ %l\ с\ %c\ %3p%%\ 