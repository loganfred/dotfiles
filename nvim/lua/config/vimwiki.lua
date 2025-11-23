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
	vim.g.zettel_fzf_options = {
		"--exact",
		"--tiebreak=end",
		"--preview-window=right:50%:wrap:~1", -- Larger preview, hide first line
		"--delimiter=:",
		"--with-nth=1,3..", -- Show filename and content, skip line numbers
		"--info=inline",
		"--layout=reverse",
		"--border=rounded",
	}
end

-- Set up search for all wikis
local function setup_all_wiki_zk_search()
	-- Create a custom command to search across all wikis with wiki-prefixed markdown links
	vim.api.nvim_create_user_command("ZettelSearchAll", function()
		local all_paths = {}
		local wiki_map = {} -- Map paths to wiki names

		for i, wiki in ipairs(vim.g.vimwiki_list) do
			-- Expand ~ and make absolute
			local expanded_path = vim.fn.fnamemodify(wiki.path, ":p")
			-- Remove trailing slash for consistency
			expanded_path = expanded_path:gsub("/$", "")

			table.insert(all_paths, expanded_path)
			wiki_map[expanded_path] = {
				name = wiki.name,
				index = i - 1, -- 0-indexed
			}
		end

		-- Build rg command to search all wiki paths
		local search_paths = table.concat(all_paths, " ")
		local fzf_command =
			string.format("rg --column --line-number --no-heading --color=always --smart-case . %s", search_paths)

		-- Custom sink function to insert wiki-prefixed markdown link
		local function insert_link(selected)
			-- Handle different input types from FZF
			local line
			if type(selected) == "string" then
				line = selected
			elseif type(selected) == "table" and #selected > 0 then
				line = selected[1]
			else
				vim.notify("No selection", vim.log.levels.WARN)
				return
			end

			if not line or line == "" then
				return
			end

			-- Parse: filename:line:col:content
			local filepath = line:match("^([^:]+)")

			if not filepath then
				vim.notify("Could not parse filepath from: " .. line, vim.log.levels.ERROR)
				return
			end

			-- Expand to absolute path and normalize
			filepath = vim.fn.fnamemodify(filepath, ":p")
			filepath = filepath:gsub("/$", "")

			-- Determine which wiki this file belongs to
			local wiki_name = nil
			local wiki_idx = nil
			local rel_path = nil

			for path, info in pairs(wiki_map) do
				if filepath:sub(1, #path) == path then
					wiki_name = info.name
					wiki_idx = info.index
					rel_path = filepath:sub(#path + 2) -- +2 to skip path and /
					rel_path = rel_path:gsub("%.md$", "") -- Remove .md extension
					break
				end
			end

			if not wiki_name or not rel_path then
				vim.notify("Could not determine wiki for: " .. filepath, vim.log.levels.ERROR)
				return
			end

			-- Get the title from the file
			local title_cmd =
				string.format("grep -m 1 '^title:' %s 2>/dev/null | sed 's/^title: *//'", vim.fn.shellescape(filepath))
			local title = vim.fn.system(title_cmd):gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")

			-- If no title found, use filename
			if title == "" then
				title = vim.fn.fnamemodify(rel_path, ":t")
			end

			-- Create wiki-prefixed markdown link: [title](wikiN:rel_path)
			local link = string.format("[%s](wiki%d:%s)", title, wiki_idx, rel_path)
			-- Insert the link at cursor
			local pos = vim.api.nvim_win_get_cursor(0)
			local line_content = vim.api.nvim_get_current_line()
			local new_line = line_content:sub(1, pos[2]) .. link .. line_content:sub(pos[2] + 1)
			vim.api.nvim_set_current_line(new_line)

			-- Move cursor after the inserted link
			vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #link })
		end

		vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
			source = fzf_command,
			sink = insert_link,
			options = {
				"--ansi",
				"--exact",
				"--preview-window=down:50%:wrap",
				"--header=📚 All Wikis Search (Ctrl-C to cancel)",
				"--delimiter=:",
				"--with-nth=1,3..",
				"--preview",
				"bat --color=always --style=numbers --line-range=:500 {1} 2>/dev/null || cat {1}",
			},
		}))
	end, {})

	-- Map it in zettelkasten for both insert and normal mode
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vimwiki.markdown.pandoc",
		callback = function()
			if vim.b.vimwiki_wiki_nr == 1 then -- zettelkasten wiki
				-- Override [[ in insert mode
				vim.keymap.set("i", "[[", function()
					vim.cmd("ZettelSearchAll")
				end, { buffer = true, desc = "Search all wikis and insert link" })

				-- Also provide normal mode mapping
				vim.keymap.set(
					"n",
					"<leader>zsa",
					"<Cmd>ZettelSearchAll<CR>",
					{ buffer = true, desc = "Search all wikis" }
				)
			end
		end,
	})
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
	setup_all_wiki_zk_search()
end

return M
