" General file that contains commands that are too long or esoteric to be in the main init.vim file.

" Command to decrement numbers by one (on lines that ONLY contain a number); useful for
" editing/cleaning up subtitle files like removing advertising data.
	command!    DECREMENT %s/^\d\{1,4\}$/\=(submatch(0)-1)/g
	cnoreabbrev	decrement :DECREMENT
