
--[[
==== Tab management ====

 F{1..12}          := Move focus to tab 1 - 12.
 shift + F{1..12}  := Move current tab to tab 1 - 12.
 alt + ctrl + n    := Move focus to next tab.
 alt + ctrl + p    := Move focus to previous tab.
 alt + ctrl + i    := Insert new tab.
 alt + ctrl + u    := Close current tab.
 alt + ctrl + o    := Close all tabs except the current tab.

==== Window management ====

 alt + shift + {a, s, w, d}  := Resize current window.
 alt + ctrl + shift + {h, j, k, l}  := Move current window focus to the {left, bottom, top, right}.
 alt + ctrl + {h, j, k, l}   := Move current window to be at the far {left, bottom, top, right}.
 alt + e                     := Edit new window in horizontal split.
 alt + shift + e             := Edit new window in vertical split.
 alt + r                     := Equalize all windows.
 alt + shift + r             := Maximize the current window.
 alt + x                     := Close all windows except the current window.
 alt + shift + x             := Move current window to new tab.
 alt + q                     := Save (if changed) and close the current window.
 alt + shift + q             := Close (without checking for changes) the current window.
--]]

vim.g.mapleader = ' '
local map = vim.keymap.set
local opts = { remap = false, silent = true }

for _,mode in ipairs({'n', 't', 'i', 'v'}) do
	for _,key in ipairs({'h', 'j', 'k', 'l'}) do
		map(mode, string.format('<A-C-%s>', key), function ()
			if vim.fn.winnr() ~= vim.fn.winnr(key) then
				vim.cmd(string.format('wincmd %s', key))
			end
		end, opts)

		map(mode, string.format('<A-C-S-%s>', key), function ()
			if vim.fn.winnr('$') > 1 then
				vim.cmd(string.format('wincmd %s', string.upper(key)))
			end
		end, opts)
	end

	-- Move current window to a new tab.
	map(mode, [[<A-C-u>]], function ()
		if vim.fn.winnr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			vim.cmd('wincmd T')
			if mode == 't' then vim.api.nvim_input('i')
			else vim.api.nvim_input([[<C-\><C-n>]]) end
		end
	end, opts)

	-- Minimize window size.
	map(mode, '<A-C-m>', function ()
		if vim.fn.winnr('$') > 1 then vim.cmd('wincmd =') end
	end, opts)

	-- Maximize window size.
	map(mode, '<A-C-S-m>', function ()
		if vim.fn.winnr('$') > 1 then vim.cmd('wincmd _') vim.cmd('wincmd |') end
	end, opts)

	-- Close all windows except the current window.
	map(mode, '<A-C-o>', function ()
		if vim.fn.winnr('$') > 1 then vim.cmd('only') end
	end, opts)

	-- Close the current window.
	map(mode, '<A-C-BS>', function ()
		local success, result = pcall(vim.cmd, 'exit')
		if not success then vim.notify(result, vim.log.levels.WARN) end
	end, opts)

	-- Create a new vertical window.
	map(mode, '<A-C-CR>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		vim.cmd('vnew') vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Create a new horizontal window.
	map(mode, '<A-C-S-CR>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		vim.cmd('new') vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Create a new tab after the current tab.
	map(mode, '<A-C-i>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		vim.cmd('tabnew') vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Create a new tab before the current tab.
	map(mode, '<A-C-S-i>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		vim.cmd('-tabnew') vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Close all tabs except the current tab.
	map(mode, '<A-C-S-o>', function ()
		if vim.fn.tabpagenr('$') > 1 then vim.cmd('tabonly') end
	end, opts)

	-- Close the current tab.
	map(mode, '<A-C-S-BS>', function ()
		if vim.fn.tabpagenr('$') > 1 then vim.cmd('tabclose') end
	end, opts)

	-- Go to the next tab.
	map(mode, '<A-C-n>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			vim.cmd('tabnext')
		end
	end, opts)

	-- Go to the previous tab.
	map(mode, '<A-C-p>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			vim.cmd('tabprevious')
		end
	end, opts)

	-- Move current tab to the next tab.
	map(mode, '<A-C-S-n>', function ()
		local last_tab = vim.fn.tabpagenr('$')
		if last_tab > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			if vim.fn.tabpagenr() == last_tab then vim.cmd('tabmove 0') else vim.cmd('tabmove +1') end
			if mode == 't' then vim.api.nvim_input('i') end
		end
	end, opts)

	-- Move current tab to the previous tab.
	map(mode, '<A-C-S-p>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			if vim.fn.tabpagenr() == 1 then vim.cmd('tabmove $') else vim.cmd('tabmove -1') end
			if mode == 't' then vim.api.nvim_input('i') end
		end
	end, opts)

	-- Mappings for function keys (1-12).
	for nr = 1, 12 do
		-- Go to the specified tab.
		map(mode, string.format('<F%d>', nr), function ()
			if vim.fn.tabpagenr('$') >= nr and vim.fn.tabpagenr() ~= nr then
				if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
				vim.cmd('tabnext ' .. nr)
			end
		end, opts)

		-- Move current tab to the specified tab.
		map(mode, string.format('<F%d>', nr + 12), function ()
			local current_tab = vim.fn.tabpagenr()
			if vim.fn.tabpagenr('$') >= nr and current_tab ~= nr then
				local step = nr - current_tab
				if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
				vim.cmd(string.format('tabmove %s%d', (step > 0 and '+') or '', step))
				if mode == 't' then vim.api.nvim_input('i') end
			end
		end, opts)
	end
end
