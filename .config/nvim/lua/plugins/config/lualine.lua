-- 'lewis6991/gitsigns.nvim' plugin configuration

local c = {}

c.options = {
	theme = 'tokyonight',
}

return function () require('lualine').setup(c) end
