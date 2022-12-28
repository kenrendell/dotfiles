local c = {}

c.history = true
c.enable_autosnippets = true

return function ()
	require('luasnip.loaders.from_vscode').lazy_load()
	require('luasnip').config.set_config(c)
end
