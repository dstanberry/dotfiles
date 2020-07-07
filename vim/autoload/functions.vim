"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ad hoc definitions for (neo)vim settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#neoviminit() abort
	if !has('nvim')
		set viminfo='10,\"100,:20,%,n${VIM_CONFIG_HOME}/viminfo
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading of expensive operations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#idleboot() abort
	" make sure functions#idleboot is called only once.
	augroup DeferInit
		autocmd!
	augroup END

	" make sure deferred tasks are run exactly once.
	doautocmd User LazyLoad
	autocmd! User LazyLoad
endfunction

function! functions#defer(evalable) abort
	if has('autocmd') && has('vim_starting')
		execute 'autocmd User LazyLoad ' . a:evalable
	else
		execute a:evalable
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => String Substitution
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#substitute(pattern, replacement, flags) abort
	let l:number=1
	for l:line in getline(1, '$')
		call setline(l:number, substitute(l:line, a:pattern, a:replacement, a:flags))
		let l:number=l:number + 1
	endfor
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Restore Cursor Position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#rescursor()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File Metadata
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#readOnly() abort
	if &readonly || !&modifiable
		return 'RO,'
	else
		return ''
	endif
endfunction

function! functions#getFileType() abort
	if strlen(&ft)
		return &ft
	else
		return ''
	endif
endfunction

function! functions#getFilePath() abort
	return expand('%:p:h')
endfunction

function! functions#getRelativeFilePath() abort
	let path = expand('%:h')
	if (path == '.')
		return ''
	elseif (path == '')
		return ''
	else
		return path . '/'
endfunction

function! functions#getFileFormat() abort
	let format = ''
	let encoding = ''
	if strlen(&ff) && &ff !=# 'unix'
		let format = &ff
	endif
	if strlen(&fenc) && &fenc !=# 'utf-8'
		let encoding = &fenc
	endif

	if format != '' && encoding != ''
		return ',' . join([format, encoding], ',')
	elseif format == '' && encoding == ''
		return ''
	else
		return ',' . format . encoding
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color Manipulation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:patterns = {}
let s:patterns['hex']      = '\v#?(\x{2})(\x{2})(\x{2})'
let s:patterns['shortHex'] = '\v#(\x{1})(\x{1})(\x{1})'

function! functions#RGBtoHex (...)
	let [r, g, b] = ( a:0==1 ? a:1 : a:000 )
	let num = printf('%02x', float2nr(r)) . ''
			\ . printf('%02x', float2nr(g)) . ''
			\ . printf('%02x', float2nr(b)) . ''
	return '#' . num
endfunction

function! functions#HexToRGB (color)
	if type(a:color) == 2
		let color = printf('%x', a:color)
	else
		let color = a:color | end

	let matches = matchlist(color, s:patterns['hex'])
	let factor  = 0x1

	if empty(matches)
		let matches = matchlist(color, s:patterns['shortHex'])
		let factor  = 0x10
	end

	if len(matches) < 4
		echohl Error
		echom 'Couldnt parse ' . string(color) . ' ' .  string(matches)
		echohl None
		return | end

	let r = str2nr(matches[1], 16) * factor
	let g = str2nr(matches[2], 16) * factor
	let b = str2nr(matches[3], 16) * factor

	return [r, g, b]
endfunction

function! functions#Lighten(color, ...)
	let amount = a:0 ?
				\(type(a:1) < 2 ?
					\str2float(a:1) : a:1 )
				\: 5.0

	if(amount < 1.0)
		let amount = 1.0 + amount
	else
		let amount = 1.0 + (amount / 100.0)
	end

	let rgb = functions#HexToRGB(a:color)
	let rgb = map(rgb, 'v:val * amount')
	let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
	let rgb = map(rgb, 'float2nr(v:val)')
	let hex = functions#RGBtoHex(rgb)
	return hex
endfunction

function! functions#Darken(color, ...)
	let amount = a:0 ?
				\(type(a:1) < 2 ?
					\str2float(a:1) : a:1 )
				\: 5.0

	if(amount < 1.0)
		let amount = 1.0 - amount
	else
		let amount = 1.0 - (amount / 100.0)
	end

	if(amount < 0.0)
		let amount = 0.0 | end

	let rgb = functions#HexToRGB(a:color)
	let rgb = map(rgb, 'v:val * amount')
	let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
	let rgb = map(rgb, 'float2nr(v:val)')
	let hex = functions#RGBtoHex(rgb)
	return hex
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Check file for disk changes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#checkFile(timer)
	silent! checktime
	call timer_start(1000, 'functions#checkFile')
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Base64 Encoding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! functions#str2bytes(str)
	return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! functions#b64encode(str)
	let s:b64_table = [
		\ "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
		\ "Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f",
		\ "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v",
		\ "w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"]
	let bytes = functions#str2bytes(a:str)
	let b64 = []
	
	for i in range(0, len(bytes) - 1, 3)
		let n = bytes[i] * 0x10000
			\ + get(bytes, i + 1, 0) * 0x100
			\ + get(bytes, i + 2, 0)
		call add(b64, s:b64_table[n / 0x40000])
		call add(b64, s:b64_table[n / 0x1000 % 0x40])
		call add(b64, s:b64_table[n / 0x40 % 0x40])
		call add(b64, s:b64_table[n % 0x40])
	endfor

	if len(bytes) % 3 == 1
		let b64[-1] = '='
		let b64[-2] = '='
	endif

	if len(bytes) % 3 == 2
		let b64[-1] = '='
	endif

	return join(b64, '')
endfunction


