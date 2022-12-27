
local lazy_path = string.format('%s/nvim/lazy/lazy.nvim', vim.env.XDG_DATA_HOME)
if not vim.loop.fs_stat(lazy_path) then vim.fn.system({
	'git', 'clone', '--filter=blob:none', '--single-branch',
	'https://github.com/folke/lazy.nvim.git', lazy_path
}) end vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup({ -- Plugins
	{ -- Git integration
		'lewis6991/gitsigns.nvim',
		enabled = true,
		config = require('plugins.config.gitsigns')
	},
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		dependencies = { 'p00f/nvim-ts-rainbow' },
		config = require('plugins.config.nvim-treesitter')
	},
	{ -- Fuzzy finder
		'nvim-telescope/telescope.nvim',
		enabled = true,
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = require('plugins.config.telescope')
	}
}, {})
