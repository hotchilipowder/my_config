" _  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|
"
"
" author: h12345jack
"
" ======== General setting 
set encoding=utf-8
scriptencoding utf-8


filetype plugin indent on "Enabling Plugin & Indent
syntax enable "Turning Syntax on


" Set height of status line
set laststatus=2

" Changing fillchars for folding, so there is no garbage charactes
set fillchars=fold:\ ,vert:\|

" Paste mode toggle, it seems that Neovim's bracketed paste mode
" does not work very well for nvim-qt, so we use good-old paste mode
set pastetoggle=<F2>

" Split window below/right when creating horizontal/vertical windows
set splitbelow splitright

" Time in milliseconds to wait for a mapped sequence to complete,
" see https://unix.stackexchange.com/q/36882/221410 for more info
set timeoutlen=500

" For CursorHold events
set updatetime=800

" Clipboard settings, always use clipboard for all delete, yank, change, put
" operation, see https://stackoverflow.com/q/30691466/6064933
set clipboard+=unnamed
set clipboard+=unnamedplus


" Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
set noswapfile

" General tab settings
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」

" Show line number and relative line number
set number relativenumber

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase


set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8

" Break line at predefined characters
set linebreak
" Character to show before the lines that have been soft-wrapped
set showbreak=↪


" Show current line where the cursor is
set cursorline
" Set a ruler at column 80, see https://stackoverflow.com/q/2447109/6064933
set colorcolumn=80

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

" Use mouse to select and resize windows, etc.
if has('mouse')
    set mouse=nv  " Enable mouse in several mode
    set mousemodel=popup  " Set the behaviour of mouse
endif

" Do not show mode on command line since vim-airline can show it
set noshowmode

" Fileformats to use for new files
set fileformats=unix,dos


" The way to show the result of substitution in real time for preview
if exists('&inccommand')
    set inccommand=nosplit
endif




" Do not use visual and error bells
set novisualbell noerrorbells

" The level we start to fold
set foldlevel=0

" The number of command and search history to keep
set history=1024


" Use list mode and customized listchars
set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:+



set wildmenu " Enable enhanced tab autocomplete.
set wildmode=list:longest,full " Complete till longest string, then open the wildmenu.




set ruler
set mouse=a
set nobackup
" copy from requests author
set nocompatible  " cancle the campatitble mode
set backspace=2   " backspace for delete bug
set cindent "C language autoindent
set smarttab
set foldmethod=syntax

" reopen to last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


" ================ my configs
" map jk to esc 
let mapleader="\<space>"
let g:mapleader="\<space>"
imap jk <Esc> 
imap kj <Esc>

" near to SPC f e d in spacemacs
nmap <leader>fed :e ~/.vimrc<cr>

" Split window
nmap <leader>ws :split<Return><C-w>w
nmap <leader>wv :vsplit<Return><C-w>w

" Move window
map <leader>wh <C-w>h
map <leader>wk <C-w>k
map <leader>wj <C-w>j
map <leader>wl <C-w>l
map <leader>wq <C-w>q
map <leader>pt :NERDTreeToggle<CR>
