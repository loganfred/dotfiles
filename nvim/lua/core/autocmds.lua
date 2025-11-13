local annoying_cursors = vim.api.nvim_create_augroup("annoying_cursors", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function()
		vim.cmd([[wincmd T]])
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre", "FileReadPost" }, {
	pattern = { "*.cpp", "*.h", "*.c", "*.hpp", "*.py" },
	callback = vim.diagnostic.setqflist,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	callback = function()
		vim.opt.cursorcolumn = false
		vim.opt.cursorline = false
	end,
	group = annoying_cursors,
	desc = "Annoying Cursors",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		vim.opt.cursorcolumn = true
		vim.opt.cursorline = true
	end,
	group = annoying_cursors,
	desc = "Annoying Cursors",
})
