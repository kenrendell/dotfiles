local function get_winbar(buf_id)
	local buf_type = vim.api.nvim_buf_get_option(buf_id, 'buftype')
	if buf_type ~= '' and buf_type ~= 'help' then return end

	local buf_name = vim.api.nvim_buf_get_name(buf_id)
	if buf_name == '' then return end

	local stat = vim.loop.fs_stat(buf_name)
	if not stat or stat.type ~= 'file' then return end

	local dir, file = buf_name:match('^(.*/)([^/]+)$')
	local modified = vim.api.nvim_buf_get_option(buf_id, 'modified')
	local modifiable = vim.api.nvim_buf_get_option(buf_id, 'modifiable')

	return table.concat({
		'%#WinBar#%=%<%#WinBarDir#', dir,
		(modified and '%#WinBarFileModified#') or '%#WinBarFile#', file,
		' %#WinBarBuffer#', buf_id, '%#WinBar#',
		(modified and not modifiable and '[~]') or (modified and '[+]') or (modifiable and '') or '[-]'
	})
end

local function set_winbar()
	for _,win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf_id = vim.api.nvim_win_get_buf(win_id)
		vim.api.nvim_win_set_option(win_id, 'winbar', get_winbar(buf_id) or '')
	end
end

local group_id = vim.api.nvim_create_augroup('window-bar', { clear = true })

vim.api.nvim_create_autocmd(
	{ 'VimEnter', 'WinEnter', 'BufWinEnter', 'BufModifiedSet', 'BufFilePost', 'CmdwinEnter' },
	{ group = group_id, callback = function () set_winbar() end }
)

vim.api.nvim_create_autocmd('OptionSet', {
	pattern = { 'modified', 'modifiable' },
	callback = function () set_winbar() end,
	group = group_id
})
