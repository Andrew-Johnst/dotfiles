" Testing this hope it work.
augroup vimformatting
	autocmd!
	au BufEnter,BufRead,BufNewFile *.vim	setfiletype vim
	au BufEnter,BufRead,BufNewFile *.vim	setlocal formatoptions=crt
augroup END
