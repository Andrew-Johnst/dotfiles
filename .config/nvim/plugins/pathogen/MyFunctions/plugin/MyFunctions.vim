" functions.vim file is used to define general-use functions rather than in the master vimrc file,
" in order to save on space, and compartmentalization.

" General purpose function to prompt for a "Y" or "N" input and return either 1 for yes or 0 for no.
" (There is a builtin function called "confirm()" that can potentially be used instead of this.)
" (Added an option for "Q" to quit the function early, although I don't know how useful this will be
" since this Confirm function was written to be called by other custom functions anyways).
	function Confirm(msg)
		echo a:msg . ' '
		let l:answer = nr2char(getchar())

		if l:answer ==? 'y'
			redraw
			echo a:msg . ' ' . l:answer
			echo "[Y]es input received.\n"
			return 1
		elseif l:answer ==? 'n'
			redraw!
			echo a:msg . ' ' . l:answer
			echo "[N]o input received.\n"
			return 0
		elseif l:answer ==? 'q'
			redraw
			echo a:msg . ' ' . l:answer
			echo "[Q]uit option was given..."
			echo "Exiting...\n"
			return 0
		else
			echo "\n"
			redraw
			echo 'Invalid Option Chosen: ' . l:answer
			"echo 'Press [Y]es or [N]o:'
			return Confirm(a:msg)
		endif
	endfunction

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

" Function to add executable permissions to the file that is opened in the current vim-buffer.
	fu! CHMODX()
		" Silently executes chmod command to add execute permissions to file in current vim-buffer.
		silent! execute "!chmod +x ".expand('%:p')
	endfu

" Command abbreviations for simplicity/brevity.
	cnoreabbrev chx silent! call CHMODX()
	cnoreabbrev chmx silent! call CHMODX()
	cnoreabbrev chpx silent! call CHMODX()
	cnoreabbrev chmpx silent! call CHMODX()

" Function for bash script file preamble info.
	function! BashHeaders(...)
		execute "norm I#!/usr/bin/env bash"
		exe "normal o#".expand('%:p')
		exe "normal o#"
		exe "normal o# "
	" Writes the file, then reloads the buffer applying filetype settings.
		w | e
	" Adds executable permissions to the file.
		silent! execute "!chmod +x ".expand('%:p')
		startinsert!
	endfunction
	cnoreabbrev bashhead silent! call BashHeaders()
	cnoreabbrev bh silent! call BashHeaders()

" Function for python3 script file preamble info.
	function! Python3Headers(...)
		execute "norm I#!/usr/bin/env python3"
		"exe "normal o#".expand('%:p')
		exe "normal o# Written by: Andrew Johnston."
		exe "normal o# "
	" Writes the file, then reloads the buffer applying filetype settings.
		w | e
	" Adds executable permissions to the file.
		silent! execute "!chmod +x ".expand('%:p')
		startinsert!
	endfunction
	cnoreabbrev py3head silent! call Python3Headers()
	cnoreabbrev p3h silent! call Python3Headers()

" Command + abbreviation to delete the file open in current tab, as well as a 'purge all' option.
"	(Too braindead to figure out right now, come back to this later).
	function DeleteCurrentOpenFile()
		" Commenting this below section out that uses the built-in confirm() function and uses the
		" Confirm() function defined at the top of this file.
		let l:confirm = Confirm("Confirm to delete and close file currently open [Y/N]:")
		if l:confirm == 1
			echom "Deleting and closing the current file..."
			sleep 1
			silent! exe "call delete(expand('%:p'))"
			silent! exe "bdelete!"
		"elseif l:confirm == 0
		else
			echom "Not deleting current file..."
		endif
		"		let l:confirmchoice = confirm("Confirm to delete this current file:", "&Yes\n&No", 2)
		"		if l:confirmchoice == 1
		"			silent! exe "call delete(expand('%:p')) | bdelete!"
		"			"cnoreabbrev deletecurrentfile silent! exe "call delete(expand('%:p'))"
		"		elseif l:confirmchoice == 2
		"			echom "Not deleting current file."
		"		else
		"			echoerr "Invalid key pressed.\nNot deleting any file."
		"		endif
	endfunction
	cnoreabbrev kms call DeleteCurrentOpenFile()



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
	cnoreabbrev	convpdf 			call Pan("pdf") <CR>
	cnoreabbrev	convhtml 			call Pan("html")<CR>
	nnoremap	<Leader>p				call Pan("pdf") <CR>
	nnoremap	<Leader>h				call Pan("html")<CR>

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
"fu! NewTempFile(...)
"	try
"		if exists(a:, 1) & get(a:, 1) != 0
"			let l:filename = get(a:, 1)
"			let l:succeed = 1
"		"if !exists(l:filename)
"		elseif !exists(l:filename)
"			redir => {l:filename}
"			date "+%m-%d-%Y_%H-%M"
"			redir end
"			let l:succeed = 1
""		else
""			let l:succeed = 0
"		endif
"	finally
"		let l:errormsg = "Improper syntax or invalid filename given, one or or too many arguments "	\
"		. "passed. Only one or zero arguments should be passed to this function; if none are passed, "	\
"		. "then the filename will default to the date in the format of: " \
"		. "'MM-DD-YYY_HH:MM[.fileextension (if applicable)]'\n"
"		if !exists("l:succeed")
"			echo "Errors encountered!\n" . l:errormsg . "Exiting without making the tmp file..."
"		elseif
"			exe "e /tmp/nvim-temporary_files/".expand(l:filename)
"		endif
"	endtry
"endfunction

fu! NewTempFile(...)
	" Assign the current date and time to a variable to be used for default filename, and assigns the
	" directory path name to a variable.
	let l:datetime = system("date '+%m-%d-%Y_%l-%M-%S%p'")
	let l:filename = "tempfile_" . l:datetime
	let l:directory = "/tmp/vim-tmpfiles/"

	" Checks if '/tmp/vim-tmpfiles/' directory exists, create it if not.
"	if !exists(glob('/tmp/vim-tmpfiles/'))
"		let l:choice = Confirm("The directory '/tmp/vim-tmpfiles/' does not exist.\nWould you like to create it now [Y/N]: ")
"		if l:choice == 1
"			echo "Creating directory: " . l:directory . "..."
"			exe "!mkdir " . l:directory
"		else
"			echo "Not creating directory: " . l:directory . "...\nExiting..."
"			sleep 5
"			echoerr "The " . l:directory . " does not exist and was not created so this function is aborting early."
"		endif
"	endif
	silent exe "!mkdir " . l:directory
	"echo l:directory . l:filename | return 0
	"echo get(a:, 0)
	echo get(a:, 0)
	echo get(a:, 1)
	echo get(a:, 2)
	return 0

	" Checks if argument(s) are given. Multiple arguments are concatenated into one variable (in case
	" the filename desired has spaces in it) and uses that variable as the filename. If no
	" arguments--or arguments containing POSIX-illegal characters--the filename will be set to the
	" current date and time.
	if get(a:, 0) > 0
		let l:filename = get(a:, 1)
		"exe "e " . l:directory . l:filename
		echom "AAAA"
	else
		echom "Default filename will be used in the format of: <MM-DD-YYYY___HH-MM-SS> in the" \
					\ "'/tmp/vim-tmpfiles/' directory."
		let l:filename = "/tmp/nvim-tempfiles/" . l:filename
		echom l:filename
		echom "BBBB"
		"exe "norm :e " . l:directory . l:filename
		"echo "e " . l:directory . l:filename
	endif
endfu!
command -nargs=? NTF call NewTempFile(<f-args>)
cnoreabbrev ntf NTF

"" Function to capitalice the first letter of each word highlighted (GRAMATICALLY-CORRECT).


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The below function is commented out as it needs to be fleshed out and a more simple one is used. "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"fu! Test(...)
"	echo get(a:, 0) . "\n\n"
"	echo "Arg 1 = " . get(a:, 1) . "\n"
"	echo "Arg 2 = " . get(a:, 2) . "\n"
"	echo "Arg 3 = " . get(a:, 3) . "\n"
"	if get(a:, 0) > 0
"		echo "Arguments given."
"		let l:filename = get(a:, 1)
"	else
"		echo "No arguments given.\nDefault filename of current date will be used."
"		let l:filename = "/tmp/nvim-tempfiles/" . system("date '+%m-%d-%Y_%H-%M-%S'")
"		echo l:filename
"	endif
"	if l:filename == "abc"
"		echo "Success"
"	else
"		echo "Fail"
"	endif
"endfu
"command -nargs=1 NTF call NewTempFile(<args>)
" Calling a function with <q-args> takes any and all arguments and assigns them into a:1, whereas
" <f-args> splits at spaces/CRs/Tabs and assigns the value into the next a:X variable.
"command -nargs=* Test call Test(<q-args>)
"command -nargs=* Test call Test(<q-args>)
"cnoreabbrev test Test

" Copy paste of test function.
"	fu! Test(...)
"		"echo "a:0 is: " . a:0 . "\na:1 is: " . a:1 . "\na:2 is: " . a:2 . "\na:000 is: " . a:000
"		"echo "a:0 is: " . a:0 . "\na:1 is: " . a:1
"		"let l:list = a:000
"		"echo "\na:000 is: " . type(l:list)
"		"echo "\na:000 is: " . type(a:000)
"		echo get(a:, 0) . "\n\n"
"		echo "Arg 1 = " . get(a:, 1) . "\n"
"		echo "Arg 2 = " . get(a:, 2) . "\n"
"		echo "Arg 3 = " . get(a:, 3) . "\n"
"		if get(a:, 0) > 0
"			echo "Arguments given."
"			let l:filename = get(a:, 1)
"		else
"			echo "No arguments given.\nDefault filename of current date will be used."
"			let l:filename = "/tmp/nvim-tempfiles/" . system("date '+%m-%d-%Y_%H-%M-%S'")
"			echo l:filename
"		endif
"		if l:filename == "abc"
"			echo "Success"
"		else
"			echo "Fail"
"		endif
"	endfu
"	"command -nargs=1 NTF call NewTempFile(<args>)
"	" Calling a function with <q-args> takes any and all arguments and assigns them into a:1, whereas
"	" <f-args> splits at spaces/CRs/Tabs and assigns the value into the next a:X variable.
"	"command -nargs=* Test call Test(<q-args>)
"	command -nargs=* Test call Test(<f-args>)
"	cnoreabbrev test Test

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
