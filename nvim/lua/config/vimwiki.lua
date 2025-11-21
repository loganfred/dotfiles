local M = {}

utils = require("config.utils")

-- Wiki configurations
local function create_wiki_configs()
	local main = {
		name = "private",
		path = utils.build_path("VIMWIKI_PATH", "private"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/private"),
		template_path = utils.build_path("VIMWIKI_PATH", "private/templates"),
		template_default = "main",
		template_ext = "html",
		--custom_wiki2html = '~/source/blog/convert.py',
		links_space_char = "_",
		syntax = "markdown",
		automatic_nested_syntaxes = 1,
		ext = ".md",
	}

	local zettelkasten = {
		name = "zettelkasten",
		path = utils.build_path("VIMWIKI_PATH", "zettelkasten"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/public/zettelkasten"),
		template_path = utils.build_path("VIMWIKI_PATH", "zettelkasten/templates"),
		template_default = "zettelkasten",
		template_ext = "html",
		-- custom_wiki2html = '~/source/blog/convert.py',
		links_space_char = "_",
		syntax = "markdown",
		automatic_nested_syntaxes = 1,
		ext = ".md",
		auto_toc = 1,
		auto_tags = 1,
		auto_generate_tags = 1,
		auto_generate_links = 1,
	}

	local writings = {
		name = "writings",
		path = utils.build_path("VIMWIKI_PATH", "writings"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/public/writings"),
		template_path = utils.build_path("VIMWIKI_PATH", "writings/templates"),
		template_default = "article",
		template_ext = "html",
		-- custom_wiki2html = '~/source/blog/convert.py',
		links_space_char = "_",
		syntax = "markdown",
		automatic_nested_syntaxes = 1,
		ext = ".md",
	}

	local books = {
		name = "books",
		path = utils.build_path("VIMWIKI_PATH", "books"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/public/books"),
		template_path = utils.build_path("VIMWIKI_PATH", "books/templates"),
		template_default = "books",
		template_ext = "html",
		-- custom_wiki2html = '~/source/blog/convert.py',
		links_space_char = "_",
		syntax = "markdown",
		ext = ".md",
	}

	local recipes = {
		name = "recipes",
		path = utils.build_path("VIMWIKI_PATH", "recipes"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/public/recipes"),
		template_path = utils.build_path("VIMWIKI_PATH", "recipes/templates"),
		template_default = "recipes",
		template_ext = "html",
		-- custom_wiki2html = '~/source/blog/convert.py',
		links_space_char = "_",
		syntax = "markdown",
		ext = ".md",
	}

	return { main, zettelkasten, writings, books, recipes }
end

-- Set up vimwiki global options
local function setup_vimwiki_globals()
	vim.g.vimwiki_list = create_wiki_configs()
	vim.g.vimwiki_global_ext = 0
	vim.g.vimwiki_listsym_rejected = "/"
	vim.g.vimwiki_listsyms = " ◴↻x"
	vim.g.vimwiki_filetypes = { "markdown", "pandoc" }
	vim.g.vimwiki_dir_link = "index"
	vim.g.vimwiki_folding = "expr:quick"
	vim.g.vimwiki_auto_chdir = 1
	vim.g.vimwiki_auto_header = 1
	vim.g.vimwiki_automatic_nested_syntaxes = 1
	vim.g.vimwiki_markdown_link_ext = 1
	-- vim.g.vimwiki_conceal_pre = 1
end

-- Set up zettel options
local function setup_zettel_globals()
	vim.g.zettel_options = {
		{},
		{
			zettelkasten = {
				tags = "",
				template = "~/vimfiles/zettelkasten/template.tpl",
			},
		},
	}
	vim.g.zettel_format = "%y%m%d-%H%M-%title"
end

-- Set up keymaps
local function setup_keymaps()
	local keymap = vim.keymap.set
	keymap("n", "<leader>vt", ":VimwikiSearchTags ", { desc = "Search vimwiki tags" })
	keymap("n", "<leader>vs", ":VimwikiSearch ", { desc = "Search vimwiki" })
	keymap("n", "<leader>bl", ":VimwikiBacklinks<CR>", { desc = "Show backlinks" })
	keymap("n", "<leader>gt", ":VimwikiRebuildTags!<CR>:VimwikiGenerateTagLinks<CR><C-l>", { desc = "Generate tags" })
	keymap("n", "<leader>zs", ":ZettelSearch<CR>", { desc = "Search zettel" })
	keymap("n", "<leader>zn", ":ZettelNew ", { desc = "New zettel" })
	keymap("n", "<leader>zo", ":ZettelOpen<CR>", { desc = "Open zettel" })
end

-- Set up custom link handler
local function setup_link_handler()
	vim.g.vimwiki_link_handler = function(link)
		if not link:match("^vfile:") then
			return 0
		end

		local file_link = link:sub(2) -- Remove 'v' from 'vfile:'
		local link_infos = vim.fn["vimwiki#base#resolve_link"](file_link)

		if link_infos.filename == "" then
			vim.api.nvim_echo({ { "Vimwiki Error: Unable to resolve link!", "ErrorMsg" } }, true, {})
			return 0
		else
			vim.cmd("tabnew " .. vim.fn.fnameescape(link_infos.filename))
			return 1
		end
	end
end

-- Main setup function
function M.setup()
	utils.check_env_var("VIMWIKI_PATH", "vimwiki configuration")
	setup_vimwiki_globals()
	setup_zettel_globals()
	setup_keymaps()
	setup_link_handler()
end

return M
