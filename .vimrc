" machine-specific options
"-------------------------------------------------------------------------------

" options for gvim on win10
if hostname() == 'LOGANF-5820'
    set shellcmdflag-=command
    let g:netrw_browsex_viewer="powershell.exe -command start-process iexplore.exe"
    set directory^=$HOME/vimfiles/tmp//

    " configuration to prevent strange gvim python crash
    set shell=cmd
    let &pythonthreedll = 'C:\Users\lfrederick\.conda\envs\vim_32\python37.dll'
    let $PYTHONPATH = 'C:\Users\lfrederick\.conda\envs\vim_32'
    let $PYTHONHOME = 'C:\Users\lfrederick\.conda\envs\vim_32'

    " Plugins
    set nocompatible
    filetype off
    set rtp^=C:\Users\lfrederick\vimfiles\bundle\Vundle.vim
    call vundle#begin('C:\Users\lfrederick\vimfiles\bundle')
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'davidhalter/jedi-vim'
    let g:flake8_cmd = 'C:\Users\lfrederick\.conda\envs\vim_32\Scripts\flake8.exe'
    Plugin 'nvie/vim-flake8'
    call vundle#end()
    filetype plugin indent on

    " gvim options
    colorscheme elflord
    set guifont=hack:h15
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set guioptions-=e
endif


" general options
"-------------------------------------------------------------------------------

set fileencoding=utf-8
set termencoding=utf-8
set encoding=utf-8
set noerrorbells
set belloff=all
set t_Co=256

set smartcase
set nohlsearch
set showcmd
set expandtab
set textwidth=79
set tabstop=4
set shiftwidth=4
set wrap
set number
set autoindent

set list
set listchars=tab:>-,trail:$
set backspace=indent,eol,start

set laststatus=2
set statusline=
set statusline+=Editing:
set statusline+=\ %f
set statusline+=\ %y
set statusline+=\ %M
set numberwidth=1

set incsearch hlsearch

" Mappings
"-------------------------------------------------------------------------------

" turn off hlsearch by hitting backspace in normal mode
nnoremap <bs> :nohlsearch<cr>

" make markdown headings
inoremap ;J <esc>yypVr=o<CR>
inoremap ;j <esc>yypVr-o<CR>

" number (visually selected) lines
vnoremap \N :s/^/\=line('.').". "<cr>

" shortcut to execute vim script block
nnoremap \x yip:@"<cr>

" yank entire file to clipboard and return to previous position
nnoremap \a magg"*yG`azz

" fix trailing whitespace (powershell)
nnoremap \w :%s_ \+$__g<cr>

" swap ex mode with paragraph format for safety
nnoremap Q gqap

" auto commands
"-------------------------------------------------------------------------------

" yaml
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" obnoxious crosshairs, but only in normal mode
autocmd! InsertEnter * setlocal nocursorline nocursorcolumn
autocmd! InsertLeave * setlocal cursorline cursorcolumn

" auto-source vimrc on edit
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" fold python docstrings
autocmd! FileType python setlocal foldenable foldmethod=syntax
set foldtext=getline(v:foldstart+1)

" highlighting, etc
"-------------------------------------------------------------------------------

syntax on
set background=dark
set cursorline cursorcolumn

" add a blue wall from column 80+
let &colorcolumn=join(range(80,999),",")

hi Folded                        guibg=#363636     guifg=Black
hi Foldcolumn                    guibg=Yellow      guifg=White
hi ColorColumn                   guibg=#0088FF     guifg=White
hi StatusLine                    guibg=White       guifg=Red
hi Tabline                       guibg=DarkMagenta guifg=Yellow
hi TablineFill                   guibg=DarkMagenta guifg=Yellow
hi TablineSel                    guibg=#00FF00     guifg=Blue
hi Linenr       gui=bold         guibg=#00FF00     guifg=Blue
hi Cursorline   gui=bold         guibg=Magenta
hi Cursorcolumn gui=bold         guibg=Magenta
hi Visual                        guibg=#FF00FF     guifg=White
hi Cursor       gui=bold         guibg=White       guifg=Red
hi Cursorlinenr gui=bold         guibg=White       guifg=Red
hi Visual       gui=bold         guibg=White       guifg=Red
hi Search       gui=bold         guibg=Red         guifg=White
hi Specialkey   gui=bold,reverse
hi Endofbuffer                   guibg=Black       guifg=Blue
hi Incsearch                     guibg=White       guifg=Red
hi Search                        guibg=White       guifg=Red
