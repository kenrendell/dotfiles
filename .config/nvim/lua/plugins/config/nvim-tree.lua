-- 'kyazdani42/nvim-tree.lua' plugin configuration

local g, map, c = vim.g, vim.api.nvim_set_keymap, {}

g.nvim_tree_show_icons = { git = 0, folders = 0, files = 0, folder_arrows = 0 }
g.nvim_tree_icons = { default = '' }
g.nvim_tree_add_trailing = 0
g.nvim_tree_symlink_arrow = ' -> '
g.nvim_tree_indent_markers = 1

map('n', '<leader>ff', ':NvimTreeFocus<CR>', { noremap = true })
map('n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true })
map('n', '<leader>fr', ':NvimTreeRefresh<CR>', { noremap = true })
map('n', '<leader>fs', ':NvimTreeFindFile<CR>', { noremap = true })

c.disable_netrw = true
c.hijack_netrw = true
c.hijack_cursor = true
c.update_cwd = false

return function () require('nvim-tree').setup(c) end
