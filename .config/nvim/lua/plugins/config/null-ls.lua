
return function ()
	local null_ls = require('null-ls')
	local mason_null_ls = require('mason-null-ls')

	mason_null_ls.setup({
		ensure_installed = { 'shellcheck' },
		automatic_installation = false,
		automatic_setup = true
	})

	--[[
	mason_null_ls.setup_handlers({
		function (source_name, methods)
			require("mason-null-ls.automatic_setup")(source_name, methods)
		end
	}) --]]

	null_ls.setup()
end
