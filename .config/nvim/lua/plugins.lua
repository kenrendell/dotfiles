-- Plugin configurations

local fn = vim.fn
local install_path, packer, packer_bootstrap = fn.stdpath('data')
	.. '/site/pack/packer/start/packer.nvim'

-- Install the plugin manager 'packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system(
		'git clone --depth 1 https://github.com/wbthomason/packer.nvim '
		.. install_path)

	if fn.empty(fn.glob(install_path)) > 0 then return nil end
end packer = require('packer')

-- Packer configuration
return packer.startup(function(use)
	-- Plugin manager
	use 'wbthomason/packer.nvim'

	use { -- Syntax highlighting
		'nvim-treesitter/nvim-treesitter',
		requires = 'p00f/nvim-ts-rainbow',
		config = loadfile('plugin_config/nvim-treesitter.lua')
	}

	use { -- Fuzzy finder
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = loadfile('plugin_config/telescope.lua')
	}

	use { -- Git decorations
		'lewis6991/gitsigns.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = loadfile('plugin_config/gitsigns.lua')
	}

	use { -- File explorer tree
		'kyazdani42/nvim-tree.lua',
		config = loadfile('plugin_config/nvim-tree.lua')
	}

	-- Automatically set-up configuration after installing packer.nvim
	if packer_bootstrap then packer.sync() end
end)
