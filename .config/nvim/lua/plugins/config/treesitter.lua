-- 'nvim-treesitter/nvim-treesitter' plugin configuration

local c = {}

c.ensure_installed = {
	'arduino', 'bash', 'c', 'cmake', 'comment', 'cpp', 'css',
	'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
	'go', 'gomod', 'gowork', 'help', 'html', 'http', 'json', 'julia',
	'latex', 'llvm', 'lua', 'make', 'markdown', 'markdown_inline',
	'meson', 'ninja', 'norg', 'python', 'regex', 'rust', 'toml',
	'verilog', 'vim', 'yaml', 'zig',
}

c.highlight = { enable = true }
c.incremental_selection = { enable = true }

return function () require('nvim-treesitter.configs').setup(c) end
