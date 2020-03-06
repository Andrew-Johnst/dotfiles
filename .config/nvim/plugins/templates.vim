" I am far too braindead as of writing this to actually go and make the
" changes, but just at a glance I can tell how piss poor this is managed,
" but very tired and still new at functional programming.

function! TemplateFunction(...)
	if(a:0 == 0)
		echom "At least two parameters are needed (The language, and either header or template.)"
		echom " "
		echom "Usage: 'tfu [language {b(ash),c,python2(p2),python3(p3)}], [h(eader)|t(emplate)] [template #]"
		echom "(If using templates, a template number can be specified, 0 as default."
		return
	endif

	" Set the language
	if(a:1 == "python2" || a:1 == "p2")
		let s:ftype = ".py"
		let s:fdir = "python2/"

	elseif(a:1 == "python3" || a:1 == "p3")
		let s:ftype=".py"
		let s:fdir = "python3/"

	elseif(a:1 == "bash" || a:1 == "b")
		let s:ftype == ""
		let s:fdir = "bash/"

	elseif(a:1 == "c")
		let s:ftype == ".c"
		let s:fdir = "c/"
	endif

	" Set header or template, and template version.
	if(a:2 == "header" || a:2 == "h")
		let s:filename = "header" . s:ftype
	elseif(a:2 == "template" || a:2 == "t")
		if(a:0 > 2)
			let s:filename = "template_" . a:3 . s:ftype
		else
			let s:filename = "template_0" . s:ftype
		endif
	endif

	let s:filepath = "~/.config/nvim/templates/" . s:fdir . s:filename

	echom s:filepath

endfunction
" echom a:0 		a:0 contains an integer which is the number of arguments passed to the function
" echom a:1			a:1 contains the first argument passed, a:2 contains the second and so on
" echom a:000		a:000 contains a list of all arguments that were passed to the function

" Inserts filepath of file current loaded into operating vim buffer.
" :put =expand('%:p')
"
