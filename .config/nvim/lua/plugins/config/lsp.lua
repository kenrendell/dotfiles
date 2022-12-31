
return function ()
	local lspconfig = require('lspconfig')
	local mason_lspconfig = require('mason-lspconfig')

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	mason_lspconfig.setup({
		ensure_installed = { 'clangd', 'sumneko_lua', 'awk_ls', 'bashls', 'marksman' },
		automatic_installation = false
	})

	mason_lspconfig.setup_handlers({
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have
		-- a dedicated handler.
		function (server_name) -- default handler (optional)
			lspconfig[server_name].setup({
				capabilities = capabilities,
				single_file_support = true
			})
		end,

		sumneko_lua = function ()
			lspconfig.sumneko_lua.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.find_git_ancestor,
				single_file_support = true,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = 'LuaJIT',
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {'vim'},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file('', true),
							checkThirdParty = false,
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end
    })
end
