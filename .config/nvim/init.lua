-- NEOVIM Configuration file

require('settings.statusline')
require('settings.tabline')
require('settings.options')
require('settings.autocmds')
require('settings.mappings')

require('packman.setup') {
	-- Additional module for nvim-treesitter
	'https://github.com/p00f/nvim-ts-rainbow.git',

	-- Dependency for gitsigns and telescope plugin
	'https://github.com/nvim-lua/plenary.nvim.git',

	{ -- Highlighting
		'https://github.com/nvim-treesitter/nvim-treesitter.git',
		config = 'plugin-config/nvim-treesitter.lua'
	},

	{ -- Git decorations
		'https://github.com/lewis6991/gitsigns.nvim.git',
		config = 'plugin-config/gitsigns.lua'
	},

	{ -- Fuzzy finder
		'https://github.com/nvim-telescope/telescope.nvim.git',
		config = 'plugin-config/telescope.lua'
	},

	{ -- File explorer tree
		'https://github.com/kyazdani42/nvim-tree.lua.git',
		config = 'plugin-config/nvim-tree.lua'
	},

	{ -- Commenter
		'https://github.com/numToStr/Comment.nvim.git',
		config = 'plugin-config/comment.lua'
	},
	
	{ -- Debugger
		'https://github.com/mfussenegger/nvim-dap.git',
		config = 'plugin-config/nvim-dap.lua'
	},

	{ -- Notes
		'https://github.com/nvim-neorg/neorg',
		config = 'plugin-config/neorg.lua'
	},

	{
		'https://github.com/mickael-menu/zk-nvim',
		config = 'plugin-config/zk-nvim.lua'
	}
}
