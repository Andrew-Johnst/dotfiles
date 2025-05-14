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
"									 _   _         __     _____ __  __
"									| \ | | ___  __\ \   / /_ _|  \/  |
"									|  \| |/ _ \/ _ \ \ / / | || |\/| |
"									| |\  |  __/ (_) \ V /  | || |  | |
"									|_| \_|\___|\___/ \_/  |___|_|  |_|

" My (usually) most up-to-date config file for Vim/neovim; mostly experimental as a learning
" experience for learning and becoming more comfortable using Vim/neovim, trying to put down the GNU
" Nano 'crack-pipe' to learn a better and far-more functional editor.
" /* vim: filetype:vim */

" TO-DO:
" Compartmentalize, segregate, and overall organize the settings in this main init.vim config file,
" and creating vimscript files containing all the settings pertaining to each individual group and
" then just call/reference/source that file in this file.

" ##################################################################################################
" ###### Please for the love of god redo the formatting of this dumpsterfire (at some point). ######
" ##################################################################################################

  "-----------------------[1.0] Plug-ins and Preliminary settings.
  	"---------------------[1.1] Autocommand clearing/insurance.
		" [Clearing autocmd/augroup in case they get double loaded]:
			au!

		"---------------------[1.2] Verify Installation Status of Vim-Plug and Pathogen Plugin managers.
		" Activates Vim-Pathogen plugin; if it is not found, then automatically install it.
				if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
				echo "Downloading Vim-Plug plugin manager for nvim..."
				silent !mkdir -p ~/.config/nvim/autoload/
				silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
					  \ > ~/.config/nvim/autoload/plug.vim
				  autocmd VimEnter * PlugInstall
				endif

		" Activates Vim-Pathogen plugin; if it is not found, then automatically install it.
				if ! filereadable(expand('~/.config/nvim/autoload/pathogen.vim'))
				  echo "Downloading Vim-Pathogen plugin manager for neovim..."
				  silent !mkdir -p ~/.config/nvim/autoload/ ~/.config/nvim/bundle
					silent !curl -LSso ~/.config/nvim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
				endif

	"---------------------[1.3.0] Load Plugins.
		"-------------------[1.3.1] Load Custom Files and Manually Installed Plugins via Bundle.vim
			" This installs plugins installed manually in the directory specified below.
			execute pathogen#infect('~/.config/nvim/plugins/pathogen/{}',
						\ '~/.config/nvim/plugins/config/{}')
			execute pathogen#infect('~/.config/nvim/plugins/config/{}*')

		"------------------[1.3.2] Loads Plugged Vim Plugin Manager and Specify Plugins to be Installed.
			call plug#begin('~/.config/nvim/plugins/plugged')
		  " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align:
		  		Plug 'junegunn/vim-easy-align'
		  " Any valid git URL is allowed:
		  		Plug 'https://github.com/junegunn/vim-github-dashboard.git'
		  " Install Dracula theme:
		  		Plug 'dracula/vim',{'name': 'dracula' }
			" Install Hydrangea theme.
					Plug 'yuttie/hydrangea-vim'
		  " Install Nord theme:
		  		"Plug 'arcticicestudio/nord-vim'
		  " Install Hybrid material theme:
		  		"Plug 'kristijanhusak/vim-hybrid-material'
			""" The below palenight.vim theme plugin was causing all the <SNR>15_h W18 errors.
		  " Install palenight plugin:
					Plug 'drewtempelmeyer/palenight.vim'
				" In order to get the palenight theme to load without throwing 2+ pages of errors due to
				" errors in how characters were added to groups, I manually had to type a `silent!` command
				" before the `execute` command to silence those error messages.
				" The file in question is:
				" 	'~/.config/nvim/plugins/plugged/palenight.vim/colors/palenight.vim'
			"" Install vim-orgmode:	(Disabled because it constantly gives issues either with new
			"" installs or committing changes to github.)
			"  Plug 'jceb/vim-orgmode'
			" FZF installation seems very bizare, it was already installed, but apt installed it again.
			" Install fzf fuzzy-finder, clone git repo into ~/.fzf directory:
				"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
				Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
			" Install oceanic-next theme:
				Plug 'mhartington/oceanic-next'
			" Install vim-airline:
			 	Plug 'vim-airline/vim-airline'
				"Plug 'https://github.com/vim-airline/vim-airline.git'
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
			" Install the vimwiki plugin.
			" (Prerequisites: 'set nocompatible' 'filetype plugin on' 'syntax on').
				Plug 'vimwiki/vimwiki'
			" Install vim-table-mode plugin that helps create and manage tables in vim.
				Plug 'dhruvasagar/vim-table-mode'
			" Install 'lh-vim-lib' plugin, used for various options and helper functions.
			" [Check out the github link for more info]: https://github.com/LucHermitte/lh-vim-lib
				Plug 'LucHermitte/lh-vim-lib'
			" Install vim-colors-paramount colorscheme/theme.
				Plug 'owickstrom/vim-colors-paramount'
			" Install vim-colors-plain colorscheme/theme.
				Plug 'andreypopp/vim-colors-plain'
			" Install a (better) version of Markdown for Vim/NeoVim that includes: syntax highlighting,
			" matching rules, and mappings for the original markdown and extensions.
				Plug 'godlygeek/tabular'
				Plug 'preservim/vim-markdown'
			" Install the Neovim/Vim ranger plugin.
			" [URL to github repo for this plugin]:
			" 	https://github.com/francoiscabrol/ranger.vim
		    Plug 'francoiscabrol/ranger.vim'
			" Install the dependency plugin required for 'ranger.vim' plugin specific to NeoVim.
		    Plug 'rbgrouleff/bclose.vim'
			" Install Vim Golf (TRYING to install via plugin using the repo [04-22-2025 4-51AM])
			" (((Commented out to use the github repo from reddit post for neovim listed below)))
				"Plug 'igrigorik/vimgolf'
			" Install Vim Golf (from a fork git repo for neovim/vim plugins)
				Plug 'vuciv/golf'

			"" Install Markdown Preview for NeoVim (utilizes nodejs and yarn--in this version of installing
			"" the plugin at least).
			"" If you don't have nodejs and yarn
			"" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin see:
			"" https://github.com/iamcco/markdown-preview.nvim/issues/50
			"Plug 'iamcco/markdown-preview.nvim', 
			"			\ { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
			
			"" Install plugin to preview Markdown inside the vim buffer. (The below plugin wasn't the best
			"" nor my favorite markdown plugin for vim, so installing a different one).
			"Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
			"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

			" Install NERDTree (file system explorer for vim/neovim) via official github repo.
				Plug 'preservim/nerdtree'

			" [[[FIX LATER]]] "
			" Plugin for NeoVIM/VIM tree-sitter for syntax highlighting.
 				" (We recommend updating the parsers on update)
				"Plug 'nvim-treesitter/nvim-treesitter'
				", {'do': ':TSUpdate'}
				" (There is a line of Lua config for this plugin at the bottom (Section [5.2]))

		"------------------[1.3.2.1] NERDTree Extra Plugins and Extension Install/Calls.
			" Vim-Plug plugin call block for a few NERDTree specific plugins that modify its behaviour.
			" [Using the list of plugins detailed here as of (5-3-2022 4:10PM)]:
			" 	https://github.com/preservim/nerdtree#nerdtree-plugins
				" Plugin that shows git status flags for files and folders in NERDTree.
				  Plug 'Xuyuanp/nerdtree-git-plugin'

				" Plugin that adds filetype-specific icons to NERDTree files and folders.
					Plug 'ryanoasis/vim-devicons'

				" Plugin that adds syntax highlighting to NERDTree based on filetype.
					Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

				" Plugin that saves and restores the state of the NERDTree between sessions.
					Plug 'scrooloose/nerdtree-project-plugin'

				" Plugin that 1). Highlights open files in a different color, and 2). Closes a buffer
				" directly from NERDTree.
					Plug 'PhilRunninger/nerdtree-buffer-ops'

				" Plugin that enables NERDTree to: open, delete, move, or copy multiple Visually-selected
				" files at once.
					Plug 'PhilRunninger/nerdtree-visual-selection'

			"###########################################################################################"
			"######################### Plugins installed on: [6-23-2022 3:30PM]L #######################"
			"###########################################################################################"

			" Install Conquer of Completion.
				"Plug 'neoclide/coc.nvim', {'branch': 'release'}

					" (Opting to install Vim Plugin 'ALE' instead since there is much more support and larger
					" userbase in implicitly more options.)
					
					" Plug 'vim-prettier' that 'prettifies' code in vim/nvim.
					" Post install (yarn install | npm install) then load plugin only for editing supported
					" files.
					"	Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

			call plug#end()

"-----------------------------------[1.4] - Plugin Configurations.
	"################################################################################################"
	"#### Configurations to plugins are stored under the custom Bundle plugin manager directory. ####"
	"################################################################################################"

	"---------------------------------[1.4.1] VimWiki Configuration.
		" Keybinds for this plugin ("VimWiki") is in section: [4.5.1] of this init.vim config file.
	
		"let g:vimwiki_list = [{'path': '~/.config/nvim/plugins/vimwiki/'}]
		"let g:vimwiki_list = \
		"	[{'path': '~/.config/nvim/plugins/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
		let g:vimwiki_list = [{'path': '~/Documents/Linux/VimWiki', 'syntax': 'markdown', 'ext': '.md'}]
		let g:vimwiki_global_ext = 0
		" https://github.com/vimwiki/vimwiki/issues/312#issuecomment-284853877
		let g:vimwiki_url_maxsave=0

		" Sets the VimWiki directory to be located inside the vim runtimepath config directory.
		" Checks for the right directory (if in ~/.config/nvim or ~/.vim).
		"	if isdirectory('~/.config/nvim')
		"		let g:vimwiki_list = [{'path':'$HOME/.config/nvim/vimwiki'}]
		"	endif
	
	"---------------------------------[1.4.2] NERDTree Configuration.
		"---------------------------------[1.4.2.2] NERDTree custom keybinds and shortcuts.
			" Keybinds for easier/more-convenient use of NERDTree commands via key mapping them.
				nnoremap <Leader>n	:NERDTreeFocus<CR>
				nnoremap <C-n>			:NERDTree<CR>
				nnoremap <M-t>			:NERDTreeToggle<CR>
				nnoremap <M-F>			:NERDTreeFind<CR>

		"---------------------------------[1.4.2.3] NERDTree vim autocmd's for when vim is opened.
			" Close the tab if NERDTree is the only window remaining in it.
				"autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() \
				" | quit | endif
			" Automatically closes current Vim buffer or tab after closing NERDTree if the buffer/tab is
			" the last window.
			" Exit Vim if NERDTree is the only window remaining in the only tab.
					"	autocmd BufEnter * 
					"				\ if tabpagenr('$') == 1
					"				\ && winnr('$') == 1
					"				\ && exists('b:NERDTree')
					"				\ && b:NERDTree.isTabThree()
					"				\ | quit
					"				\ | endif


"-----------------------------------[2.0] - Theming and appearance settings.
	"---------------------[2.1] Colorscheme options.
	" ### The default/current WSLTTY/MinTTY Theme in Windows 10 Desktop WSL2 TTY/Terminal is:      ###
	" ### [base16-material-palenight-256.minttyrc]																						     ###
		" Calling the custom theme in colors/lena.vim
			"colorscheme lena

			" Can't think of better to jot down a list of themes I'd like to try out.  Wryan, zenburn, One
			" Half Dark, Ollie, spacegray, subliminal, teerb, tomorrow night, tomorrow night eighties,
			" oceanic-next

			" Enables true colors in neovim.
			"		let $NVIM_TUI_ENABLE_TRUE_COLOR=1

			" Adding this in conjunction with a .tmux.conf tweak from this site:
			" https://github.com/tmux/tmux/issues/1246
			" Enable true color 启用终端24位色
				if exists('+termguicolors')
				  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
				  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
				  set termguicolors
				endif




				"colorscheme dracula
				"let g:airline_theme = "dracula"
				" In order to get the palenight theme to load without throwing 2+ pages of errors due to
				" errors in how characters were added to groups, I manually had to type a `silent!` command
				" before the `execute` command to silence those error messages.
				" The file in question is:
				" 	"~/.config/nvim/plugins/plugged/palenight.vim/colors/palenight.vim"
				"colorscheme dracula
				"let g:airline_theme = "dracula"

			" Palenight colorscheme/theme configurations.
			"let g:palenight_terminal_italics=1
			silent! colorscheme palenight
			" The below configuration for setting the active theme for vim-airline is located below in
			" section 2.3 where the rest of vim-airline configurations are. 
			"let g:airline_theme = palenight
			"set background=dark

			" Trying to set theme and vim-airline theme to Tomorrow-Night-Eighties.
			"colorscheme Tomorrow-Night-Eighties
			"let g:airline_theme='base16_tomorrow_night_eighties'
			"let g:

			" Specific settings for dracula (must be specified in this order or
			" results in visual glitches (or at least in PuTTY-xterm sessions.)

		 	 "let g:dracula_colorterm = 0
			 "colorscheme dracula
			 "let g:dracula_italic = 0
			" colorscheme hybrid_material
			 "hi CursorLineNr gui=bold guifg=DarkRed guibg=#c0d0e0

			" Colorscheme 'Arcadia' taken from this github repository (found from looking for Xresources
			" for xterm).
			"		https://github.com/AlessandroYorba/Arcadia
			"let g:arcadia_Midnight = 1
			"let g:arcadia_Pitch = 1
			"colorscheme arcadia
			"let g:airline_theme = "arcadia"

	"---------------------[2.2] Settings for fixing improper default terminal color settings.
		"		" Potential fix, attempt 1 of 2.
		"				if exists('+termguicolors')
		"					let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
		"					let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
		"					set termguicolors
		"				endif
		"				if (has("termguicolors"))
		"					set termguicolors
		"				endif
		"				"set termguicolors
		"				"let g:oceanic_next_terminal_bold = 1
		"				"let g:oceanic_next_terminal_italic = 1
		"				"colorscheme OceanicNext
		"
		" Settings from Archwiki for fixing colors in vim/neovim while using SucklessTerminal.
		" (The background colour of text in vim will not fill in anything that is not a character):
		"	[https://wiki.archlinux.org/title/st#Vim]
			if &term =~ '256color'
				" Disable Background Color Erase (BCE) so that color schemes render properly when inside
				" 256-color tmux and GNU screen.
				" (See Also):	https://sunaku.github.io/vim-256color-bce.html
				set t_ut=
			endif
		" 256color and truecolor support not working in tmux or otherwise:
		"set t_8f=^[[38;2;%lu;%lu;%lum				" Set foreground color.
		"set t_8b=^[[48;2;%lu;%lu;%lum				" Set background color.
		"colorscheme Tomorrow-Night-Eighties
		"if !exists(t_Co) && set t_Co=256													" Enable 256 colors.
		set termguicolors										" Enable GUI colors for the terminal to get truecolor.

	"---------------------[2.3] Vim-Airline config settings.
		"let g:airline_theme='oceanicnext'
		"let g:airline_theme='dracula'
		" Allows vim-airline to use fonts (without this, rectangles appear instead of the expected arrow
		" shapes).
			let g:airline_powerline_fonts = 1
		" Auto command for entering any vim buffer to disable vim-airline whitespace info.
			autocmd VimEnter * silent! AirlineToggleWhitespace
		" Sets the path formatter for tabs so the filepath appears on tabs and current buffer indicator.
		" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
			let g:airline#extensions#tabline#formatter = 'unique_tail'
			let g:airline#extensions#tabline#left_sep = ' '
			let g:airline#extensions#tabline#left_alt_sep = '|'
		" Palenight theme for vim-airline.
			silent! let g:airline_theme = palenight
		" Disable trailing whitespace info.
			let g:airline#extensions#whitespace#enabled = 0

"	-----------------------------------[3.0] - Formatting settings.
	"----------------------------------[3.1] - Default and general format settings.
		" Assign tabcount value, shiftwidth, encoding, etc. (Filetype format settings for ftplugin have
		" to be in the $VIMRUNTIME/after/ftplugin directory, or they'll be overwritten with the global
		" settings specified here).
		
		" (Potential fix by delaying the setting of the syntax until the filetype is finished in
		" ftplugin.)
		filetype plugin on
		set filetype=on
		set tabstop=4
		set shiftwidth=4
		set textwidth=100
		set foldmethod=manual
		set formatoptions=qc
		set encoding=utf-8
		set nocompatible
		set autowriteall
		set nobackup
		"set wrap
		"set linebreak
		"set nowritebackup

		" Adding this [2-20-2024 11:11PM] below line of vimscript to hopefully stop those totally super
		" useful and extremely informative error messages when starting any new vim or neovim buffer.
			"autocmd BufEnter * lua vim.lsp.diagnostic.disable()

		" Adding this manually since the reloading of vimrc in the buffer overrides format options
		" to the global init.vim settings.
		" autocmd FileType .vim set tabstop=2
		" Sets mouse functionality and system clipboard.
		" Commenting this out for now because <C-v> and <C-c> and general clipboard issues. 5-5-20
		" 10:12PM
		" set mouse=a
		" set clipboard=unnamedplus

		" ### Had to comment out the below as the '$NVIM_TUI_ENABLE_CURSOR_SHAPE' variable will be
		" depreciated, and 'guicursor' should be used instead. ###
		"
    " This changes the cursor shape and shape behaviour since on AWS it was set to use line
    " shape in all modes. The variable is what changed the behaviour of the cursor while
    " guicursor setting defined what specs to give the cursor.
		"
    " 		set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
    " 		let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

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
		"	autocmd BufWinLeave *.* mkview
		"	autocmd BufWinEnter *.* silent! loadview

		" Supposedly the above commands to automatically create and load vim-views isn't working, so
		" using this solution found on stackoverflow below.
			augroup remember_folds
				autocmd!
				autocmd BufWinLeave * silent! mkview
				autocmd BufWinEnter * silent! loadview
			augroup END

	"--------------------[3.6] Surrounding word in quotes.
	"	command -nargs=1 -complete=command	Dquotes	call SurroundQuotes(t)

	"----------------------[3.7] Filetype templates and headers.
		"--------------------[3.7.1] Defining the functions, commands, and abreviations.
		" ##############################################################################################
		"	## Argument/parameter passing from command to function is broken, use <q-args> or <f-args>. ##
		" ##############################################################################################
					command! -nargs=*	-complete=command		Template	call TemplateFunction()
					command! -nargs=*	-complete=command		Header		call TemplateFunction()
			" Abbreviating user-defined commands such that they can be called in lower-case.
					cnoreabbrev	temp	:Template
					cnoreabbrev	head	:Header
		" Adding this here for now since not sure where any other definition/function is written if I even made
		" one.
					command -nargs=* -complete=command FilePathHeader call InsertFilePath()
					cnoreabbrev	ifp		:FilePathHeader

"-----------------------------------[4.0] - Quality of life improvements.
" General-use functions are defined in "~/.config/nvim/bundle/MyFunctions/plugin/MyFunctions.vim"
" file.
"(The vim command 'scriptnames', prints out the order in which vim files are loaded).
	"--------------------[4.1.0] Shortcutting split navigation.
	" Mapping window movement keys, setting default spawn location of new windows.
	" (Movement between window panes is using vim keys with the <Leader>(Space) key, and is defined at
	" the bottom with the rest of the leader definitions.
		set splitbelow
		set splitright
		"map	<C-h>		 						<C-w>h
		"map 	<C-j> 							<C-w>j
		"map 	<C-k> 							<C-w>k
		"map 	<C-l> 							<C-w>l
		"map 	<M-y> 							<C-w>>
		"map 	<M-i> 							<C-w>-
		"map 	<M-o> 							<C-w>+
		"map 	<M-p> 							<C-w><

		"-------------------[4.2] Unmap default spacebar keybind, then map it to leader key.
			"nnoremap <Space> <NOP>
			"let mapleader = ' '
			"let mapleader = ' '
			"nnoremap \<Space> <nop>
			"nmap <space> <leader>
			"map <silent> <Space> <Nop>
			"inoremap <silent> <Space> <Nop>
			"nnoremap <silent> <Space> <Nop>
			"nnoremap <Silent> <Space> <Nop>
			"noremap <Silent> <Space> <Nop>
			"map <Silent> <Space> <Nop>
			"nnoremap <Silent> <Space> <Nop>
			"silent map <Space> <Nop>
			map <Space> <Nop>
			"inoremap <Space> <Nop>
			
			"let mapleader=<space>
			let mapleader = ' '


	"--------------------[4.3.0] Mappings for Making things more efficient for built-in and plugins.
	"--------------------[4.3.0] POSIX utilities, as well as some custom plugins.
		" Trying this out.
		set wildmenu


	"--------------------[4.2.0] Mappings for Tabs.
		map 	<C-q>								<Nop>
		map 	<C-q>		:tabclose		<CR>
		map 	<C-t>		:tabnew			<CR>
		map 	<M-l>		:tabnext 		<CR>
		map 	<M-h>		:tabprev		<CR>
		" Massive quality of life mapping when navigating the help pages.
		" Like the <C-]> keybind which opens links, however this keybind will open links in a new tab.
		"map <C-}>			:tabnew
		

	"--------------------[4.3.1] Windows/Window-Splits mappings for movement and resizing.
		" Movements
		"map	<Space>h					<Nop>
		"map	<Leader>h					<C-W>h
		map	<Leader>j					<C-w>j
		map	<Leader>k					<C-w>k
		map	<Leader>l					<C-w>l
		" Resizing
		map	<Leader>u					<C-w><
		map	<Leader>i					<C-w>-
		map	<Leader>o					<C-w>+
		map	<Leader>p					<C-w>>

	"--------------------[4.4.0] Various and Miscellaneous Command declarations Calling Functions.
	"--------------------[4.4.1] Defining Commands 
    " Command to open zshrc file in new vim tab.
        command!    ZRC :call OpenFileInNextAvailableBuffer("~/.config/zsh/.zshrc")
        cnoreabbrev	zrc :ZRC

    " Command to open init.vim file in new vim tab.
        command!		NRC :call OpenFileInNextAvailableBuffer("~/.config/nvim/init.vim")
        cnoreabbrev	nrc :NRC

    " Command to open aliasrc file in new vim tab.
        command!		ARC :call OpenFileInNextAvailableBuffer("$ZSH_SHORTCUTS/aliasrc")
        cnoreabbrev	arc :ARC

    " Command to open functionrc file in new vim tab.
				"command!    FRC	:call OpenFileInNextAvailableBuffer("~/.config/zsh/functionrc")
        command!    FRC	:call OpenFileInNextAvailableBuffer("$ZSH_SHORTCUTS/functionrc")
        cnoreabbrev frc	:FRC

	"--------------------[4.4.2] Various command declarations and abbreviations.
		" Command to open the main file containing my custom neovim functions.
				"command!		NCFU :call OpenFileInNextAvailableBuffer( \
				"	'~/.config/nvim/plugins/pathogen/MyFunctions/plugin/MyFunctions.vim')
				"command!		NCFU :call
				"			\ OFINTAB("~/.config/nvim/plugins/pathogen/MyFunctions/plugin/MyFunctions.vim")
				"command!	NVF :ofintab '~/.config/nvim/plugins/pathogen/MyFunctions/plugin/MyFunctions.vim'
				"cnoreabbrev ncfu :NVF
				cnoreabbrev ncfu :call(ncfu(...))
				cnoreabbrev nvfu :NVF
				cnoreabbrev vcfu :NVF
				cnoreabbrev nfu :NVF
				cnoreabbrev vfu :NVF
				cnoreabbrev nrcf :NVF

		" Make it so that the "help" console command opens the help in a new tab in the vim buffer
		" instead of a horizontal window split.
			" (The below/first cabbrev command has a bug where the '/' search function also replaces
			" 'help' with 'tab help').
			" https://vi.stackexchange.com/a/33221
				cabbrev			help tab help
				cabbrev 		<expr> helptab		(getcmdtype() == ':') ? "tab help" : "helptab"
				cabbrev 		<expr> ht 				(getcmdtype() == ':') ? "tab help" : "ht"

		" Command to write the currently opened file as sudo.
		" [Stackoverflow link explaining why this works]:
		" 	https://stackoverflow.com/a/7078429
				command!		SudoWrite		:w !sudo tee %
				cmap w!!		w !sudo tee > /dev/null %


		" Command to toggle showing 'cross-hairs' (showing both the cursor column and line).
		" (This effectively turns on the 'Flash' function but permanently--however when calling the
		" 'Flash' function, 
				command! 				 CrossHairs :setlocal cursorline! cursorcolumn!
				cnoreabbrev ch 	:CrossHairs

	"--------------------[4.5] General keybinds/settings.
		"-------------------[4.5.2] Unbind default Visual Block keys, bind to Leader+v, rebind C-v to
		" Escape.
		" The last mapping in insert mode for <C-v> is critical since default map
		" doesn't apply to insert mode, and both <C-v> and <M-f> are bount to <Esc>.
			map 				<C-v> 			<Nop>
			map					<M-f>				<Nop>
			nnoremap 		<Leader>v 	<C-v>
			map					<C-c>				<Esc>y
			imap				<C-c>				<Esc>y
			map 				<C-v> 			<Esc>Pa
			imap				<C-v>				<Esc>Pa
			map 				<M-f> 			<Esc>
			inoremap		<M-f>				<Esc>

		"-------------------[4.5.3] Quick saving/leaving files.
		" Makes use of suda.vim plugin.
		" Write the currently opened file as sudo.
			nnoremap    <Leader>ws    :w suda://% <CR>
			nnoremap    <Leader>w     :w          <CR>
			nnoremap    <Leader>ww    :w!         <CR>
			nnoremap    <Leader>wq    :wq         <CR>
			nnoremap    <Leader>q     :q          <CR>
			nnoremap    <Leader>qq    :q!         <CR>
			nnoremap    <Leader>qa    :qa         <CR>
			nnoremap    <Leader>qaq   :qa!        <CR>

		"-------------------[4.5.4] Create command to remove all lines containing only whitespace.
		" (Comments are omitted), and creates abbreviation for easier calling.
			command! 		Delwhitespace	%s/\s\+$//e | %s/\n{3,}/\r\r/e
			cnoreabbrev	blm						:Delwhitespace <CR>

		"-------------------[4.5.5] Bind escape to clear search highlighting.
			nnoremap		<Esc> 				:silent noh	<CR><Esc>

		"-------------------[4.5.6] Vim-Spellcheck configuration.
		" Automatically correct spelling error to the first result in spellcheck.
			nnoremap 		<Leader>sc 						:set spell! <CR>
			noremap			<Leader>ss						]s1z=
			command!		FixTypo								:normal ]s1z=
			cnoreabbrev	typo									:FixTypo

		"-------------------[4.5.7] General [Leader] keybinds and shortcuts.
			map					<Leader>m					@m
			map					<Leader>p					<Nop>
			map					<Leader>c					zc
			map					<Leader>-					<C-w>_
			map					<Leader>=					<C-w>=
			map					<Leader>f					<Nop>
			nnoremap		<Leader>f					<Nop>
			nnoremap		<Leader>f					:call Flash()<CR>
		" Change the keybind to increment/decrement number on cursor due to conflicting Tux keybinds.
			map					<Leader>a					<C-a>
			map					<Leader>x					<C-x>
		" Reload the vimrc/init.vim file without having to reload/reopen buffers.
		" Execute/run the file open in the current vim buffer (via calling the filepath in a shell).
		" nnoremap		<Leader>R					:silent! :!%:p<CR>
			nnoremap		<Leader>R					:exe ":!%:p"<CR>
		" [Commenting the below keybind out for the time being since it needs to be a function so that
		" it can handle opening blank/nameless files without throwing an error]:
			nnoremap		<Leader>r					:silent! exe "source $MYVIMRC" <CR> | silent! edit "%:p"
			"nnoremap		<Leader>ht				

		"-------------------[4.5.8] General [Meta/Alt] keybinds and shortcuts.
			noremap			<M-Space>					/<CR>ca<
			map					<M-n>		    			<Esc>/<++><CR>ca<
			inoremap		<M-n>		    			<Esc>/<++><CR>ca<
			nnoremap		<M-o>							o<Esc>0"_D
			nnoremap		<M-O>							O<Esc>0"_D
			map					<M-i>							i<++><ESC>
			nnoremap		<M-i>							i<++><ESC>
			inoremap		<M-i>							<++><ESC>

	"--------------------[4.6.0] Plugin keybinds.
		"-------------------[4.6.1] Surround-plugin leader keybinds.
			map					<Leader>e					vg_
			map					<Leader>4					vg_
			map					<M-e>							ve
			map					<M-E>							vE
		"	map					<Leader>s					vg_S
		" map 				<Leader>f					V}zf<Esc>
		"silent!	call	repeat#set("\<Plug>MyWonderfulMap", v:count)

		"-------------------[4.6.2] VimWiki Plugin Keybinds. " Fixing default keybinds for vimwiki. " Removes the annoying <Leader>ww keybind. nnoremap	<Leader>wi 			<Plug>VimwikiIndex
		map 			<Leader>wi			<Plug>VimwikiIndex

"-----------------------------------[5.0] - General Variable Declarations and Configs.(Need to organize init.vim)
	"--------------------[5.1] Set global variables.
    let g:python3_host_prog = '/usr/bin/env python3'
	"--------------------[5.2] Lua Configurations/Settings (Primarily from plugins in section [1.3.2])
	" At the bottom of your init.vim, keep all configs on one line.
	"lua require'nvim-treesitter.configs'.setup{highlight={enable=true}}
