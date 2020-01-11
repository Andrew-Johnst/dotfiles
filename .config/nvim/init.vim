" Check if vim-plug is installed for current user, install it if it's not
" installed.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

" Load plugins.
call plug#begin('~/.config/nvim/plugged')

    " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    Plug 'junegunn/vim-easy-align'
    " Any valid git URL is allowed
    Plug 'https://github.com/junegunn/vim-github-dashboard.git'
    " Install Dracula theme
    Plug 'dracula/vim',{'name': 'dracula' }
    " Install Nord theme
    Plug 'arcticicestudio/nord-vim'
    " Install Hybrid material theme
    Plug 'kristijanhusak/vim-hybrid-material'
    " Install palenight plugin
    Plug 'drewtempelmeyer/palenight.vim'
    " Install vim-airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Set the colorscheme.
"   let g:dracula_colorterm = 0
"   colorscheme dracula
"   let g:dracula_italic = 0
"colorscheme hybrid_material
colorscheme palenight
set background=dark
"hi CursorLineNr gui=bold guifg=DarkRed guibg=#c0d0e0


" Vim-airline configurations
    " Palenight theme for vim-airline
    let g:airline_theme = "palenight"
    " Disable trailing whitespace info.
    let g:airline#extensions#whitespace#enabled = 0

" Setting tab to 4 spaces, etc.
set tabstop=4
set shiftwidth=4
set expandtab

" Enabling relative-line-number and color.
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
 
" Set Terminal colors to xterm-256color for PuTTY SSH connections.
if $TERM == "xterm-256color"
    set t_Co=256
endif


" Adding this in to clear highlighting from the previous search results.
nnoremap <esc> :noh<return><esc>
