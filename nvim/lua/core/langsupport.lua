vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Disable checking of third-party libraries
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global and other globals
				globals = { "vim", "require" },
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = false, -- set to false if you use a different formatter (e.g., conform.nvim)
			},
		},
	},
})
