-- config, run, branch, commit, host

_G.packman = {
	init = vim.fn.stdpath('config') .. '/lua/plugin-init.lua',
	path = vim.fn.stdpath('data') .. '/site/pack/packman/opt',
	runtime = vim.env.XDG_RUNTIME_DIR .. '/nvim-packman-active',
}

_G.packman.add = function (plugin)
	table.insert(_G.packman.plugins, plugin)
	if not plugin.loaded then return false end
	vim.cmd('packadd! ' .. plugin.repo)
	if plugin.config then
		local success, error = pcall(dofile, plugin.config)
		if not success then vim.notify(error, vim.log.levels.ERROR) end
	end
end

local function setup(raw_plugins)
	assert(type(raw_plugins) == 'table', 'bad argument #1 (table expected)')
	_G.packman.raw_plugins = raw_plugins

	-- if vim.fn.filereadable(_G.packman.init) == 1 then
		-- local status, error = pcall(dofile, _G.packman.init)
		-- if not success then vim.notify(error, vim.log.levels.ERROR) end
	-- end

	vim.cmd "command! PackInit lua require('packman.init')()()"
	vim.cmd "command! PackClean lua require('packman.clean')()()"
	vim.cmd "command! PackUpdate lua require('packman.update')()() require('packman.init')()()"
	vim.cmd "command! PackInstall lua require('packman.install')()() require('packman.init')()()"

	-- Use only when no packman process is still running.
	vim.cmd "command! PackRemoveRuntime lua require('packman.runtime').remove()()"
end

return setup
