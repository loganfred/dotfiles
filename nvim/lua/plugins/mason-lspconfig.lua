-- automatically installs and enables servers by translating between lspconfig and mason names
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = true,
		ensure_installed = {
			"basedpyright",
			"bashls",
			"clangd",
			"cmake",
			"cssls",
			"jqls",
			"jsonls",
			"lua_ls",
			"powershell_es",
			"stylua",
			"systemd_ls",
			"yamlls",
			"html",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
