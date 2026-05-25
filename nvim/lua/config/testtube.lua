vim.filetype.add({
	extension = {
		["🧪"] = "testtube",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "testtube",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4

		vim.wo.foldmethod = "indent"
		vim.wo.foldlevel = 99
		vim.wo.foldenable = true

		vim.schedule(function()
			vim.api.nvim_set_hl(0, "TestTubeVerifyStatement", { link = "Operator" })
			vim.api.nvim_set_hl(0, "TestTubeNoteStatement", { link = "Conceal" })
			vim.api.nvim_set_hl(0, "TestTubeNAStatement", { link = "Conceal" })
			vim.api.nvim_set_hl(0, "TestTubeCommentStatement", { link = "Comment" })
			vim.api.nvim_set_hl(0, "TestTubeTBD", { link = "Todo" })
			vim.api.nvim_set_hl(0, "TestTubeTODO", { link = "Error" })
			vim.api.nvim_set_hl(0, "TestTubeSRS", { link = "Tag" })
		end)
	end,
})
