local gitcmd, async, window, runtime = require('packman.gitcmd'),
	require('utils.async'), require('packman.window'), require('packman.runtime')

local update = async.sync(function ()
	local err = select(2, async.wait(runtime.create()))
	if err then return nil, err end

	local processes, messages, count, bufnr, processes_count = {}, {}, 0
	assert(#_G.packman.plugins > 0, 'plugin list is empty')
	bufnr = window.create('[Packman Status]')

	local update = async.sync(function (i, plugin)
		local success = false
		if async.wait(gitcmd.fetch(plugin)) then
			success = async.wait(gitcmd.set_default_branch(plugin)) end

		messages[i] = (' %s/%s: %s'):format(plugin.owner,
			plugin.repo, (success and 'updated') or 'update failed')

		count = count + 1
		async.main() window.write_message(bufnr, messages)
		print(string.format((count == processes_count and 'Packman: updated %d/%d')
			or 'Packman: updating %d/%d ...', count, processes_count))
	end)

	for i, plugin in ipairs(_G.packman.plugins) do
		if plugin.installed then
			table.insert(processes, update(i, plugin)) end

		messages[i] = (' %s/%s: %s'):format(plugin.owner, plugin.repo,
			(plugin.installed and 'updating ...') or 'not installed')
	end

	processes_count = #processes
	window.write_message(bufnr, messages)

	if processes_count > 0 then
		print(string.format('Packman: installing 0/%d ...', processes_count))
		async.wait(unpack(processes))
	else print('Packman: no plugins to update') end

	return async.wait(runtime.remove())
end)

return update
