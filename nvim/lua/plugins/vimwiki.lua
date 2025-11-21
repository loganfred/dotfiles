local utils = require("config.utils")

return {
	"vimwiki/vimwiki",
	enabled = not utils.is_external_computer(),

	-- whatever you already had:
	init = function()
		require("config.vimwiki").setup()
	end,
}
