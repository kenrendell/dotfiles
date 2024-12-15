local set = vim.opt
local temp_file_dirs = { set = function(self)
	for opt, dir in pairs(self) do if type(dir) == 'string' then
		dir = string.match(dir, '^(.+[^/])/*$')
		if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
		set[opt] = string.format('%s//', dir)
	end end
end }

-- Create and set directories for backup files
temp_file_dirs.directory = string.format('%s/nvim/swap', vim.env.XDG_STATE_HOME)
temp_file_dirs.backupdir = string.format('%s/nvim/backup', vim.env.XDG_STATE_HOME)
temp_file_dirs.undodir = string.format('%s/nvim/undo', vim.env.XDG_STATE_HOME)
temp_file_dirs:set()

set.backup = true
set.writebackup = true
set.backupcopy = 'auto'
set.backupext = '.bak'

set.undofile = true
set.undolevels = 1000
set.undoreload = 10000

vim.cmd('filetype plugin indent on')

set.cursorline = true

-- Command window
set.cmdheight = 1
set.cmdwinheight = 10

set.title = false
set.autoread = true
set.wildmenu = true

vim.opt.shortmess:append('I')

-- Indentation
set.autoindent = true
set.smartindent = true
set.smarttab = true
set.expandtab = false
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4

-- Scrolling
set.wrap = false
set.sidescrolloff = 4
set.scrolloff = 4

-- Searching
set.inccommand = 'nosplit'
set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true

-- Line number
set.number = true
set.relativenumber = true
set.numberwidth = 5

-- Decorations
set.list = true
set.ambiwidth = 'single'
set.listchars = { tab = '> ' , trail = '-', extends = '>', precedes = '<', nbsp = '+' }
set.fillchars = {
	stl = ' ', stlnc = ' ', wbr = ' ',
	horiz = '─', horizup = '┴', horizdown = '┬',
	vert = '│', vertleft = '┤', vertright = '├', verthoriz = '┼',
	fold = '·', foldopen = '-', foldclose = '+', foldsep = '│',
	diff = '-', msgsep = '─', eob = '~'
}

-- Spelling
set.spelllang = 'en_us'

-- Folding
set.foldenable = true
set.foldmethod = 'indent'
--set.foldlevel = 20

-- Windows
set.equalalways = true
set.eadirection = 'both'
set.winminheight = 1
set.winminwidth = 1
set.splitbelow = true
set.splitright = true

-- Clipboard
set.clipboard:append('unnamedplus')

-- Highlighting
vim.cmd.colorscheme('tokyonight')
