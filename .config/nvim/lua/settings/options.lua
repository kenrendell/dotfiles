
local temp_file_dirs = { set = function(self)
	for opt, dir in pairs(self) do if type(dir) == 'string' then
		dir = string.match(dir, '^(.+[^/])/*$')
		if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
		vim.opt[opt] = string.format('%s//', dir)
	end end
end }

-- Create and set directories for backup files
temp_file_dirs.directory = string.format('%s/nvim/swap', vim.env.XDG_STATE_HOME)
temp_file_dirs.backupdir = string.format('%s/nvim/backup', vim.env.XDG_STATE_HOME)
temp_file_dirs.undodir = string.format('%s/nvim/undo', vim.env.XDG_STATE_HOME)
temp_file_dirs:set()

vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupcopy = 'auto'
vim.opt.backupext = '.bak'

vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
