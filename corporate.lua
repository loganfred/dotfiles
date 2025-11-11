-- cmd to powershell
vim.cmd([[
    let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
	let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=[System.Management.Automation.OutputRendering]::PlainText;Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
	let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
	let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
	set shellquote= shellxquote=
]])


-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = '~/.local/bin/pynvim-python.exe'

--[[
" PLUGINS
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-sensible'   " defaults we can all agree on
Plug 'tpope/vim-vinegar'    "  combine with netrw for a delicious salad dressing
Plug 'tpope/vim-surround'    " change surrounding tags with ease
Plug 'tpope/vim-fugitive'    " a git wrapper so awesome it should be illegal
Plug 'tpope/vim-speeddating'    " increment/decrement dates, times, etc
Plug 'preservim/vim-wordy'    " increment/decrement dates, times, etc
]]

require("lazy").setup({
    spec = {{ "mason-org/mason.nvim",
	          "neovim/nvim-lspconfig",
              "tpope/vim-sensible",
              "tpope/vim-vinegar",
              "tpope/vim-surround",
              "tpope/vim-fugitive",
              "tpope/vim-speeddating",
              "preservim/vim-wordy"
              }},
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true }})

require('mason').setup()

vim.lsp.config('basedpyright', {
    on_attach = function(client, bufnr)
          vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
              return { abbr = item.label:gsub("%b()", "") }
            end,
          })
          vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
        end})


vim.lsp.enable('basedpyright')  -- for python
vim.lsp.enable('clangd')        -- for c/c++

vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.g.filetype_md = "pandoc"
vim.g.mapleader = "\\"
vim.opt.listchars = "tab:>-,trail:$,space:·,nbsp:┚,precedes:→"
vim.opt.list = true
vim.opt.laststatus = 2

vim.opt.fileencoding = "utf-8"

vim.opt.smartcase = true
vim.opt.showcmd = true

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


-- Assumes ~/personal or ~/professional for Linux
local function PersonalNotesFiles(file)
    local sysname = vim.loop.os_uname().sysname
    if (sysname == 'Linux') then
        return '~/personal/notes/' .. file
    end
    return '~/Source/personal/notes/' .. file
end

local function CompanyNotesFiles(file)
    local sysname = vim.loop.os_uname().sysname
    if (sysname == 'Linux') then
        return '~/professional/notes/' .. file
    end
	return '~/Source/professional/notes/'
end

local function DotFiles(file)
    local sysname = vim.loop.os_uname().sysname
    if (sysname == 'Linux') then
        return '~/personal/gh_dotfiles/' .. file
    end
    return '~/Source/personal/gh_dotfiles/' .. file
end

SlickOpen('a', CompanyNotesFiles('acronyms.tsv'))
SlickOpen('i', CompanyNotesFiles('master_control_trainings.md'))
SlickOpen('p', PersonalNotesFiles('win_provisioning.md'))
SlickOpen('q', CompanyNotesFiles('qms.tsv'))
SlickOpen('s', 'C:\\ProgramData\\sioyek')
SlickOpen('g', DotFiles('glazeWM/config.yaml'))
SlickOpen('z', DotFiles('glazeWM/config.yaml'))
SlickOpen('v', DotFiles('corporate.lua'))
SlickOpen('f', DotFiles('pwsh/Microsoft.PowerShell_profile.ps1'))
SlickOpen('?', PersonalNotesFiles('howto.md'), true)
SlickOpen('l', PersonalNotesFiles('links_and_learnings.md'), true)


vim.g.mapleader = '\\'
vim.cmd([[colorscheme elflord]])

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

local write_augroup = vim.api.nvim_create_augroup("MyWriteAutocmds", { clear = true })

-- Create an autocommand for the 'BufWritePre' event
vim.api.nvim_create_autocmd("BufWritePre", {
  group = write_augroup, -- Assign the autocommand to the created group
  pattern = "*.cpp|*.h",     -- Optional: Specify a pattern to match (e.g., all Lua files)
  callback = function()
    vim.diagnostic.setqflist()
  end,
  desc = "My custom autocommand on write", -- Optional: A description for the autocommand
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


vim.g.netrw_liststyle = 3


-- make fuzzy finding work as expected
vim.opt.completeopt = 'fuzzy,menuone,noselect,popup'

vim.cmd([[:inoremap <Down> <C-R>=pumvisible() ? "\<lt>tab>" : "\<lt>Ctrl-y>"<CR>]])

vim.cmd([[
    " [How to get group name of highlighting under cursor in vim? - Stack
    " Overflow](https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim)
    function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
	call setreg("", synIDattr(l:s, 'name'))
    endfun
    nnoremap gs :call SynGroup()<CR>
]])


vim.cmd([[
    hi Search guifg=black guibg=cyan
    hi CurSearch guifg=black guibg=magenta
    hi PandocAtxHeader guifg=violet
    hi PandocAtxStart guifg=violet
    hi PandocAtxStart guifg=violet
    hi Operator guifg=cyan
    hi Title guifg=violet
]])
