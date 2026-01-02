local utils = require("config.utils")

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

if utils.is_external_computer() then
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
else
	SlickOpen("v", DotFiles("nvim/init.lua"))
	SlickOpen("l", "~/vimwiki/zettelkasten/240212-1015-links.md", true)
	SlickOpen("?", "~/vimwiki/zettelkasten/230401-1055-howto.md", true)
end

vim.api.nvim_set_keymap("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-k>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-l>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})

vim.api.nvim_set_keymap("n", "<Leader>qf", [[<Cmd> lua vim.diagnostic.setqflist()<CR>]], {})

vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	FzfLua.complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

vim.api.nvim_set_keymap("n", "<F12>", [[<Cmd>lua require"fzf-lua".files({ cwd = vim.fn.stdpath("config") })<CR>]], {})

-- implicit headers with ;;h
vim.keymap.set("i", ";;h", function()
	require("fzf-lua").fzf_exec(vim.fn["vimwiki#base#get_anchors"](vim.fn.expand("%:p"), "markdown"), {
		complete = function(selected, _, line, col)
			if not selected or not selected[1] then
				return line, col
			end
			local anchor = selected[1]
			local new = line:sub(1, col) .. "[" .. anchor .. "]" .. line:sub(col + 1)
			return new, col + #anchor + 2
		end,
	})
end)

if vim.env.VIMWIKI_PATH then
	vim.api.nvim_set_keymap(
		"n",
		"<F2>",
		[[<Cmd>lua require"fzf-lua".files({ cwd = vim.env.VIMWIKI_PATH, cmd = "fd -e md || find . -name '*.md'" })<CR>]],
		{}
	)
end
