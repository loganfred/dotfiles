local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command("augroup " .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.iter({ "autocmd", def }):flatten():totable(), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

local autoCommands = {
	-- other autocommands
	open_folds = { { "BufReadPost,FileReadPost", "*", "normal zR" } },
	help_in_tab = { { "FileType", "help", "normal <ctrl-w>T" } },
	quick_fix = {
		{ "BufWritePre,FileReadPost", "c", "lua vim.diagnostic.setqflist()" },
		{ "BufWritePre,FileReadPost", "cpp", "lua vim.diagnostic.setqflist()" },
		{ "BufWritePre,FileReadPost", "h", "lua vim.diagnostic.setqflist()" },
	},
	cursors = {
		{ "InsertEnter", "*", "set nocursorcolumn nocursorline" },
		{ "InsertLeave", "*", "set cursorcolumn cursorline" },
	},
}

M.nvim_create_augroups(autoCommands)
