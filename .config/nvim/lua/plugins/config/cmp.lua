
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
			{ name = 'path' },
		}),
		window = {
			completion = cmp.config.window.bordered({
				winhighlight = 'CursorLine:PmenuSel,Search:None',
				border = 'single',
				scrolloff = 2,
			}),
			documentation = cmp.config.window.bordered({
				winhighlight = '',
				border = 'single'
			})
		},
		formatting = {
			format = require('lspkind').cmp_format({
				mode = 'text',
				maxwidth = 50,
				ellipsis_char = '...',
				menu = {
					buffer = '[Buffer]',
					nvim_lsp = '[LSP]',
					nvim_lsp_signature_help = '[LSP-signature]',
					nvim_lua = '[Lua]',
					luasnip = '[Snip]',
					path = '[Path]',
					cmdline = '[Command]',
				}
			})
		},
		experimental = { ghost_text = true },
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

	--[[ cmp.event:on('menu_closed', function ()
		vim.api.nvim_exec_autocmds('WinEnter', { group = 'window-bar' })
	end) ]]
end
