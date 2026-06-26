vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
			format = {
				enable = false, -- set to false if you use a different formatter (e.g., conform.nvim)
			},
		},
	},
})
