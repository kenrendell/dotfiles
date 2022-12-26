-- DO NOT EDIT --

local add = _G.packman.add

add {
	loaded = false,
	installed = true,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/nvim-ts-rainbow',
	url = 'https://github.com/p00f/nvim-ts-rainbow.git',
}

add {
	loaded = false,
	installed = true,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/plenary.nvim',
	url = 'https://github.com/nvim-lua/plenary.nvim.git',
}

add {
	loaded = false,
	installed = true,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/nvim-treesitter',
	url = 'https://github.com/nvim-treesitter/nvim-treesitter.git',
	config = 'plugin-config/nvim-treesitter.lua',
}

add {
	loaded = false,
	installed = true,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/gitsigns.nvim',
	url = 'https://github.com/lewis6991/gitsigns.nvim.git',
	config = 'plugin-config/gitsigns.lua',
}

add {
	loaded = false,
	installed = true,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/telescope.nvim',
	url = 'https://github.com/nvim-telescope/telescope.nvim.git',
	config = 'plugin-config/telescope.lua',
}

add {
	loaded = false,
	installed = false,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/nvim-tree.lua',
	url = 'https://github.com/kyazdani42/nvim-tree.lua.git',
	config = 'plugin-config/nvim-tree.lua',
}

add {
	loaded = false,
	installed = false,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/Comment.nvim',
	url = 'https://github.com/numToStr/Comment.nvim.git',
	config = 'plugin-config/comment.lua',
}

add {
	loaded = false,
	installed = false,
	dir = '/home/kenrendell/.local/share/nvim/site/pack/packman/opt/nvim-dap',
	url = 'https://github.com/mfussenegger/nvim-dap.git',
	config = 'plugin-config/nvim-dap.lua',
}