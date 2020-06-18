" functions.vim file is used to define general-use functions rather than in the master vimrc file, in order to
" save on space, and compartmentalization.

" Function to determine whether or not there are any open files in current vim buffer (@%), if so then open file in
" current tab, if not then open in a new tab.

		function! OpenFileInNextAvailableBuffer(filename)
			if @% == ""
				execute "e " . a:filename
			else
				execute "tabnew " . a:filename
			endif
		endfunction

" Enables spellcheck if disabled, moves cursor to next typo, asks if it should be changed to the first
" spellcheck recommendation, then moves to the next one until an <Esc> key is pressed.
	function SuperSpellCheck()
	" Redirects output into x variable (only way to do this afaik).
		redir => x
		silent execute "setlocal spell?"
		redir END
	" Evaluates spell option value, enables if disabled.
		if x == "nospell"
			" silent setlocal spell
		else
			echo "Apparently x != \"nospell\", and has val of: " . x
		endif
	" (Temporary) Jumps to beginning of file, then jumps to next typo, opens list of suggestions and waits for
	" yes or no,
	endfunction
	cnoreabbrev	ssc	call SuperSpellCheck()

" Function for bash script file preamble info.
	function! BashHeaders(...)
		"let l:filename=@%
		"while !exists(l:filename)
		"	let l:filename = input("No/Invalid filename detected.\nPlease enter a filename: ")
		"	if !matchstr(l:filename,'^[0-9a-zA-Z/\s]+')
		"		echom "The filename entered does not match the regex pattern."
		"	else
		"		let l:filename = substitute(l:filename, " ", "\ ", "g")
		"		execute "w " . l:filename
		"	endif
		"endwhile

		execute "norm I#!/usr/bin/env bash"
		"if exists(%@)
		"	exe "normal! o#".expand('%:p')
		"else
		"	exe "normal o"
		"endif
		exe "normal o#".expand('%:p')
		exe "normal o"
		exe "normal o# "
	" Writes the file, then reloads the buffer applying filetype settings.
		w | e
	" Adds executable permissions to the file.
		silent! execute "!chmod +x ".expand('%:p')
		startinsert!
		"if exists(l:comment)
		"	execute "normal! o# " | startinsert!
		"else
		"	execute "norm o " | startinsert!
		"endif

	endfunction
	"cnoreabbrev bashheadcomment call BashHeaders("comment")
	"cnoreabbrev bhc call BashHeaders("comment")
	cnoreabbrev bashhead call BashHeaders()
	cnoreabbrev bh silent! call BashHeaders()

" Command + abbreviation to delete the file open in current tab, as well as a 'purge all' option.
"	(Too braindead to figure out right now, come back to this later).

	"	cnoreabbrev <silent>	:exe 'call delete(expand('%'))'
	"	exe 'call delete(expand('%')) | bdelete!'

" Function to surround word in cursor with either single or double quotes.

" Function to insert the full filepath at the cursor prepended with a # just so it's easier
	function InsertFilePath()
		if (getline('.') != "")
			normal o
		endif
		exe "normal! I#".expand('%:p')
	endfunction


" Function to flash a pair of cross-hairs on the cursor for 100ms.
	function Flash()
		set cursorline cursorcolumn
		redraw
		sleep 100m
		set nocursorline nocursorcolumn
	endfunction

" Function to run pandoc command to compile the file open in current buffer in either HTML5 or PDF.
		function! Pan(type)
			if !exists(l:type)
				if(l:type == "html")
					silent execute "!pandoc " . @% . " -t html5 -o " . expand('%:r') . ".html"
				elseif(l:type == "pdf")
					silent execute "!pandoc " . @% . " -t beamer -o " . expand('%:r') . ".pdf"
				endif
			else
				echom "An argument to specify the output type is required (html/pdf)."
			endif
		endfunction
" Aliasing commands to this function to either HTML/PDF formats, then binding them to Leader keybinds.
	cnoreabbrev	pdf 			call Pan("pdf")
	cnoreabbrev	html 			call Pan("html")
	nnoremap	<Leader>p		call Pan("pdf") <CR>
	nnoremap	<Leader>h		call Pan("html")<CR>

" Alias to add executable permissions to file open in current vim buffer.
	command! -nargs=0 -complete=command CX silent! execute "!chmod +x ".expand('%:p')
	cnoreabbrev cx :CX

" Command to disable numberlines by calling the :nonum command
	command -nargs=0 -complete=command NL silent! execute "setlocal number! | setlocal norelativenumber!"
	cnoreabbrev nl :NL
	map <Leader>l :nl<CR>
