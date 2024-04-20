
local lazy_path = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath('data'))
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
		enabled = true,
		dependencies = {
			'williamboman/mason.nvim',
			'jay-babu/mason-null-ls.nvim',
		}, config = require('plugins.config.null-ls')
	},
	{ -- LSP configurations
		'neovim/nvim-lspconfig',
		enabled = true,
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-nvim-lsp',
		}, config = require('plugins.config.lsp')
	},
	{ -- Snippet Engine
		'L3MON4D3/LuaSnip',
		enabled = true,
		dependencies = {
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
		}, config = require('plugins.config.luasnip')
	},
	{ -- Auto-completion
		'hrsh7th/nvim-cmp',
		enabled = true,
		dependencies = {
			'L3MON4D3/LuaSnip',
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'onsails/lspkind.nvim',
		}, config = require('plugins.config.cmp')
	},
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		build = ':TSUpdate',
		event = 'BufReadPost',
		dependencies = {
			'p00f/nvim-ts-rainbow' -- no longer maintained (see 'HiPhish/nvim-ts-rainbow2')
		}, config = require('plugins.config.treesitter')
	},
	{ -- A collection of language packs for Vim.
		'sheerun/vim-polyglot',
		enabled = true
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
		enabled = true,
		config = require('plugins.config.comment')
	},
	{ -- Git decorations
		'lewis6991/gitsigns.nvim',
		enabled = true,
		config = require('plugins.config.gitsigns')
	},
	{ -- Easily install luarocks with lazy.nvim
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{ -- Note taking
		'nvim-neorg/neorg',
		enabled = true,
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'luarocks.nvim',
		}, config = require('plugins.config.neorg')
	},
	{ -- Note taking assistant
		'zk-org/zk-nvim',
		enabled = true,
		dependencies = { 'hrsh7th/cmp-nvim-lsp' },
		config = require('plugins.config.zk')
	},
}, {
	install = {
		missing = true,
		colorscheme = { 'terminal-colors' }
	},
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = 'single',
		icons = {}
	}
})
