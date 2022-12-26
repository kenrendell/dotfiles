local tabpagenr = vim.fn.tabpagenr
local tabpagewinnr = vim.fn.tabpagewinnr
local tabpagebuflist = vim.fn.tabpagebuflist
local bufname = vim.fn.bufname
local getbufvar = vim.fn.getbufvar
local fnamemodify = vim.fn.fnamemodify

local function get_tab_item(current_tab, tab)
	local splits = tabpagewinnr(tab, '$')
	local buffer_id = tabpagebuflist(tab)[tabpagewinnr(tab)]
	local buffer_name = bufname(buffer_id)
	local modified = getbufvar(buffer_id, '&modified') == 1
	local modifiable = getbufvar(buffer_id, '&modifiable') == 1

	local tab_name = (buffer_name == '' and '') or string.format('%s ', fnamemodify(buffer_name, ':t'))
	local tab_index = string.format(' %s%s%s ', tab, (splits > 1 and string.format('.%s', splits))
	or '', (modified and not modifiable and '[~]') or (modified and '[+]') or (modifiable and '') or '[-]')

	return {
		string.format('%%%sT%%%s*', tab,
		(current_tab == tab and ((modified and '2') or '1')) or (modified and '4') or '3'),
		tab_index, tab_name, '%*%T', length = #tab_index + #tab_name
	}
end

function tabline()
	local tabs = { length = 0 }
	local current_tab, last_tab = tabpagenr(), tabpagenr('$')
	local prev_sym, sep_sym, next_sym = '<|', '|', '|>'
	local columns = vim.o.columns

	for tab = 1, last_tab, 1 do
		local tab_item = get_tab_item(current_tab, tab)
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
vim.opt.tabline = '%!luaeval("tabline()")'
