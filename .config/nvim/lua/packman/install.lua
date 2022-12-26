local gitcmd, async, window, runtime = require('packman.gitcmd'),
	require('utils.async'), require('packman.window'), require('packman.runtime')

local install = async.sync(function ()
	local err = select(2, async.wait(runtime.create()))
	if err then return nil, err end

	local processes, messages, count, bufnr, processes_count = {}, {}, 0
	assert(#_G.packman.plugins > 0, 'plugin list is empty')
	vim.g.packman_running = true
	bufnr = window.create('[Packman Status]')

	local install = async.sync(function (i, plugin)
		local success = async.wait(gitcmd.clone(plugin))
		messages[i] = (' %s/%s: %s'):format(plugin.owner,
			plugin.repo, (success and 'installed') or 'install failed')

		count = count + 1
		async.main() window.write_message(bufnr, messages)
		print(string.format((count == processes_count and 'Packman: installed %d/%d')
			or 'Packman: installing %d/%d ...', count, processes_count))
	end)

	for i, plugin in ipairs(_G.packman.plugins) do
		if not plugin.installed then
			table.insert(processes, install(i, plugin)) end

		messages[i] = (' %s/%s: %s'):format(plugin.owner, plugin.repo,
			(plugin.installed and 'installed') or 'installing ...')
	end

	processes_count = #processes
	window.write_message(bufnr, messages)

	if processes_count > 0 then
		print(string.format('Packman: installing 0/%d ...', processes_count))
		async.wait(unpack(processes))
	else print('Packman: no plugins to install') end

	return async.wait(runtime.remove())
end)

return install
