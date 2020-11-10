"-------------------------------------------------------------------------------

" home, arch linux
if hostname() == 'mac.attlocal.net' || hostname() == 'mac.local'

    set nocompatible
    filetype plugin on
    syntax on
    setlocal cm=blowfish2

    set nofoldenable

    call plug#begin('~/.vim/plugged')

    "Plug 'VundleVim/Vundle.vim'
    Plug 'davidhalter/jedi-vim'
    " let g:flake8_cmd = 'C:\Users\lfrederick\.conda\envs\vim_32\Scripts\flake8.exe'
    Plug 'nvie/vim-flake8'
    Plug 'https://github.com/vimwiki/vimwiki.git'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'michal-h21/vim-zettel'

    call plug#end()

    let s:main = {}
    let s:main.name = 'private'
    let s:main.path = '~/vimwiki/private'
    let s:main.path_html = '~/vimwiki/html/private'
    let s:main.template_path = '~/vimwiki/private/templates'
    let s:main.template_default = 'main'
    let s:main.template_ext = 'html'
    let s:main.custom_wiki2html = '~/source/blog/convert.py'
    let s:main.links_space_char = '_'
    let s:main.syntax = 'markdown'
    let s:main.automatic_nested_syntaxes = 1
    let s:main.ext = '.md'

    let s:zettelkasten = {}
    let s:zettelkasten.name = 'zettelkasten'
    let s:zettelkasten.path = '~/vimwiki/zettelkasten'
    let s:zettelkasten.path_html = '~/vimwiki/html/public/zettelkasten'
    let s:zettelkasten.template_path = '~/vimwiki/zettelkasten/templates'
    let s:zettelkasten.template_default = 'zettelkasten'
    let s:zettelkasten.template_ext = 'html'
    let s:zettelkasten.custom_wiki2html = '~/source/blog/convert.py'
    let s:zettelkasten.links_space_char = '_'
    let s:zettelkasten.syntax = 'markdown'
    let s:zettelkasten.automatic_nested_syntaxes = 1
    let s:zettelkasten.ext = '.md'
    let s:zettelkasten.auto_toc = 1
    let s:zettelkasten.auto_tags = 1
    let s:zettelkasten.auto_generate_tags = 1
    let s:zettelkasten.auto_generate_links = 1

    let s:writings = {}
    let s:writings.name = 'writings'
    let s:writings.path = '~/vimwiki/writings'
    let s:writings.path_html = '~/vimwiki/html/public/writings'
    let s:writings.template_path = '~/vimwiki/writings/templates'
    let s:writings.template_default = 'article'
    let s:writings.template_ext = 'html'
    let s:writings.custom_wiki2html = '~/source/blog/convert.py'
    let s:writings.links_space_char = '_'
    let s:writings.syntax = 'markdown'
    let s:writings.automatic_nested_syntaxes = 1
    let s:writings.ext = '.md'

    let s:books = {}
    let s:books.name = 'books'
    let s:books.path = '~/vimwiki/books'
    let s:books.path_html = '~/vimwiki/html/public/books'
    let s:books.template_path = '~/vimwiki/books/templates'
    let s:books.template_default = 'books'
    let s:books.template_ext = 'html'
    let s:books.custom_wiki2html = '~/source/blog/convert.py'
    let s:books.links_space_char = '_'
    let s:books.syntax = 'markdown'
    let s:books.ext = '.md'

    let s:recipes = {}
    let s:recipes.name = 'recipes'
    let s:recipes.path = '~/vimwiki/recipes'
    let s:recipes.path_html = '~/vimwiki/html/public/recipes'
    let s:recipes.template_path = '~/vimwiki/recipes/templates'
    let s:recipes.template_default = 'recipes'
    let s:recipes.template_ext = 'html'
    let s:recipes.custom_wiki2html = '~/source/blog/convert.py'
    let s:recipes.links_space_char = '_'
    let s:recipes.syntax = 'markdown'
    let s:recipes.ext = '.md'

    " vim wiki
    let g:vimwiki_list = [s:main, s:zettelkasten, s:writings, s:books, s:recipes]

    let g:vimwiki_global_ext = 0
    let g:vimwiki_listsym_rejected = '/'
    let g:vimwiki_listsyms = ' ◴↻x'
    let g:vimwiki_filetypes = ['markdown', 'pandoc']
    let g:vimwiki_dir_link = 'index'
    let g:vimwiki_folding = 'expr:quick'
    let g:vimwiki_auto_chdir = 1
    let g:vimwiki_auto_header = 1
    let g:vimwiki_automatic_nested_syntaxes = 1
    let g:vimwiki_markdown_link_ext = 1
    "" let g:vimwiki_conceal_pre = 1

    " vim zettel
    let g:zettel_options = [{},
                            \{'zettelkasten':{'tags': ''},
                            \'template': '~/vimfiles/zettelkasten/template.tpl'}]

    let g:zettel_format = "%y%m%d-%H%M-%title"

    " mappings for vimwiki / vimzettel
    nnoremap <leader>vt :VimwikiSearchTags<space>
    nnoremap <leader>vs :VimwikiSearch<space>
    nnoremap <leader>bl :VimwikiBacklinks<cr>
    nnoremap <leader>gt :VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>
    nnoremap <leader>zs :ZettelSearch<cr>
    nnoremap <leader>zn :ZettelNew<space>
    nnoremap <leader>zo :ZettelOpen<cr>

    function! VimwikiLinkHandler(link)
    " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
    "   1) [[vfile:~/Code/PythonProject/abc123.py]]
    "   2) [[vfile:./|Wiki Home]]
    let link = a:link
    if link =~# '^vfile:'
      let link = link[1:]
    else
      return 0
    endif
    let link_infos = vimwiki#base#resolve_link(link)
    if link_infos.filename == ''
      echomsg 'Vimwiki Error: Unable to resolve link!'
      return 0
    else
      exe 'tabnew ' . fnameescape(link_infos.filename)
      return 1
    endif
    endfunction

    " remember to update 508: ~/.vim/plugged/vimwiki/ftdetect/vimwiki.vim

endif

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

" shortcut to open vimrc
nnoremap <leader>v<leader>v :e $MYVIMRC<cr>

" turn off hlsearch
nnoremap <leader><leader> :nohlsearch<cr>

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

" tabs in makefiles
au! FileType make setlocal noexpandtab

" set makefile command for tex documents
au! FileType tex setlocal makeprg=pdflatex\ %\ &&\ open\ %:p:t:r.pdf

" obnoxious crosshairs, but only in normal mode
au! InsertEnter * setlocal nocursorline nocursorcolumn
au! InsertLeave * setlocal cursorline cursorcolumn

" configure gcc for :make
au! FileType c setlocal makeprg=gcc\ %

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

" set indentation lower for vimwiki files
au FileType vimwiki.markdown.pandoc setlocal ts=2 sts=2 sw=2 expandtab

" vim functions
"------------------------------------------------------------------------------
function DateThis()
    call setline('.', strftime('%a %D %H:%M'))
endfunction

function HelpInTab()
    if &filetype == 'help'
       " execute "normal \<C-W>T"
       set nocursorcolumn nocursorline
       nnoremap <buffer> <Down> <C-e>
       nnoremap <buffer> <Up> <C-y>
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

else
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

