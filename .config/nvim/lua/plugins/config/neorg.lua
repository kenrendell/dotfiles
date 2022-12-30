
local c = {}

c.load = {}

c.load['core.defaults'] = {}
c.load['core.norg.dirman'] = {
	config = {
		workspaces = {
			home = string.format('%s/Notes', vim.env.XDG_DATA_HOME)
		}
	}
}

return function () require('neorg').setup(c) end
