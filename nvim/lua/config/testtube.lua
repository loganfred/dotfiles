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

		vim.api.nvim_set_hl(0, "TestTubeAction", { link = "Normal" })
		vim.api.nvim_set_hl(0, "TestTubeExpectedResult", { fg = "#888888" }) -- gray
		vim.api.nvim_set_hl(0, "TestTubeNotes", { fg = "#ff66cc" }) -- pink
	end,
})
