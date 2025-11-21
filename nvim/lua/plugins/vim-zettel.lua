-- lua/plugins/vim-zettel.lua
local utils = require("config.utils")

return {
	"michal-h21/vim-zettel",
	enabled = not utils.is_external_computer(),

	dependencies = { "vimwiki/vimwiki" }, -- if you had this
	-- config / keys / etc…
}
