
local c = {}

c.extensions = {
	file_browser = {
		theme = "ivy",
		-- disables netrw and use telescope-file-browser in its place
		hijack_netrw = true,
		mappings = {
			["i"] = {
				-- your custom insert mode mappings
			},
			["n"] = {
				-- your custom normal mode mappings
			},
		},
	},
}

return function ()
	local telescope = require('telescope')
	telescope.setup(c)

	telescope.load_extension('file_browser')
end
