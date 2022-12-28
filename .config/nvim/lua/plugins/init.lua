
local lazy_path = string.format('%s/nvim/lazy/lazy.nvim', vim.env.XDG_DATA_HOME)
if not vim.loop.fs_stat(lazy_path) then vim.fn.system({
	'git', 'clone', '--filter=blob:none', '--single-branch',
	'https://github.com/folke/lazy.nvim.git', lazy_path
}) end vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup({ -- Plugins
	{ -- Treesitter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		build = ':TSUpdate',
		event = 'BufReadPost',
		dependencies = { 'p00f/nvim-ts-rainbow' },
		config = require('plugins.config.nvim-treesitter')
	},
	{ -- Portable package manager
		'williamboman/mason.nvim',
		enabled = false,
		config = require('plugins.config.mason')
	},
	{ -- LSP configurations
		'neovim/nvim-lspconfig',
		enabled = true,
		event = 'BufReadPre',
		dependencies = { 'hrsh7th/cmp-nvim-lsp' },
		config = require('plugins.config.nvim-lspconfig')
	},
	{ -- LSP client for non-LSP sources
		'jose-elias-alvarez/null-ls.nvim',
		enabled = false,
		config = require('plugins.config.null-ls')
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
			'saadparwaiz1/cmp_luasnip', -- luasnip
			'hrsh7th/cmp-nvim-lsp-signature-help', -- nvim_lsp_signature_help
			'hrsh7th/cmp-nvim-lsp', -- nvim_lsp
			'hrsh7th/cmp-nvim-lua', -- nvim_lua
			'hrsh7th/cmp-cmdline', -- cmdline
			'hrsh7th/cmp-buffer', -- buffer
			'hrsh7th/cmp-path', -- path
		}, config = require('plugins.config.nvim-cmp')
	},
	{ -- Debugger
		'mfussenegger/nvim-dap',
		enabled = false,
		config = require('plugins.config.nvim-dap')
	},
	{ -- Fuzzy finder
		'nvim-telescope/telescope.nvim',
		enabled = true,
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = require('plugins.config.telescope')
	},
	{ -- Commenter
		'numToStr/Comment.nvim',
		enabled = false,
		config = require('plugins.config.comment')
	},
	{ -- Git integration
		'lewis6991/gitsigns.nvim',
		enabled = true,
		config = require('plugins.config.gitsigns')
	},
	{ -- Note taking
		'nvim-neorg/neorg',
		enabled = false,
		config = require('plugins.config.neorg')
	},
	{ -- Note taking assistant
		'mickael-menu/zk-nvim',
		enabled = false,
		config = require('plugins.config.zk-nvim')
	},
}, {
	install = {
		missing = true,
		colorscheme = nil
	}
})
