" (For whatever reason, this file does not want to automatically set the Vim's: ":formatoptions"
" settings

" Functions.vim file is used to define general-use functions rather than in the master vimrc file,
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

" Function to act as a 'helper' function for other vimscript functions. This function will allow for
" text wrapping with whatever text is passed to the function will be the text to be wrapped
" [Taken from this stackexchange post]:
" 	https://vi.stackexchange.com/questions/4612/is-there-a-vimscript-function-to-wrap-text
"function! WrapText(...)
"			" Check if there were any arguments even given in the first place; if not then do nothing since
"			" there is no text to even wrap. If so, then proceed to check for the second (and third)
"			" argument(s).
"			if (len(a:000) == 0)
"				let l:TextWidth=&l:textwidth
"				echom l:TextWidth
"		
"			endif
"			"echom len(a:000)
"			"echo "\n"
"			"echo a:000
"			"echom &l:textwidth
"			"echom l:textwidth
"			"echo a:0
"			"echo "A"
"			" Check if the second argument is an integer or not (if so, just for edge-cases where the second
"			" word of a string may be a number, assume it to be an integer but proceed to check the third
"			" argument for an integer value--if that is true, then perform more checks)
"
"		
"	function! WrapText(text, width, indent)
"			let l:line = ''
"			let l:ret = ''
"		
"			"for word in split(a:text)

"	  let l:line = ''
"	  let l:ret  = ''
"	
"	  for word in split(a:text)
"	
"	    if len(l:line) + len(word) + 1 > a:width
"	
"	       if len(l:ret)
"	          let l:ret .= "\n"
"	       endif
"	       let l:ret .=  repeat(' ', a:indent) . l:line
"	
"	       let l:line = ''
"	
"	    endif
"	
"	    if len (l:line)
"	       let l:line .= ' '
"	    endif
"	
"	    let l:line .= word
"	
"	  endfor
"	
"	  let l:ret .= "\n" . repeat(' ', a:indent) . l:line
"	
"	  return l:ret

"endfunction!
"command -nargs=? WrapText call WrapText(<f-args>)
"command -nargs=? WrapText :silent call WrapText(<f-args>)
"cnoreabbrev wt WrapText

" Function to determine whether or not there are any open files in current vim buffer (@%), if so
" then open file in current tab, if not then open in a new tab.
function! OpenFileInNextAvailableBuffer(filename)
	if @% == ""
		execute "e " . a:filename
	else
		execute "tabnew " . a:filename
	endif
endfunction!
" Creating a command to allow parameters to be passed to the function, then abbreviating the above
" function.
	"command! -nargs=*	-complete=command OFINTAB call OpenFileInNextAvailableBuffer(<args>)
	command! -nargs=1 -complete=file OFINTAB call OpenFileInNextAvailableBuffer(<f-args>)
	cnoreabbrev OFINTAB OFINTAB

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
	" (Temporary) Jumps to beginning of file, then jumps to next typo, opens list of suggestions and
	" waits for yes or no,
	endfunction
	cnoreabbrev	ssc	call SuperSpellCheck()

" Function to add executable permissions to the file that is opened in the current vim-buffer.
	fu! CHMODX()
		" Silently executes chmod command to add execute permissions to file in current vim-buffer.
		silent! execute "!chmod +x ".expand('%:p')
	endfu!

" Command abbreviations for simplicity/brevity.
	cnoreabbrev chx silent! call CHMODX()
	cnoreabbrev chmx silent! call CHMODX()
	cnoreabbrev chpx silent! call CHMODX()
	cnoreabbrev chmpx silent! call CHMODX()

" Function for bash script file preamble info.
	function! BashHeaders(...)
		execute "norm I#!/usr/bin/env bash"
		execute "normal o#".expand('%:p')."\r#\r# "
		" Figured this out [5-5-2022 2:10PM] on how to insert a commented out line containing the opened
		" file in the buffer.
		" Writes the file, then reloads the buffer applying filetype settings.
		w | e | redraw
	" Adds executable permissions to the file.
		silent! execute "!chmod +x ".expand('%:p')
		startinsert!
	endfunction!
	cnoreabbrev bashhead silent! call BashHeaders()
	cnoreabbrev bh silent! call BashHeaders()

" Function for python3 script file preamble info.
	function! Python3Header(...)
			execute "norm I#!/usr/bin/env python3"
					"	exe "normal o# Written by: Andrew Johnston." exe "normal o# <c-o>"
			execute "normal o#".expand('%:p')."\r#\r# "
			startinsert! 
		" Writes the file, then reloads the buffer applying filetype settings.
			w | e | redraw
		" Adds executable permissions to the file.
			silent! execute "!chmod +x ".expand('%:p')
			startinsert!
		endfunction!

		"command! P3H silent! call Python3Header(<f-args>)
		"command :P3H silent! call Python3Heades(<f-args>)
		"command! P3H silent call Python3Header()
		"command! -nargs=* PY3H call Python3Header(<f-args>)
		"cnoreabbrev py3 P3H(<f-args>)
			"echo "e " . l:directory . l:filename

"command -nargs=? NTF call NewTempFile(<f-args>)
"cnoreabbrev ntf NTF(<f-args>)

" Function that inserts a specified character for selected text that can do one of these options:
" [Underline, Insert a line of the specified character above the selected text, or fully encapsulate
" the selected text (above and below)].
function! CHARACTERENCAPSULATE(...)
	silent echom 
endfunction!


"##################################################################################################"
"##################################################################################################"
"##################################################################################################"
"###################### Testing and Commented-Out (or Non-Working) Functions ######################"
"##################################################################################################"
"##################################################################################################"
"##################################################################################################"


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

function TESTING(...)
	let l:datetime = system("date '+%m-%d-%Y_%l-%M-%S%p'")	"Contains date with seconds with AM/PM.
	let l:filename = "tempfile_" . l:datetime
	echo l:filename
endfunction!
command -nargs=? TESTING call TESTING(<f-args>)
cnoreabbrev test TEST

" Function--and command--to create a new "temporary" file in the [/tmp/tempfiles/] directory, which
" is the same directory as the zsh aliasrc alias for creating new tempfiles.
"fu! tempfile(...)
"	let l:

"" Function to capitalice the first letter of each word highlighted (GRAMATICALLY-CORRECT).
"
"
" Function--and command--to create a new "temporary" file in the [/tmp/tempfiles/] directory, which
" is the same directory as the zsh aliasrc alias for creating new tempfiles.
"fu! tempfile(...)
"	let l:

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
