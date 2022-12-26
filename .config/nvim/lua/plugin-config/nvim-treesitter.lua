-- 'nvim-treesitter/nvim-treesitter' plugin configuration

local c = {}

c.ensure_installed = 'maintained'
c.highlight = { enable = true }
c.incremental_selection = { enable = true }
c.rainbow = {
	enable = true,
	extended_mode = true,
	max_file_lines = nil
}

require('nvim-treesitter.configs').setup(c)
