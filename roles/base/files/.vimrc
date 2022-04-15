set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
"Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'

" languages/themes
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'othree/html5.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'kchmck/vim-coffee-script'
Plugin 'groenewege/vim-less'
Plugin 'tpope/vim-rails'
Plugin 'pangloss/vim-javascript'
Plugin 'reedes/vim-thematic'
Plugin 'JuliaEditorSupport/julia-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFLag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Function: NumberToggle
" Function to toggle relative line numbering.
" function stolen from:
"
" http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
" Slightly modified because their example didn't do what I wanted.
" On my laptop it moves my cursor by one... Not sure why. At work it doesn't do this.
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

" Always show statusline
set laststatus=2
let g:Powerline_symbols = 'unicode'
let g:Powerline_theme = 'default'
let g:Powerline_stl_path_style = 'short'
let g:Powerline_dividers_override = ['>>', '>', '<<', '<']
let g:Powerline_colorscheme = 'solarized256_dark'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
syntax enable
set background=dark
"silent! colorscheme solarized
set t_Co=256
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set whichwrap+=<,>,h,l,[,] " wraps around when using arrow keys
set nowrap " Do not wrap text
set expandtab " Insert spaces instead of tabs
set tabstop=2 " Set the number of spaces to 2
set autoindent "always set auto-indenting on
set shiftwidth=2 " number of spaces to use for auto indenting
set showmatch " show matching parens
set hlsearch " highlight search terms
set incsearch " show search matches as you type
set cursorline " highlights current line
set cursorcolumn " highlights current column
set number " always show the line numbers
set relativenumber " relative line numbering.
"set textwidth=80 " Fix the column width to 80 characters
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR> "Remove all trailing whitespace by pressing F5
nnoremap <F4> mzgg=G`z
cmap W  w
cmap Q  q
cmap w!! execute 'silent w !sudo tee > /dev/null %' \| edit!
cmap wq!! execute 'silent w !sudo tee > /dev/null %' \| q!

"new stuff to try out
set history=2000
"set spell
set undofile
set undolevels=1000
set undoreload=10000
"color solarized
highlight clear SignColumn
highlight clear LineNr
set backspace=indent,eol,start
set linespace=0
set ignorecase
set smartcase
set scrolloff=3
set softtabstop=2

autocmd BufNewFile,BufRead *.jl :set filetype=julia


