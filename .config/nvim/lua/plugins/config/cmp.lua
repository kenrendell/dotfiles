
return function ()
	local cmp = require('cmp')
	local window = cmp.config.window.bordered({
		winhighlight = 'Normal:Normal,FloatBorder:WinSeparator,CursorLine:Visual,Search:None',
		scrollbar = false,
		border = 'single'
	})

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
			{ name = 'path' },
		}),
		window = {
			completion = window,
			documentation = window
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
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
