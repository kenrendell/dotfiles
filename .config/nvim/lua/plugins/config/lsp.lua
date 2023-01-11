
local window_border = 'single'
local map = vim.keymap.set
local opts = { remap = false, silent = false }

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = window_border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = window_border })
vim.diagnostic.config({ float = { border = window_border }})

map('n', '<leader>do', vim.diagnostic.open_float, opts)
map('n', '<leader>d[', vim.diagnostic.goto_prev, opts)
map('n', '<leader>d]', vim.diagnostic.goto_next, opts)
map('n', '<leader>dl', vim.diagnostic.setloclist, opts)

return function ()
	local lspconfig = require('lspconfig')
	local mason_lspconfig = require('mason-lspconfig')
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
	require('lspconfig.ui.windows').default_options.border = window_border

	mason_lspconfig.setup({
		ensure_installed = { 'arduino_language_server', 'clangd', 'sumneko_lua', 'awk_ls', 'bashls', 'ltex', 'texlab', 'marksman' },
		automatic_installation = false
	})

	mason_lspconfig.setup_handlers({
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have
		-- a dedicated handler.
		function (server_name) -- default handler (optional)
			lspconfig[server_name].setup({
				capabilities = capabilities
			})
		end,

		ltex = function ()
			-- see https://github.com/vigoux/ltex-ls.nvim
			lspconfig.ltex.setup({
				capabilities = capabilities,
				settings = { -- see https://valentjn.github.io/ltex/settings.html
					ltex = {
						language = 'en-US',
						completionEnabled = false,
						checkFrequency = 'edit',
						diagnosticSeverity = 'information'
					}
				},
				on_attach = function (_, bufnr)
					local opts = { buffer = bufnr, remap = false, silent = false }
					map('n', '<leader>la', vim.lsp.buf.code_action, opts)
				end
			})
		end,

		sumneko_lua = function ()
			lspconfig.sumneko_lua.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern('.git', 'lua'),
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
