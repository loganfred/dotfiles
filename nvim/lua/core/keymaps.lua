vim.keymap.set("n", "<Leader><Leader>", vim.cmd.nohl, { noremap = true, silent = true })

local function SlickOpen(key, filename, append)
	if vim.tbl_contains({ "j", "h", "t" }, key) then
		error(string.format('E999: key "%s" is reserved and cannot be used here', key))
	end

	local goto_end = (not append) and " " or " + "
	local options = { noremap = true, silent = true }

	local function open_with(win_cmd)
		local function f()
			vim.cmd(win_cmd .. goto_end .. vim.fn.fnameescape(filename))
		end
		return f
	end

	vim.keymap.set("n", "<Leader>" .. key .. key, open_with("edit"), options)
	vim.keymap.set("n", "<Leader>" .. key .. "j", open_with("split"), options)
	vim.keymap.set("n", "<Leader>" .. key .. "h", open_with("vsplit"), options)
	vim.keymap.set("n", "<Leader>" .. key .. "t", open_with("tabedit"), options)
end

-- Assumes ~/personal or ~/professional for Linux
local function PersonalNotesFiles(file)
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Linux" then
		return "~/personal/notes/" .. file
	end
	return "~/Source/personal/notes/" .. file
end

local function CompanyNotesFiles(file)
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Linux" then
		return "~/professional/notes/" .. file
	end
	return "~/Source/professional/notes/"
end

local function DotFiles(file)
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Linux" then
		return "~/personal/gh_dotfiles/" .. file
	end
	return "~/Source/personal/gh_dotfiles/" .. file
end

SlickOpen("a", CompanyNotesFiles("acronyms.tsv"))
SlickOpen("i", CompanyNotesFiles("master_control_trainings.md"))
SlickOpen("p", PersonalNotesFiles("win_provisioning.md"))
SlickOpen("q", CompanyNotesFiles("qms.tsv"))
SlickOpen("s", "C:\\ProgramData\\sioyek")
SlickOpen("g", DotFiles("glazeWM/config.yaml"))
SlickOpen("z", DotFiles("glazeWM/config.yaml"))
SlickOpen("v", DotFiles("nvim/init.lua"))
--SlickOpen('f', DotFiles('pwsh/Microsoft.PowerShell_profile.ps1'))
SlickOpen("?", PersonalNotesFiles("howto.md"), true)
SlickOpen("l", PersonalNotesFiles("links_and_learnings.md"), true)

vim.api.nvim_set_keymap("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-k>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-l>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})

vim.api.nvim_set_keymap("n", "<F12>", [[<Cmd>lua require"fzf-lua".files({ cwd = '~/.config' })<CR>]], {})
