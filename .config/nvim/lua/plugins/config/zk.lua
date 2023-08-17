local c, map = {}, vim.keymap.set

c.picker = 'telescope'
c.lsp = {}

c.lsp.config = {
	name = 'zk',
	cmd = { 'zk', 'lsp' },
	root_dir = vim.env.ZK_NOTEBOOK_DIR
	-- see 'vim.lsp.start_client()' for other options
}

c.lsp.auto_attach = {
	enabled = true,
	filetypes = { "markdown" }
}

c.lsp.config.on_attach = function (_, bufnr)
	local opts = { buffer = bufnr, remap = false, silent = true }
	local commands = require('zk.commands')

	-- Open the link under the caret.
	map('n', '<CR>', vim.lsp.buf.definition, opts)

	-- Preview a linked note.
	map('n', 'K', vim.lsp.buf.hover, opts)

	-- Open the code actions for a visual selection.
	map('v', '<leader>na', vim.lsp.buf.code_action, opts)

	-- Open notes linking to the current buffer.
	map('n', '<leader>nb', commands.get('ZkBacklinks'), opts)

	-- Open notes linked by the current buffer.
	map('n', '<leader>nf', commands.get('ZkLinks'), opts)

	-- Inserts a link at the cursor location.
	map('n', '<leader>ni', commands.get('ZkInsertLink'), opts)

	-- Inserts a link around the selected text.
	map('v', '<leader>ni', [[:'<,'>ZkInsertLinkAtSelection<CR>]], opts)
end

return function ()
	local zk = require('zk')
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local opts = { remap = false, silent = false }

	c.lsp.config.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	zk.setup(c) -- Setup LSP and builtin commands
	local commands = require('zk.commands')

	-- Create a new note after asking for its title.
	map('n', '<leader>nn', function () zk.new({ dir = 'main', title = vim.fn.input('Title: ') }) end, opts)

	-- Index the notes to be searchable.
	map("n", "<leader>nx", function () zk.index({ force = false }) end, opts)
	map("n", "<leader>nX", function () zk.index({ force = true }) end, opts)

	-- Open notes and edit the selected note.
	map("n", "<leader>no", function () commands.get('ZkNotes')({ sort = { 'modified' } }) end, opts)

	-- Open notes and edit the selected note associated with the selected tags.
	map("n", "<leader>nt", commands.get('ZkTags'), opts)
end
