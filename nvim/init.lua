vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = "~/.local/bin/pynvim-python.exe"
vim.g.filetype_md = "pandoc"

vim.cmd([[:inoremap <Down> <C-R>=pumvisible() ? "\<lt>tab>" : "\<lt>Ctrl-y>"<CR>]])

vim.cmd([[colorscheme elflord]])
vim.cmd([[
    hi Search guifg=black guibg=cyan
    hi CurSearch guifg=black guibg=magenta
    hi PandocAtxHeader guifg=violet
    hi PandocAtxStart guifg=violet
    hi PandocAtxStart guifg=violet
    hi Operator guifg=cyan
    hi Title guifg=violet
]])

require("config.lazy")
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.funcs")
