
local function get_winbar(bufnr)
	local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
	local modifiable = vim.api.nvim_buf_get_option(bufnr, 'modifiable')
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local fname = (bufname == '' and '') or vim.fn.fnamemodify(bufname, ':~:p')
	local status = (modified and not modifiable and ' [~]') or (modified and ' [+]') or (modifiable and '') or ' [-]'
	return string.format('%%=%%<%%%d*%s%%*%s', (modified and 4) or 3, fname, status)
end

local function set_winbar()
	for _,winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local bufnr = vim.api.nvim_win_get_buf(winnr)
		vim.api.nvim_win_set_option(winnr, 'winbar', get_winbar(bufnr))
	end
end

local group_id = vim.api.nvim_create_augroup('window-bar', { clear = true })

vim.api.nvim_create_autocmd(
	{ 'VimEnter', 'WinEnter', 'BufWinEnter', 'BufModifiedSet', 'BufFilePost' },
	{ group = group_id, callback = function () set_winbar() end }
)

vim.api.nvim_create_autocmd('OptionSet', {
	pattern = { 'modified', 'modifiable' },
	callback = function () set_winbar() end,
	group = group_id
})
