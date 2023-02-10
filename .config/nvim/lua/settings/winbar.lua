local function get_winbar(buf_id)
	local buf_type, name = vim.api.nvim_buf_get_option(buf_id, 'buftype')

	if buf_type == '' or buf_type == 'help' then
		local buf_name = vim.api.nvim_buf_get_name(buf_id)
		name = (buf_name == '' and '') or vim.fn.fnamemodify(buf_name, ':~:p')
	elseif buf_type == 'terminal' then
		name = vim.api.nvim_buf_get_var(buf_id, 'term_title')
	else return '' end

	local modified = vim.api.nvim_buf_get_option(buf_id, 'modified')
	local modifiable = vim.api.nvim_buf_get_option(buf_id, 'modifiable')
	local status = (modified and not modifiable and ' [~]') or (modified and ' [+]') or (modifiable and '') or ' [-]'

	return (name == '' and '') or string.format('%%=%%<%s%s', name, status)
end

local function set_winbar()
	for _,win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf_id = vim.api.nvim_win_get_buf(win_id)
		vim.api.nvim_win_set_option(win_id, 'winbar', get_winbar(buf_id))
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
