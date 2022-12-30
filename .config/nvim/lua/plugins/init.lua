
local lazy_path = string.format('%s/nvim/lazy/lazy.nvim', vim.fn.stdpath('data'))
if not vim.loop.fs_stat(lazy_path) then vim.fn.system({
	'git', 'clone', '--filter=blob:none', '--single-branch',
	'https://github.com/folke/lazy.nvim.git', lazy_path
}) end vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup({ -- Plugins
	{ -- Portable package manager
		'williamboman/mason.nvim',
		enabled = true,
		config = require('plugins.config.mason')
	},
	{ -- Debugger
		'mfussenegger/nvim-dap',
		enabled = false,
		dependencies = {
			'williamboman/mason.nvim',
			'jay-babu/mason-nvim-dap.nvim',
		}, config = require('plugins.config.dap')
	},
	{ -- LSP client for non-LSP sources
		'jose-elias-alvarez/null-ls.nvim',
		enabled = false,
		dependencies = {
			'williamboman/mason.nvim',
			'jay-babu/mason-null-ls.nvim',
		}, config = require('plugins.config.null-ls')
	},
	{ -- LSP configurations
		'neovim/nvim-lspconfig',
		enabled = true,
		event = 'BufReadPre',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		}, config = require('plugins.config.lsp')
	},
	{ -- Snippet Engine
		'L3MON4D3/LuaSnip',
		enabled = true,
		dependencies = { 'rafamadriz/friendly-snippets' },
		config = require('plugins.config.luasnip')
	},
	{ -- Auto-completion
		'hrsh7th/nvim-cmp',
		enabled = true,
		event = 'InsertEnter',
		dependencies = { -- see 'https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources'
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
		}, config = require('plugins.config.cmp')
	},
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		build = ':TSUpdate',
		event = 'BufReadPost',
		dependencies = { 'p00f/nvim-ts-rainbow' },
		config = require('plugins.config.treesitter')
	},
	{ -- Fuzzy finder
		'nvim-telescope/telescope.nvim',
		enabled = true,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
		}, config = require('plugins.config.telescope')
	},
	{ -- Commenter
		'numToStr/Comment.nvim',
		enabled = false,
		config = require('plugins.config.comment')
	},
	{ -- Git decorations
		'lewis6991/gitsigns.nvim',
		enabled = true,
		config = require('plugins.config.gitsigns')
	},
	{ -- Note taking
		'nvim-neorg/neorg',
		enabled = true,
		build = ':Neorg sync-parsers', ft = 'norg',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = require('plugins.config.neorg')
	},
	{ -- Note taking assistant
		'mickael-menu/zk-nvim',
		enabled = false,
		config = require('plugins.config.zk')
	},
}, {
	install = {
		missing = true,
		colorscheme = { 'ansi' }
	},
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = 'single',
		icons = {}
	}
})
