-- cmd to powershell

if vim.loop.os_uname().sysname == "Windows_NT" then
	vim.cmd([[
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=[System.Management.Automation.OutputRendering]::PlainText;Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
        let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
        let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
        set shellquote= shellxquote=
    ]])
end

vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.listchars = "tab:>-,trail:$,space:·,nbsp:┚,precedes:→"
vim.opt.list = true
vim.opt.laststatus = 2
vim.opt.fileencoding = "utf-8"
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.statusline = "Editing: %f %y %M"
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
