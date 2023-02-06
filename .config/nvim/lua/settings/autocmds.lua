
local function create_autocmd(group, clear, autocmds)
	local group_id = vim.api.nvim_create_augroup(group, { clear = clear })
	for _,autocmd in ipairs(autocmds) do
		autocmd[2].group = group_id
		vim.api.nvim_create_autocmd(autocmd[1], autocmd[2])
	end
end

create_autocmd('terminal-window', true, {
	{ { 'TermOpen', 'WinEnter', 'BufWinEnter' }, { pattern = 'term://*', callback = function () vim.api.nvim_input('i') end } },
	{ 'TermEnter', { pattern = '*', callback = function () vim.opt_local.number, vim.opt_local.relativenumber = false, false end } },
	{ 'TermClose', { pattern = '*', callback = function () vim.api.nvim_input('<Esc>') end } }
})
