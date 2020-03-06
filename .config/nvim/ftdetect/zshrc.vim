" Commenting out for now, vim got really glitchy for some reason after changin this ftdetect file.


"	augroup autocommit
"		autocmd!
"		" Executes the command on quit
"		" Prolly broken version, don't know how to do system/shell calls.
"		"		autocmd VimLeave *.zshrc system(source '~/.zshrc')
"				autocmd VimLeave *.zshrc !zrcr
"	
"		" Execute the command on write (not used for zshrc).
"			autocmd BufWritePost,FileWritePost *.zshrc system(source '~/.zshrc')
"	augroup END
