
local c = {}

c.load = {}

c.load['core.defaults'] = {}
c.load['core.concealer'] = {}
c.load['core.dirman'] = {
	config = {
		workspaces = {
			notes = string.format('%s/Neorg/notes', vim.env.XDG_DOCUMENTS_DIR),
			tasks = string.format('%s/Neorg/tasks', vim.env.XDG_DOCUMENTS_DIR)
		},
		default_workspace = 'notes'
	}
}

return function ()
	require('neorg').setup(c)

	vim.wo.foldlevel = 99
	vim.wo.conceallevel = 3
end
