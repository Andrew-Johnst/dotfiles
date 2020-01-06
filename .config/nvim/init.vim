" Specify directory for vim-plugged to search for plugins.
call plug#begin('~/.config/nvim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Install Dracula theme
Plug 'dracula/vim',{'name': 'dracula' }

call plug#end()

" Mapping comma to leader key.
"nnoremap

" Setting tab to 4 spaces, etc.
set tabstop=4
set shiftwidth=4
set expandtab

" Enabling relative-line-number
set relativenumber number

" Encoding.
set encoding=utf-8

" Syntax on by default
syntax on

" Always show current position
set ruler

" Shortutting split navigation, so only <C-(Direction)> needs to be pressed saving a <C-w>.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Mapping shortcuts to window-split resizing using leader key.
"map  
"map   
"map  
"map   

" Set the colorscheme.
let g:dracula_colorterm = 0
colorscheme dracula
let g:dracula_italic = 0

" Set TERM max_colors to 256 instead of default xterm-8 on PuTTY.
if &term == "xterm"
	set t_Co=256
endif

" Adding this in to clear highlighting from the previous search results.
nnoremap <esc> :noh<return><esc>
