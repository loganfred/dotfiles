-- symlink to install
--  e.g. ln -s ~/source/dotfiles/nvim ~/.config/nvim


local utils = require('utils')

-- load plugins, including:
--
--  - vim-sensible      defaults we can all agree on
--  - vim-sleuth        heuristically set buffer options
--  - vim-vinegar       combine with netrw for a delicious salad dressing
--  - vim-surround      change surrounding tags with ease
--  - vim-fugitive      a git wrapper so awesome it should be illegal
--  - vim-speeddating   increment/decrement dates, times, etc
--
--  - jedi-vim          python
--  - vim-flake8        python linting
--  - fzf.vim           fuzzy-finding
--
--  - vimwiki           wiki editing
--  - vim-zettel        zettelkasten

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-sensible',
    'tpope/vim-sleuth',
    'tpope/vim-vinegar',
    'tpope/vim-surround',
    'tpope/vim-fugitive',
    'tpope/vim-speeddating',
    'davidhalter/jedi-vim',
    'nvie/vim-flake8',
    { 'junegunn/fzf', build = ':call fzf#install()' },
    'junegunn/fzf.vim',
    { 'vimwiki/vimwiki',
      lazy = false,
      cond = utils.is_personal_computer(),
  },
  {
      'michal-h21/vim-zettel',
      lazy = false,
      cond = utils.is_personal_computer(),
      init = function()
        require('vimwiki').setup()
      end,
      dependencies = { 'vimwiki/vimwiki' }
  },
  {
      dir = "~/.config/nvim/lua/provisioning",
      name = "provisioning_plugin",
      config = function()
          require("provisioning").setup({})
      end
  }
})


vim.opt.list = true
vim.opt.listchars = "tab:>-,trail:$,space:·,nbsp:┚,precedes:→"
vim.opt.laststatus = 2

vim.opt.fileencoding = "utf-8"

vim.opt.smartcase = true
vim.opt.showcmd = true

vim.g.filetype_md = 'pandoc'
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.splitbelow = true

local function SlickOpen(key, filename, append)

  if vim.tbl_contains({'j', 'h', 't'}, key) then
    error(string.format('E999: key "%s" is reserved and cannot be used here', key))
  end

  local goto_end = (not append) and ' ' or ' + '
  local options = { noremap = true, silent = true }

  local function open_with(win_cmd)
    local function f() vim.cmd(win_cmd .. goto_end .. vim.fn.fnameescape(filename)) end
    return f
  end

  vim.keymap.set('n', '<Leader>' .. key .. key, open_with('edit'), options)
  vim.keymap.set('n', '<Leader>' .. key .. 'j', open_with('split'), options)
  vim.keymap.set('n', '<Leader>' .. key .. 'h', open_with('vsplit'), options)
  vim.keymap.set('n', '<Leader>' .. key .. 't', open_with('tabedit'), options)
end

if utils.is_external_computer() then

    local function NotesFiles(file)
        return '~/Source/notes/' .. file
    end

    local function DotFiles(file)
        return '~/Source/dotfiles/' .. file
    end

    SlickOpen('a', NotesFiles('acronyms.tsv'))
    SlickOpen('i', NotesFiles('master_control_trainings.md'))
    SlickOpen('p', NotesFiles('win_provisioning.md'))
    SlickOpen('q', NotesFiles('qms.tsv'))
    SlickOpen('s', 'C:\\ProgramData\\sioyek')
    SlickOpen('v', DotFiles('init.vim'))
    SlickOpen('f', NotesFiles('Microsoft.PowerShell_profile.ps1'))
    SlickAppend('?', NotesFiles('howto.md'), true)
    SlickAppend('l', NotesFiles('links_and_learnings.md'), true)
else
    SlickOpen('p', utils.build_path('VIMWIKI_PATH', '~/vimwiki/zettelkasten/250726-1604-new_computer.md'))
    SlickOpen('v', vim.fn.expand('$MYVIMRC'))
    --SlickOpener('f', NotesFiles('Microsoft.PowerShell_profile.ps1'))
    SlickOpen('?', utils.build_path('VIMWIKI_PATH', 'zettelkasten/230401-1055-howto.md'), true)
    --SlickAppend("l", NotesFiles("links_and_learnings.md"))

end


vim.g.mapleader = '\\'
vim.cmd([[colorscheme retrobox]])

vim.opt.statusline = 'Editing: %f %y %M'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Leader><Leader>', vim.cmd.nohl, { noremap = true, silent = true })

-- autocommands

local help_group = vim.api.nvim_create_augroup("HelpInTab", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = help_group,
    pattern = 'help',
    callback = function()
        vim.cmd("wincmd T")
    end,
    desc = "Open help files in a new tab"
})

local crosshair_group = vim.api.nvim_create_augroup("Crosshairs", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    group = crosshair_group,
    pattern = '*',
    callback = function()
        vim.opt.cursorline = false
        vim.opt.cursorcolumn = false
    end,
    desc = "Disable crosshairs in insert mode"
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = crosshair_group,
    pattern = '*',
    callback = function()
        vim.opt.cursorline = true
        vim.opt.cursorcolumn = true
    end,
    desc = "Enable crosshairs except in insert mode"
})

local pandoc_group = vim.api.nvim_create_augroup("PandocOpts", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = pandoc_group,
    callback = function()
        in_f = vim.fn.expand('%')
        out_f = vim.fn.expand('%:r') .. '.pdf'
        vim.opt.makeprg = 'pdflatex ' .. in_f

        if vim.fn.has('win32') or vim.fn.has('win64') then
            if utils.has_binary('sioyek') then
                vim.opt.makeprg = vim.opt.makeprg .. ' && sioyek ' .. out_f
            elseif vim.opt.shell:get() == 'cmd' then
                vim.opt.makeprg = vim.opt.makeprg .. ' && start.exe ' .. out_f
            elseif vim.opt.shell:get() == 'pwsh' then
                vim.opt.makeprg = string.format('(%s) -and (Invoke-Item %s)',
                                                vim.opt.makeprg,
                                                out_f)
            end
        elseif vim.fn.has('mac') then
            vim.opt.makeprg = vim.opt.makeprg .. ' && open ' .. out_f
        end
    end
    })

vim.g.netrw_liststyle = 3

vim.keymap.set('n', '<Leader><Leader>', vim.cmd.nohl, { noremap = true, silent = true })

-- make fuzzy finding work as expected
vim.opt.completeopt = 'fuzzy,menuone,longest,preview'
vim.cmd([[inoremap <silent><expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"]])
vim.cmd([[inoremap <silent><expr> J pumvisible() ? "\<C-n>" : "J"]])
vim.cmd([[inoremap <silent><expr> K pumvisible() ? "\<C-p>" : "K"]])
vim.cmd([[inoremap <silent><expr> <esc> pumvisible() ? "\<C-e>" : "\<esc>"]])
vim.cmd([[inoremap <silent> ;; <C-x><C-o>]])
vim.cmd([[inoremap <silent><expr> ;f FZF()]])

