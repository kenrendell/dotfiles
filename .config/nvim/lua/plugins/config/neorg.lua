
local c = {}

c.load = {}

c.load['core.defaults'] = {}
c.load['core.dirman'] = {
	config = {
		workspaces = {
			notes = string.format('%s/Neorg/notes', vim.env.XDG_DOCUMENTS_DIR),
			tasks = string.format('%s/Neorg/tasks', vim.env.XDG_DOCUMENTS_DIR)
		},
		index = 'index.norg'
	}
}

return function () require('neorg').setup(c) end
