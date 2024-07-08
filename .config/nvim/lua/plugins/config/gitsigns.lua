-- 'lewis6991/gitsigns.nvim' plugin configuration

local c = {}

-- c.signs = {
-- 	add          = { text = '+', hl = 'GitSignsAdd'    },
-- 	change       = { text = '+', hl = 'GitSignsChange' },
-- 	delete       = { text = '_', hl = 'GitSignsDelete' },
-- 	topdelete    = { text = '^', hl = 'GitSignsDelete' },
-- 	changedelete = { text = '~', hl = 'GitSignsChange' },
-- }

return function () require('gitsigns').setup(c) end
