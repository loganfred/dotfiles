-- nvim-treesitter `main` branch: no more module system.
-- Parsers are installed imperatively, highlight/indent are enabled per-buffer.
-- Available parsers: :lua =require("nvim-treesitter").get_available()
local ensure_installed = {
	"arduino",
	"bibtex",
	"bitbake",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"csv",
	"html",
	"json",
	"jq",
	"kconfig",
	-- "latex", -- throws warnings
	"lua",
	"markdown",
	"markdown_inline",
	"nginx",
	"objdump",
	"powershell",
	"python",
	"regex",
	"toml",
	"typst",
	"udev",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
	-- "zsh", -- not installable
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Skips anything already present; runs async.
		require("nvim-treesitter").install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang then
					return
				end
				-- Returns nil when the parser isn't installed yet (e.g. first launch).
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if not ok or not added then
					return
				end

				vim.treesitter.start(ev.buf, lang)
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
