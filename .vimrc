" Gotta be first!
set nocompatible

" Enable pathogen
" execute pathogen#infect()
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
"Plugin 'marijnh/tern_for_vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'rdnetto/YCM-Generator'
Plugin 'tomtom/tcomment_vim'
Plugin 'vim-scripts/DoxygenToolkit.vim'
Plugin 'taglist.vim'

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

" General settings
set statusline=%t
set exrc
set secure
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch

syntax on
filetype plugin indent on

" Set indentation options
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set cindent

" Set some column coloring shenanigans
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray
hi visual gui=NONE ctermbg=white ctermfg=black guibg=white guifg=black

" Restore the last position in the file we've edited
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
"set viminfo='10,\"100,:20,%,n~/.viminfo
set viminfo='10,\"100,:20,n~/.viminfo

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Set some options to recognise C files as C files and not C++
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" Set template options
function! s:ConfigCTemplate()
    " Unset restore of cursor for new files (do not move us to the first line!)
    autocmd! resCur BufWinEnter
    so ~/.vim/templates/c.txt
    1,4s/FILE_NAME.*/\="File name:\t".expand('%:t')/g
    1,4s/CREATED.*/\="Created:\t\t".strftime("%Y-%m-%d")/g
    1,6s/MODIFIED.*/\="Modified:\t".strftime("%Y-%m-%d")/g
    " Place the cursor at the description and enter insert mode
    1,7s/DESCRIPTION//g | noh | startinsert!
    " Remove search from search history
    call histdel('search', -3)
endfunction
function! s:UpdateModified()
    " Save current view
    let l:save_view = winsaveview()
    1,5s/\(Modified:\).*/\=submatch(1)."\t".strftime("%Y-%m-%d")/|noh
    call winrestview(l:save_view)
    " Remove search from search history
    call histdel('search', -1)
endfunction

augroup ctemplates
    autocmd!
    autocmd BufNewFile *.c,*.cpp,*.cc,*.h call s:ConfigCTemplate()
    " Change the last modified date automatically
    autocmd BufWritePre *.c,*.cpp,*.cc,*.h silent! undojoin | call s:UpdateModified()
augroup END

" Add some more paths to vim for "gf"
let &path.="/usr/include/c++/*,include,"
" For Java
set includeexpr=substitute(v:fname,'\\.','/','g')

" Disable arrow keys!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

let mapleader=','
" Make options
" set makeprg=make\ %\ &&\ ./%:r
nnoremap <F4> :make!<cr>
nnoremap <Leader><F4> :!./<C-R>=fnamemodify(getcwd(), ':t')<cr><cr>
nnoremap <Leader>p :cp<cr>
nnoremap <Leader>n :cn<cr>
" New buffer
nnoremap <Leader>N :new\|only<cr>

" Some things for YouCompleteMe
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf=0
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_autoclose_preview_window_after_completion=1



" Enable folding based on syntax
"set fdm=syntax

" Enable powerline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"let $PYTHONPATH='/usr/lib/python3.4/site-packages'
"set rtp+=/usr/lib/python3.4/site-packages/powerline/bindings/vim

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" Set relative line numbers
set relativenumber

" Add a way to easily switch buffers
nnoremap <F1> :bprev<CR>
nnoremap <F2> :bnext<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <F6> :buffers<CR>:bdelete<Space>
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
"set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Map F7 as a way of opening a file explorer
nnoremap <F7> :Explore<CR>
noremap <Leader>s :update<CR>

" Shortcut for completing
imap <C-Space> <C-N>

" Some convenience at the command line
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>

" Turn off last search highlight
nnoremap <Leader>. :noh<cr><esc>

" Mark trailing whitespaces
:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" When highlighting search terms, make sure text is contrasting color
:highlight Search ctermbg=yellow ctermfg=black
" Do the same for gvim
:highlight Search guibg=yellow guifg=black

set guifont=Liberation\ Mono\ for\ Powerline\ 10

" Highlight current line with a line and a colour
set cursorline
hi CursorLineNr ctermfg=green
hi cursorline ctermfg=white ctermbg=black guifg=white guibg=black
hi Folded ctermbg=27 ctermfg=white
hi Comment ctermfg=154

set shell=bash

let g:netrw_liststyle=1
let g:netrw_banner=0
let g:netrw_sort_sequence="[\/]$,\<core\%(\.\d\+\)\=\>,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$"

inoremap <F5> <C-R>=strftime("%Y-%m-%d")<CR>
inoremap <S-F5> <C-R>=expand("%:t")<CR>
inoremap <C-F> <C-R>=expand("%:t:r")<CR>

if &diff
    highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
    set diffopt+=vertical
    nmap <leader>2 :diffget LOCAL<CR> :diffupdate<CR>
    nmap <leader>3 :diffget BASE<CR> :diffupdate<CR>
    nmap <leader>4 :diffget REMOTE<CR> :diffupdate<CR>
    nmap <leader>c ]c
    nmap <leader>C [c
endif

" Ctrl+N = new file in own buffer
nmap <C-N> :new<CR>:only<CR>

colorscheme distinguished

" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.vimundo/

let g:DoxygenToolkit_authorName="Daniel Ivarsson"
let g:DoxygenToolkit_licenseTag="OpenBSD"


" Set the size of the GVim window
if has("gui_running")
  " GUI is running or is about to start.
  set lines=50 columns=150
endif
