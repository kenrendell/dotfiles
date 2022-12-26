local gitcmd, async, fs, runtime = require('packman.gitcmd'),
	require('utils.async'), require('utils.fs'), require('packman.runtime')

local register = function (raw_plugin)
	local plugin, arg_type = {}, type(raw_plugin)
	if arg_type ~= 'string' and arg_type ~= 'table'
	then return nil, 'bad argument #1 (string or table expected)' end

	plugin.url = (arg_type == 'string' and raw_plugin) or raw_plugin[1]
	if not plugin.url then return nil, 'no specified URL' end

	local repo = plugin.url:match('^%g+/([%w%-%._]+).git$')
	if not repo then return nil, 'invalid repo name in URL' end

	plugin.dir = ('%s/%s'):format(_G.packman.path, repo)
	plugin.installed, plugin.loaded = false, false

	if arg_type == 'table' then
		local branch, run, commit, config = raw_plugin.branch,
			raw_plugin.run, raw_plugin.commit, raw_plugin.config

		if type(commit) == 'string' and commit ~= '' then plugin.commit = commit
		elseif type(branch) == 'string' and branch ~= '' then plugin.branch = branch end

		if type(run) == 'string' and run ~= '' then plugin.run = run end
		if type(config) == 'string' and config ~= '' then plugin.config = config end
	end table.insert(_G.packman.plugins, plugin)
	return plugin
end

local run_cmd = async.sync(function (cmd, dir)
	local options, args, i, path = {}, {}, 0
	for arg in cmd:gmatch('%S+') do
		if i == 0 then path = arg
		else args[i] = arg end i = i + 1
	end options.cwd = dir
	if #args > 0 then options.args = args end
	return async.wait(async.spawn(path, options, false))
end)

local setup = async.sync(function (raw_plugin)
	local plugin, err = register(raw_plugin)
	if err then return nil, 'failed to register: ' .. err end

	local filetype, err = async.wait(fs.filetype(plugin.dir))
	if err then return nil, err end
	if filetype ~= 'dir' then return nil, ("file '%s' is not a directory"):format(plugin.dir) end

	-- Check if the URL of git repo matches the specified URL
	local url, err = async.wait(gitcmd.get_url(plugin.dir))
	if err then return nil, err end
	if url ~= plugin.url then return nil, ("git repo '%s' URL is not equal to '%s'"):format(plugin.dir, plugin.url) end
	plugin.installed = true

	if plugin.commit then -- switch to the specified commit
		err = select(2, async.wait(gitcmd.switch_commit(plugin.commit, plugin.dir)))
	else -- switch to the specified branch
		if not plugin.branch then
			plugin.branch, err = async.wait(gitcmd.get_default_branch(plugin.dir))
			if err then return nil, err end
		end err = select(2, async.wait(gitcmd.switch_branch(plugin.branch, plugin.dir)))
	end if err then return nil, err end

	if not plugin.commit then -- merge the remote updates to the current branch
		err = select(2, async.wait(gitcmd.merge_remote(plugin.branch, plugin.dir)))
		if err then return nil, err end
	end
	if plugin.run then -- execute the commands
		err = select(2, async.wait(run_cmd(plugin.run, plugin.dir)))
		if err then return nil, err end
	end plugin.loaded = true
	return true
end)

-- Generate file contents
local get_file_contents = function ()
	local lines, fmt = {'-- DO NOT EDIT --\n', 'local add = _G.packman.add'}
	fmt = {'\nadd {', '\t%s = %s,', "'%s'", '}'}
	for i = 1, #_G.packman.plugins do
		table.insert(lines, fmt[1])
		for k, v in pairs(_G.packman.plugins[i]) do
			v = (type(v) ~= 'string' and tostring(v)) or fmt[3]:format(v)
			table.insert(lines, fmt[2]:format(k, v))
		end table.insert(lines, fmt[4])
	end return table.concat(lines, '\n')
end

local init = async.sync(function ()
	local err = select(2, async.wait(runtime.create()))
	if err then return nil, err end

	local processes, fd, success = {}
	
	-- if not async.wait(fs.exists(_G.packman.path)) then
		-- async.wait(fs.mkdir(_G.packman.path, 0x1C0)) end

	_G.packman.plugins = {}

	print('Packman: initializing ...')
	for i = 1, #_G.packman.raw_plugins do
		table.insert(processes, setup(_G.packman.raw_plugins[i]))
	end table.insert(processes, 10)
	_G.packman_init_result = {async.wait(unpack(processes))}

	async.wait(fs.remove(_G.packman.init))
	fd = async.wait(fs.open(_G.packman.init, 'w', 0x180))
	async.wait(fs.write(fd, get_file_contents(), false))
	async.wait(fs.close(fd))

	print('Packman: initialized')
	-- success, error = pcall(dofile, _G.packman.init)
	-- if success then print('Packman: initialized')
	-- else vim.notify(error, vim.log.levels.ERROR) end

	return async.wait(runtime.remove())
end)

return init
