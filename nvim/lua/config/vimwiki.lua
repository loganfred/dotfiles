local M = {}

utils = require("config.utils")

-- First, let's define a function to get the current zettel ID
local function get_zettel_id()
	if vim.g.zettel_current_id then
		return vim.g.zettel_current_id
	else
		return "unnamed"
	end
end

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

	local content = {
		name = "content",
		path = utils.build_path("VIMWIKI_PATH", "content"),
		path_html = utils.build_path("VIMWIKI_PATH", "html/public/content"),
		template_path = utils.build_path("VIMWIKI_PATH", "content/templates"),
		template_default = "content",
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

	return { main, zettelkasten, writings, content, recipes }
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
			front_matter = {
				{ "title", "" },
				{ "created", "" },
				{ "id", get_zettel_id },
				{ "modified", "" },
				{ "tags", "" },
				{ "type", "note" },
				{ "status", "draft" },
				{ "summary", "" },
				{ "keywords", "" },
			},
			template = vim.fn.expand("~/.config/nvim/zettel_template.tpl"),
		},
	}
	vim.g.zettel_format = "%y%m%d-%H%M-%title"
	vim.g.zettel_date_format = "%Y-%m-%d %H:%M"
	vim.g.zettel_default_title = "untitled"
end

-- Autocommand to update the 'modified' field on save
local function setup_modified_autocmd()
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function()
			-- Wrap everything in pcall to catch errors
			local ok, err = pcall(function()
				-- Silent check: only proceed if vimwiki.markdown.pandoc
				if vim.bo.filetype ~= "vimwiki.markdown.pandoc" then
					return
				end

				local wiki_nr = vim.b.vimwiki_wiki_nr
				if not wiki_nr then
					error("No wiki_nr found in buffer")
				end

				-- Only process wiki #2 (index 1)
				if wiki_nr ~= 1 then
					return
				end

				local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
				local in_frontmatter = false
				local modified_line = nil

				for i, line in ipairs(lines) do
					if line:match("^---$") then
						if not in_frontmatter then
							in_frontmatter = true
						else
							-- End of frontmatter
							break
						end
					elseif in_frontmatter and line:match("^modified:") then
						modified_line = i - 1
						break
					end
				end

				if modified_line then
					local timestamp = vim.fn.strftime("%Y-%m-%d %H:%M")
					vim.api.nvim_buf_set_lines(
						0,
						modified_line,
						modified_line + 1,
						false,
						{ "modified: " .. timestamp }
					)
				end
			end)

			-- Only notify on error
			if not ok then
				vim.notify("Error updating modified field: " .. tostring(err), vim.log.levels.ERROR)
			end
		end,
	})
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
	setup_modified_autocmd()
end

return M
