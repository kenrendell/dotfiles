
-- TAB MAPPINGS
-- F{1..12}                        := Go to the tab 1 - 12.
-- shift + F{1..12}                := Move current tab to tab 1 - 12.
-- alt + ctrl + n                  := Go to the next tab.
-- alt + ctrl + p                  := Go to the previous tab.
-- alt + ctrl + shift + n          := Move current tab to the next tab.
-- alt + ctrl + shift + p          := Move current tab to the previous tab.
-- alt + ctrl + i                  := Create a new tab after the current tab.
-- alt + ctrl + shift + i          := Create a new tab before the current tab.
-- alt + ctrl + shift + o          := Close all tabs except the current tab.
-- alt + ctrl + shift + backspace  := Close current tab.

-- WINDOW MAPPINGS
-- alt + ctrl + {h, j, k, l}          := Move current window focus to the {left, bottom, top, right}.
-- alt + ctrl + shift + {h, j, k, l}  := Move current window to be at the very {left, bottom, top, right}.
-- alt + ctrl + m                     := Minimize window size.
-- alt + ctrl + shift + m             := Maximize window size.
-- alt + ctrl + u                     := Move current window to a new tab.
-- alt + ctrl + return                := Create a new vertical window.
-- alt + ctrl + shift + return        := Create a new horizontal window.
-- alt + ctrl + o                     := Close all windows except the current window.
-- alt + ctrl + backspace             := Close the current window.

local map = vim.keymap.set
local opts = { remap = false, silent = true }

vim.g.mapleader = ' '

-- Window and tab mappings.
for _,mode in ipairs({'n', 't', 'i', 'v'}) do
	-- Minimize window size.
	map(mode, '<A-C-m>', function ()
		if vim.fn.winnr('$') > 1 then
			local success, result = pcall(vim.cmd, 'wincmd =')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Maximize window size.
	map(mode, '<A-C-S-m>', function ()
		if vim.fn.winnr('$') > 1 then
			-- Maximize window height.
			local success, result = pcall(vim.cmd, 'wincmd _')
			if not success then vim.notify(result, vim.log.levels.WARN) end

			-- Maximize window width.
			success, result = pcall(vim.cmd, 'wincmd |')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Move current window to a new tab.
	map(mode, [[<A-C-u>]], function ()
		if vim.fn.winnr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			local success, result = pcall(vim.cmd, 'wincmd T')
			if not success then vim.notify(result, vim.log.levels.WARN) end
			if mode == 't' then vim.api.nvim_input('i')
			else vim.api.nvim_input([[<C-\><C-n>]]) end
		end
	end, opts)

	-- Window navigation mappings.
	for _,key in ipairs({'h', 'j', 'k', 'l'}) do
		-- Move current window focus to the {left, bottom, top, right}.
		map(mode, string.format('<A-C-%s>', key), function ()
			if vim.fn.winnr() ~= vim.fn.winnr(key) then
				local success, result = pcall(vim.cmd, 'wincmd ' .. key)
				if not success then vim.notify(result, vim.log.levels.WARN) end
			end
		end, opts)

		-- Move current window to be at the very {left, bottom, top, right}.
		map(mode, string.format('<A-C-S-%s>', key), function ()
			if vim.fn.winnr('$') > 1 then
				local success, result = pcall(vim.cmd, 'wincmd ' .. string.upper(key))
				if not success then vim.notify(result, vim.log.levels.WARN) end
			end
		end, opts)
	end

	-- Create a new vertical window.
	map(mode, '<A-C-CR>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		local success, result = pcall(vim.cmd, 'vnew')
		if not success then vim.notify(result, vim.log.levels.WARN) end
		vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Create a new horizontal window.
	map(mode, '<A-C-S-CR>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		local success, result = pcall(vim.cmd, 'new')
		if not success then vim.notify(result, vim.log.levels.WARN) end
		vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Close all windows except the current window.
	map(mode, '<A-C-o>', function ()
		if vim.fn.winnr('$') > 1 then
			local success, result = pcall(vim.cmd, 'only')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Close the current window.
	map(mode, '<A-C-BS>', function ()
		local success, result = pcall(vim.cmd, 'exit')
		if not success then vim.notify(result, vim.log.levels.WARN) end
	end, opts)

	-- Go to the next tab.
	map(mode, '<A-C-n>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			local success, result = pcall(vim.cmd, 'tabnext')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Go to the previous tab.
	map(mode, '<A-C-p>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			local success, result = pcall(vim.cmd, 'tabprevious')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Move current tab to the next tab.
	map(mode, '<A-C-S-n>', function ()
		local last_tab = vim.fn.tabpagenr('$')
		if last_tab > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			local success, result = pcall(vim.cmd, 'tabmove ' .. ((vim.fn.tabpagenr() == last_tab and '0') or '+1'))
			if not success then vim.notify(result, vim.log.levels.WARN) end
			if mode == 't' then vim.api.nvim_input('i') end
		end
	end, opts)

	-- Move current tab to the previous tab.
	map(mode, '<A-C-S-p>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
			local success, result = pcall(vim.cmd, 'tabmove ' .. ((vim.fn.tabpagenr() == 1 and '$') or '-1'))
			if not success then vim.notify(result, vim.log.levels.WARN) end
			if mode == 't' then vim.api.nvim_input('i') end
		end
	end, opts)

	-- Tab navigation mappings.
	for nr = 1, 12 do
		-- Go to the specified tab.
		map(mode, string.format('<F%d>', nr), function ()
			if vim.fn.tabpagenr('$') >= nr and vim.fn.tabpagenr() ~= nr then
				if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
				local success, result = pcall(vim.cmd, 'tabnext ' .. nr)
				if not success then vim.notify(result, vim.log.levels.WARN) end
			end
		end, opts)

		-- Move current tab to the specified tab.
		map(mode, string.format('<F%d>', nr + 12), function ()
			local current_tab = vim.fn.tabpagenr()
			if vim.fn.tabpagenr('$') >= nr and current_tab ~= nr then
				local step = nr - current_tab
				if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
				local success, result = pcall(vim.cmd, string.format('tabmove %s%d', (step > 0 and '+') or '', step))
				if not success then vim.notify(result, vim.log.levels.WARN) end
				if mode == 't' then vim.api.nvim_input('i') end
			end
		end, opts)
	end

	-- Create a new tab after the current tab.
	map(mode, '<A-C-i>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		local success, result = pcall(vim.cmd, 'tabnew')
		if not success then vim.notify(result, vim.log.levels.WARN) end
		vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Create a new tab before the current tab.
	map(mode, '<A-C-S-i>', function ()
		if mode ~= 'n' then vim.api.nvim_input([[<C-\><C-n>]]) end
		local success, result = pcall(vim.cmd, '-tabnew')
		if not success then vim.notify(result, vim.log.levels.WARN) end
		vim.api.nvim_input([[<C-\><C-n>]])
	end, opts)

	-- Close all tabs except the current tab.
	map(mode, '<A-C-S-o>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			local success, result = pcall(vim.cmd, 'tabonly')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)

	-- Close the current tab.
	map(mode, '<A-C-S-BS>', function ()
		if vim.fn.tabpagenr('$') > 1 then
			local success, result = pcall(vim.cmd, 'tabclose')
			if not success then vim.notify(result, vim.log.levels.WARN) end
		end
	end, opts)
end
