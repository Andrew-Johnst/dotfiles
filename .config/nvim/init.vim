"				 __  __          __         _           _   _         __
"				|  \/  |_   _   / /__ _   _| |__       | |_(_) ___ _ _\ \
"				| |\/| | | | | | / __| | | | '_ \ _____| __| |/ _ \ '__| |
"				| |  | | |_| | | \__ \ |_| | |_) |_____| |_| |  __/ |  | |
"				|_|  |_|\__, | | |___/\__,_|_.__/       \__|_|\___|_|  | |
"				        |___/   \_\                                   /_/
"				       _                       __ _ _         __
"				__   _(_)_ __ ___  _ __ ___   / _(_) | ___   / _| ___  _ __
"				\ \ / / | '_ ` _ \| '__/ __| | |_| | |/ _ \ | |_ / _ \| '__|
"				 \ V /| | | | | | | | | (__  |  _| | |  __/ |  _| (_) | |
"				  \_/ |_|_| |_| |_|_|  \___| |_| |_|_|\___| |_|  \___/|_|
"
"							 _   _         __     _____ __  __
"							| \ | | ___  __\ \   / /_ _|  \/  |
"							|  \| |/ _ \/ _ \ \ / / | || |\/| |
"							| |\  |  __/ (_) \ V /  | || |  | |
"							|_| \_|\___|\___/ \_/  |___|_|  |_|
"
"
" My (usually) most up-to-date config file for Vim/neovim, mostly experimental as a learning
" experience for learning and becoming more comfortable using Vim/neovim, trying to put down the GNU
" Nano 'crack-pipe' to learn a better and far-more functional editor.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" Please for the love of god redo the formatting of this dumpsterfire """"""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" [1.0] Plug-ins and Preliminary settings.
" [1.1] Autocommand clearing/insurance. (Clearing autocmd/augroup in case they get double loaded).
	au!

" [1.2] Check if Vim-plug and pathogen are installed for current user and install if not.
	if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	  echo "Downloading Vim-Plug plugin manager for nvim..."
	  silent !mkdir -p ~/.config/nvim/autoload/
	  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
		\	> ~/.config/nvim/autoload/plug.vim
	  autocmd VimEnter * PlugInstall
	endif
" Activates Vim-Pathogen plugin, installs it if not found.
	if ! filereadable(expand('~/.config/nvim/autoload/pathogen.vim'))
	  echo "Downloading Vim-Pathogen plugin manager for neovim..."
	  silent !mkdir -p ~/.config/nvim/autoload/ ~/.config/nvim/bundle
		silent !curl -LSso ~/.config/nvim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	endif
" [1.3] Load plugins:

	" This installs my locally installed 
	execute pathogen#infect('~/.config/nvim/bundle/{}')
	call plug#begin('~/.config/nvim/plugged')
  " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align:
  		Plug 'junegunn/vim-easy-align'
  " Any valid git URL is allowed:
  		Plug 'https://github.com/junegunn/vim-github-dashboard.git'
  " Install Dracula theme:
  		Plug 'dracula/vim',{'name': 'dracula' }
  " Install Nord theme:
  		Plug 'arcticicestudio/nord-vim'
  " Install Hybrid material theme:
  		Plug 'kristijanhusak/vim-hybrid-material'
  " Install palenight plugin:
  		Plug 'drewtempelmeyer/palenight.vim'
	" Install vim-orgmode:
			Plug 'jceb/vim-orgmode'
	" FZF installation seems very bizare, it was already installed, but apt installed it again.
	" Install fzf fuzzy-finder, clone git repo into ~/.fzf directory:
			Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	" Install oceanic-next theme:
			Plug 'mhartington/oceanic-next'
	" Install vim-airline:
	 		Plug 'vim-airline/vim-airline'
  " Install themes for vim-airline:
	 		Plug 'vim-airline/vim-airline-themes'
	" Install Gotham theme.
			Plug 'whatyouhide/vim-gotham'
	" Install vim-surround.
			Plug 'tpope/vim-surround'
	" Install vim-repeat.
			Plug 'tpope/vim-repeat'
	" Install vim-commentary.
			Plug 'tpope/vim-commentary'
	" Install tmuxline for automatic color synchronization to tmux from vim-airline colors.
			Plug 'edkolev/tmuxline.vim'
	" Install Conquer of Completion.
	"		Plug 'neoclide/coc.nvim', {'branch': 'release'}

	call plug#end()

"-----------------------------------[2.0] - Theming and appearance settings.
	"---------------------[2.1] Colorscheme options.
		" Calling the custom theme in colors/lena.vim
			"colorscheme lena

			" Can't think of better to jot down a list of themes I'd like to try out.
			" Wryan, zenburn, One Half Dark, Ollie, spacegray, subliminal, teerb, tomorrow night, tomorrow night
			" eighties, oceanic-next

			" Enables true colors in neovim.
			" 								let $NVIM_TUI_ENABLE_TRUE_COLOR=1

			" Adding this in conjunction with a .tmux.conf tweak from this site:
			" https://github.com/tmux/tmux/issues/1246
			" Enable true color 启用终端24位色
				if exists('+termguicolors')
				  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
				  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
				  set termguicolors
				endif


			colorscheme palenight
			let g:airline_theme = "palenight"
			"let g:palenight_terminal_italics=1
			" Commenting all this out for now while testing out custom colorschemes/themes.
			" colorscheme palenight
			" set background=dark

			" Specific settings for dracula (must be specified in this order or
			" results in visual glitches (or at least in PuTTY-xterm sessions.)

		 	" let g:dracula_colorterm = 0
			" colorscheme dracula
			" let g:dracula_italic = 0
			" colorscheme hybrid_material
			" hi CursorLineNr gui=bold guifg=DarkRed guibg=#c0d0e0

	"---------------------[2.2] Set Terminal colors to xterm-256color for PuTTY SSH connections.
	" Potential fix, attempt 1 of 2.
	"		if exists('+termguicolors')
	"			let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	"			let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	"			set termguicolors
	"		endif
		"	if (has("termguicolors"))
		"		set termguicolors
		"	endif
			"set termguicolors
			"let g:oceanic_next_terminal_bold = 1
			"let g:oceanic_next_terminal_italic = 1
			"colorscheme OceanicNext
	"---------------------[2.3] Vim-Airline config settings.
		"let g:airline_theme='oceanicnext'
		"let g:airline_theme='dracula'
		" Allows vim-airline to use fonts (without this, rectangles appear instead of the expected arrow shapes).
		let g:airline_powerline_fonts = 1
		" Auto command for entering any vim buffer to disable vim-airline whitespace info.
		autocmd VimEnter * silent! AirlineToggleWhitespace
		" Sets the path formatter for tabs so the filepath appears on tabs and current buffer indicator.
		"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
		let g:airline#extensions#tabline#formatter = 'unique_tail'
		let g:airline#extensions#tabline#left_sep = ' '
		let g:airline#extensions#tabline#left_alt_sep = '|'

"							Commenting out vim-airline settings, testing lightline.
"								"---------------------[2.3] Vim-airline configurations:
"									" Palenight theme for vim-airline.
"								  	let g:airline_theme = "palenight"
"								  " Disable trailing whitespace info.
"								  	let g:airline#extensions#whitespace#enabled = 0

"	-----------------------------------[3.0] - Formatting settings.
	"----------------------[3.1] Default and general format settings (Assign tabcount value, shiftwidth, encoding, etc.)
	"		(Filetype format settings for ftplugin have to be in the $VIMRUNTIME/after/ftplugin directory, or they'll be
	" 															overwritten with the global settings specified here).
	" 	(Potential fix by delaying the setting of the syntax until the filetype is finished in ftplugin.)
		filetype plugin on
		set tabstop=4
		set shiftwidth=4
		set textwidth=100
		set foldmethod=manual
		set formatoptions=qc
		set encoding=utf-8

		" Adding this manually since the reloading of vimrc in the buffer overrides format options
		" to the global init.vim settings.
		"autocmd FileType .vim set tabstop=2
		" Sets mouse functionality and system clipboard.
		" Commenting this out for now because <C-v> and <C-c> and general clipboard issues. 5-5-20 10:12PM
		"set mouse=a
		"set clipboard=unnamedplus

	"----------------------[3.2] Syntax/search highlighting.
		syntax on
		set incsearch
		set hlsearch
		set ignorecase
		set smartcase

	"----------------------[3.3] Always show current position.
		set ruler

	"--------------------[3.4] Set number and relativenumber line.
		set relativenumber number

	"----------------------[3.5] Setting to automatically save/load view folds in files.
		autocmd BufWinLeave *.* mkview
		autocmd BufWinEnter *.* silent! loadview

	"--------------------[3.6] Surrounding word in quotes.
	"	command -nargs=1 -complete=command	Dquotes	call SurroundQuotes(t)

	"----------------------[3.7] Filetype templates and headers.
		"--------------------[3.7.1] Defining the functions, commands, and abreviations.
		" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		"	!!! Argument/parameter passing from command to function is broken, use <q-args> or <f-args>. !!!
		" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					command! -nargs=*	-complete=command		Template	call TemplateFunction()
					command! -nargs=*	-complete=command		Header		call TemplateFunction()
			" Abbreviating user-defined commands such that they can be called in lower-case.
					cnoreabbrev	temp	:Template
					cnoreabbrev	head	:Header
		" Adding this here for now since not sure where any other definition/function is written if I even made
		" one.
					command! -nargs=0 -complete=command FilePathHeader call InsertFilePath()
					cnoreabbrev	ifp		:FilePathHeader

"-----------------------------------[4.0] - Quality-of-life improvements
" General-use functions are defined in "~/.config/nvim/bundle/MyFunctions/plugin/MyFunctions.vim" file.
"(The vim command 'scriptnames', prints out the order in which vim files are loaded).
	"--------------------[4.1.0] Shortcutting split navigation.

	" Mapping window movement keys, setting default spawn location of new windows.
		set splitbelow
		set splitright
		map <C-h> <C-w>h
		map <C-j> <C-w>j
		map <C-k> <C-w>k
		map <C-l> <C-w>l

	"--------------------[4.2.0] Mapping Tab management keys.
		map <C-q>						<Nop>
		map <C-q>	:tabclose <CR>
		map <C-t>	:tabnew 	<CR>
		map <M-l>	:tabnext 	<CR>
		map <M-h>	:tabprev	<CR>

	"--------------------[4.3.0] Various command declarations.
    " Command to open zshrc file in new vim tab.
        command!      ZRC :call OpenFileInNextAvailableBuffer("~/.zshrc")
        cnoreabbrev zrc :ZRC

    " Command to open init.vim file in new vim tab.
        command!      NRC :call OpenFileInNextAvailableBuffer("~/.config/nvim/init.vim")
        cnoreabbrev nrc :NRC

    " Command to open aliasrc file in new vim tab.
        command!      ARC :call OpenFileInNextAvailableBuffer("~/.config/zsh/aliasrc")
        cnoreabbrev arc :ARC

    " Command to open functionrc file in new vim tab.
        command!      FRC :call OpenFileInNextAvailableBuffer("~/.config/zsh/functionrc")
        cnoreabbrev frc :FRC

		" Command to write the currently opened file as sudo.
				command!			SudoWrite	:w !sudo tee %

	"--------------------[4.4.0] Leader-key keybinds/settings.
		"-------------------[4.4.1] Unmap default spacebar keybind, then map it to leader key.
			nnoremap <Space> <nop>
			let mapleader=" "

		"-------------------[4.4.1] Unbind default Visual Block keys, bind to Leader+v, rebind C-v to Escape.
		" The last mapping in insert mode for <C-v> is critical since default map
		" doesn't apply to insert mode, and both <C-v> and <M-f> are bount to <Esc>.
			map 			<C-v> 			<Nop>
			map				<M-f>			<Nop>
			nnoremap 		<Leader>v 		<C-v>
			map				<C-c>			<Esc>y
			imap			<C-c>			<Esc>y
			map 			<C-v> 			<Esc>Pa
			imap			<C-v>			<Esc>Pa
			map 			<M-f> 			<Esc>
			imap			<M-f>			<Esc>
			

		"-------------------[4.4.2] Quick saving/leaving files.
		" Makes use of suda.vim plugin.
			nnoremap 		<Leader>ws		:w suda://%	<CR>
			nnoremap 		<Leader>w			:w					<CR>
			nnoremap 		<Leader>ww		:w!					<CR>
			nnoremap 		<Leader>wq 		:wq					<CR>
			nnoremap 		<Leader>q 		:q					<CR>
			nnoremap 		<Leader>qq 		:q!					<CR>
			nnoremap 		<Leader>qa 		:qa!				<CR>
		" Write the currently opened file as sudo.


		"-------------------[4.4.3] Create command to remove any lines containing nothing other than whitespace
		" (Comments are omitted), and creates abbreviation for easier calling.
			command! 		Delwhitespace	%s/\s\+$//e | %s/\n{3,}/\r\r/e
			cnoreabbrev	blm						:Delwhitespace <CR>

		"-------------------[4.4.4] Bind escape to clear search highlighting.
			nnoremap		<Esc> 				:silent noh	<CR><Esc>

		"-------------------[4.4.5] Vim-Spellcheck configuration.
		" Automatically correct spelling error to the first result in spellcheck.
			nnoremap 		<Leader>sc 						:set spell! <CR>
			noremap			<Leader>ss						]s1z=
			command!			FixTypo				:normal ]s1z=
			cnoreabbrev	typo									:FixTypo

		"-------------------[4.4.6] General keybinds and shortcuts.
			map					<Leader>m					@m
			map					<Leader>p					<Nop>
		" map					<Leader>p					nciw
			map					<Leader>c					zc
			inoremap			<M-Space>					<Esc>/<++><CR>ca<
			noremap				<M-Space>					/<CR>ca<
			noremap				<M-s>						}
			nnoremap			<Leader>f					:call Flash()<CR>

		" Surround-plugin leader keybinds.
			map					<Leader>e					vg_
		"	map					<Leader>s					vg_S

			"map				<Leader>f					V}zf<Esc>

		" Reload the vimrc/init.vim file without having to reload/reopen buffers.
			nnoremap <Leader>r								:silent source $MYVIMRC<CR>
			"524096
