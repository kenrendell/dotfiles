-- Bootstrap lazy.nvim
local lazy_path = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath('data'))
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
	local lazy_repo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--single-branch', lazy_repo, lazy_path })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end vim.opt.runtimepath:prepend(lazy_path)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
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
	{ -- Colorscheme
		'folke/tokyonight.nvim',
		enabled = true,
		lazy = false,
		priority = 1000,
		config = require('plugins.config.tokyonight')
	},
	{ -- Status Line
		'nvim-lualine/lualine.nvim',
		enabled = true,
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		}, config = require('plugins.config.lualine')
	},
	{ -- Buffer Line
		'akinsho/bufferline.nvim',
		enabled = true,
		version = '*',
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		}, config = require('plugins.config.bufferline')
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
		config = require('plugins.config.treesitter')
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
	{ -- Note taking
		'nvim-neorg/neorg',
		enabled = true,
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = '*', -- Pin Neorg to the latest stable release
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'folke/tokyonight.nvim',
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
		colorscheme = { 'tokyonight' }
	},
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = 'single',
	},
	rocks = { enabled = true }
})
