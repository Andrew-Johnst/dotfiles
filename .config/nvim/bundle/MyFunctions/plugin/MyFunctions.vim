" functions.vim file is used to define general-use functions rather than in the master vimrc file, in order to
" save on space, and compartmentalization.

" Function to return true if checking for the directory passed as the argument exists.
	function! FileOrFolderExists(...)
	if a:0 >= 1
		try
				if a:1 =~! '^[-]\{1,2\}[file|directory|help]\{1,\}'
					let l:Errors = "Invalid argument: \"" . get(a:, 1) . "\""
					throw l:Error = 1
				elseif a:1 =~ '^[-]\{1,2\}[file]\{1,\}' && !empty(glob(get(a:, 2)))
					let l:Filename = get(a:, 2)
					return !empty(glob(l:Filename))
				elseif a:1 =~ '^[-]\{1,2\}[directory]\{1,\}' && !empty(glob(get(a:, 2)))
					let l:DirectoryName = get(a:, 2)
					return !empty(glob(l:DirectoryName))
				elseif a:1 =~ '^[-]\{1,2\}[help]\{1,\}'
					throw l:Showusage = 1

				"elseif a:1 =~ '^[-]\{1,2\}[file|directory|help]\{1,\}'

					"echom get(a:, 1)
					"throw l:error = 0
					"if a:1 =~ '^[-]\{1,2\}[f|d|h|file|directory|help]\{1,\}'
				endif
			endtry
		endif
	endfu!

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
		#!/usr/bin/env bash
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
	cnoreabbrev bashhead silent! call BashHeaders()
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

" Function to display the current foldername fullpath (basically just 100<C-g> and strips everything
" after the last forward-slash).

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
	command -nargs=0 -complete=command NL silent! execute "setlocal number!|setlocal relativenumber!"
	cnoreabbrev nl :NL
	map <Leader>nl :nl<CR>

" Command to open a new file in /tmp/nvim-temporary_files directory with the filename equal to the
" first command argument. If no argument is given then the current date and time in the format of:
" 'MM-DD-YYY_HH:MM[.fileextension (if applicable)]'
fu! NewTempFile(...)
	try
		if exists("a:1")
			let l:filename = get(a:, 1)
			let l:succeed = 1
		"if !exists(l:filename)
		elseif !exists("l:filename")
			redir => {l:filename}
			date "+%m-%d-%Y_%H-%M"
			redir end
			let l:succeed = 1
"		else
"			let l:succeed = 0
		endif
	finally
		let l:errormsg = "Improper syntax or invalid filename given, one or or too many arguments "	\
		. "passed. Only one or zero arguments should be passed to this function; if none are passed, "	\
		. "then the filename will default to the date in the format of: " \
		. "'MM-DD-YYY_HH:MM[.fileextension (if applicable)]'\n"
		if !exists("l:succeed")
			echo "Errors encountered!\n" . l:errormsg . "Exiting without making the tmp file..."
		elseif
			exe "e /tmp/nvim-temporary_files/".expand(l:filename)
		endif
	endtry
endfunction

command -nargs=1 NTF call NewTempFile(<args>)
cnoreabbrev ntf :NTF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The below function is commented out as it needs to be fleshed out and a more simple one is used. "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	fu! NewTempFile(l:filename)
"		let l:helpmessage = "A '-d' for default/date filename, '-h' to display this message, or '-f'" \
"		. " followed by the desired filename to name the filename with the variable directly" \
"		. " proceeding the \ '-f' argument option."
"
"		if l:filename = "-d"
"			" Testing to see if this solution works using 'redir => {var}' to route output of shell
"			" command into variable.
"			redir => {l:filename}
"			date "+%m-%d-%Y_%H-%M"
"			redir end
