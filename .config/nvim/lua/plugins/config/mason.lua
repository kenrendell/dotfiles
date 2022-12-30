
local c = {}

c.ui = {
	border = 'single'
}

return function ()
	require('mason').setup(c)
	require('mason').setup({}) end
