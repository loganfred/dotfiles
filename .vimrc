" basic configuration
"-------------------------------------------------------------------------------

" work, win10 gvim
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

" home, arch linux
if hostname() == 'arch'
    setlocal cm=blowfish2
endif

set nocompatible
set fileencoding=utf-8
set termencoding=utf-8
set encoding=utf-8
set noerrorbells
set belloff=all
set t_Co=256

" common code configurations
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

" remove stupid de-indentation of python comments
inoremap # X#

" visual options
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

" open help in new tab
nnoremap \? :help<CR><c-w>T

" remove stupid de-indentation of python comments
inoremap # X#


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
au! FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" obnoxious crosshairs, but only in normal mode
au! InsertEnter * setlocal nocursorline nocursorcolumn
au! InsertLeave * setlocal cursorline cursorcolumn

" auto-source vimrc on edit
au! BufWritePost $MYVIMRC source $MYVIMRC

" fold python docstrings
au! FileType python setlocal foldenable foldmethod=syntax foldtext=getline(v:foldstart+1)

" open help files in a new tab
au BufRead *.txt call HelpInTab()

" open .help files with same highlighting as actual help files
au BufRead *.help call SetupHelpFiles()

" open any secret files with encryption
au BufRead .secret call StartSecretFile()

" vim functions
"------------------------------------------------------------------------------

function DateThis()
    call setline('.', strftime('%a %D %H:%M'))
endfunction

function HelpInTab()
    if &filetype == 'help'
       execute "normal \<C-W>T"
       set nocursorcolumn nocursorline
    endif
endfunction

function SetupHelpFiles()
    if &filetype != 'help'
        let &filetype='help'
    endif
    set nocursorcolumn nocursorline
endfunction

function StartSecretFile()
    set filetype=yaml
    set noundofile viminfo=
    set nonu nocursorcolumn nocursorline
    set wrap tw=125
    set cc=0 nonu
    set nohlsearch
endfunction

function DemoColors()
    let num = 255
    while num >= 0
        exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
        exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
        call append(0, 'ctermbg='.num.':....')
        let num = num - 1
    endwhile
endfunction

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" highlighting
"------------------------------------------------------------------------------

syntax on
set background=dark

if hostname() == 'arch'

    set cursorline cursorcolumn
    set cc=80

    hi VertSplit      cterm=none      ctermbg=none          ctermfg=none
    hi ColorColumn    cterm=none      ctermbg=white          ctermfg=none
    hi StatusLine     cterm=none      ctermbg=none          ctermfg=none
    hi StatusLineNC   cterm=none      ctermbg=none          ctermfg=none
    hi Tabline        cterm=underline ctermbg=none          ctermfg=none
    hi TablineFill    cterm=underline ctermbg=none          ctermfg=none
    hi TablineSel     cterm=reverse   ctermbg=none          ctermfg=none
    hi cursor         cterm=none      ctermbg=none          ctermfg=none
    hi cursorcolumn   cterm=none      ctermbg=none          ctermfg=none
    hi cursorline     cterm=none      ctermbg=none          ctermfg=none
    hi cursorlinenr   cterm=none      ctermbg=none          ctermfg=none
    hi folded         cterm=none      ctermbg=none          ctermfg=none
    hi linenr         cterm=none      ctermbg=none          ctermfg=none
    hi incsearch      cterm=reverse   ctermbg=none         ctermfg=none
    hi search         cterm=reverse   ctermbg=none         ctermfg=none
    hi specialkey     cterm=none
    hi visual         cterm=reverse   ctermbg=none          ctermfg=none

endif

if hostname() == 'LOGANF-5820'

    let &colorcolumn=join(range(80,999),",")

    highlight folded guibg=red guifg=white
    highlight ColorColumn guibg=#0088FF guifg=white
    highlight StatusLine guibg=white guifg=red
    highlight Tabline guibg=darkmagenta guifg=yellow
    highlight TablineFill guibg=darkmagenta guifg=yellow
    highlight TablineSel guibg=#00FF00 guifg=blue
    highlight linenr gui=bold guibg=#00FF00 guifg=blue
    highlight cursorline guibg=#FF00FF guifg=white
    highlight cursorcolumn guibg=#FF00FF guifg=white
    highlight Visual guibg=#FF00FF guifg=white
    highlight cursor gui=bold guibg=white guifg=red
    highlight cursorlinenr gui=bold guibg=white guifg=red
    highlight visual gui=bold guibg=white guifg=red
    highlight search gui=bold guibg=red guifg=white
    highlight specialkey gui=bold,reverse
    "highlight endofbuffer guibg=orange guifg=blue

endif

