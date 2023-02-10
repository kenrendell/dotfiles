local function get_tab_item(current_tab, tab, tab_id)
	local wins = #vim.api.nvim_tabpage_list_wins(tab_id)
	local win_id = vim.api.nvim_tabpage_get_win(tab_id)
	local buf_id = vim.api.nvim_win_get_buf(win_id)
	local buf_name = vim.api.nvim_buf_get_name(buf_id)
	local modified = vim.api.nvim_buf_get_option(buf_id, 'modified')
	local modifiable = vim.api.nvim_buf_get_option(buf_id, 'modifiable')

	local tab_name = (buf_name == '' and '') or string.format('%s ', vim.fn.fnamemodify(buf_name, ':t'))
	local tab_index = string.format(' %s%s%s ', tab, (wins > 1 and string.format('.%s', wins))
	or '', (modified and not modifiable and '[~]') or (modified and '[+]') or (modifiable and '') or '[-]')

	return {
		string.format('%%%sT%%%s*', tab,
		(current_tab == tab and ((modified and '2') or '1')) or (modified and '4') or '3'),
		tab_index, tab_name, '%*%T', length = #tab_index + #tab_name
	}
end

function Tabline()
	local tabs = { length = 0 }
	local current_tab = vim.api.nvim_tabpage_get_number(0)
	local tab_ids = vim.api.nvim_list_tabpages()
	local last_tab = #tab_ids

	local prev_sym, sep_sym, next_sym = '<|', '|', '|>'
	local columns = vim.o.columns

	for tab,tab_id in ipairs(tab_ids) do
		local tab_item = get_tab_item(current_tab, tab, tab_id)
		local next_sym_len = (tab < last_tab and #next_sym) or 0

		if tab > 1 and tabs.length + ((#tabs > 0 and #sep_sym) or 0) + tab_item.length + next_sym_len > columns then
			if current_tab < tab then table.insert(tabs, next_sym) break end
			tabs, tab_item[1], tab_item.length = { length = 0 }, string.format('%s%s', prev_sym, tab_item[1]), tab_item.length + #prev_sym
		elseif #tabs > 0 then tab_item[1], tab_item.length = string.format('%s%s', sep_sym, tab_item[1]), tab_item.length + #sep_sym end

		if current_tab == tab and #tabs == 0 and tab_item.length + next_sym_len > columns then
			local tab_name = tab_item[3]
			tab_item.length = tab_item.length + next_sym_len
			tab_item[3] = (tab_item.length - columns >= #tab_name and '|')
			or string.format('%s|', string.sub(tab_name, 1, columns - (tab_item.length + 2)))
			tab_item.length = tab_item.length - (#tab_name - #tab_item[3])
		end

		tabs.length = tabs.length + tab_item.length
		table.insert(tabs, table.concat(tab_item))
	end

	table.insert(tabs, 1, '%<')
	return table.concat(tabs)
end

vim.opt.showtabline = 2
vim.opt.tabline = '%!luaeval("Tabline()")'
