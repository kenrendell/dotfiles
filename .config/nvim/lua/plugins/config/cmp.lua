
return function ()
	local cmp = require('cmp')

	vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

	cmp.setup({
		snippet = {
			expand = function (args)
				require('luasnip').lsp_expand(args.body)
			end
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
		}, {
			{ name = 'nvim_lsp_signature_help' },
			{ name = 'nvim_lua' },
			{ name = 'buffer' },
		})
	})

	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {{ name = 'buffer' }}
	})

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
	})
end
