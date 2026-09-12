- `blink` is for text completion
- `conform` is for lsp formatting on save
- `fzf-lua` is for finding files, etc
- `which-key` is for discovering normal commands
- `wordy` is for spell checking weasel words and business jargon

There's also the usual tpope plugins:

- `vim-sensible`
- `vim-surround`
- `vim-vinegar`
- `vim-speeddating`
- `vim-repeat`

`mason-lspconfig` took hours to figure out.

It is not necessary to have a plugin file for `mason.nvim` or `nvim-lspconfig` if you use `mason-lspconfig`. Attempting to do so will cause issues.

`mason` installs LSPs and `nvim-lspconfig` makes configuration files to spin the LSPs up and down automatically as-needed. The confusion is that `vim-lspconfig` uses different LSP names than `mason` does. For example, 
`lua_ls` is the `vim-lspconfig` name, but `mason` uses `lua-language-server`.

`mason-lspconfig` unifies things. Use `:h lspconfig-all` to find the names of the LSP you are interested in.

Be sure to run `:checkhealth mason` and possibly `:MasonLog` if there are installation errors. In my case I did not realize I lacked `npm` and `go` to install certain LSPs, but the default error message suggested I was instead using the wrong package name.

```lua
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = true,
		ensure_installed = {
			"basedpyright",
			"clangd",
			"cmake",
			"lua_ls",
			"stylua"
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
```
