
local window = {}

window.create = function (bufname)
	assert(type(bufname) == 'string', "expected 'string' type")
	local bufnr = vim.fn.bufnr(bufname)
	if bufnr > -1 then vim.cmd('bwipeout! ' .. bufnr) end

	-- Create a window in new tab page
	vim.cmd('tabnew ' .. bufname)
	bufnr = vim.fn.bufnr(bufname)
	assert(bufnr ~= -1, 'failed to create a new tab page')

	-- Scratch buffer properties
	vim.fn.setbufvar(bufnr, '&buftype', 'nofile')
	vim.fn.setbufvar(bufnr, '&bufhidden', 'wipe')
	vim.fn.setbufvar(bufnr, '&swapfile', 0)
	vim.fn.setbufvar(bufnr, '&number', 0)
	vim.fn.setbufvar(bufnr, '&relativenumber', 0)
	vim.fn.setbufvar(bufnr, '&wrap', 0)

	return bufnr
end

window.write_message = function (bufnr, messages)
	vim.fn.deletebufline(bufnr, 2, '$')
	for i, mes in ipairs(messages) do
		if i == 1 then vim.fn.setbufline(bufnr, '$', mes)
		else vim.fn.appendbufline(bufnr, '$', mes) end
	end
end

return window
