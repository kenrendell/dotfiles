
local fs, async = require('utils.fs'), require('utils.async')
local uv, runtime = vim.loop, os.getenv('XDG_RUNTIME_DIR')
local stdout_template = runtime .. '/nvim-lua-stdout-XXXXXX'
local stderr_template = runtime .. '/nvim-lua-stderr-XXXXXX'

-- local function onread(pipe, output, read_err)
	-- return pipe:read_start(function (err, data)
		-- if err then
			-- if not read_err[pipe] then read_err[pipe] = {} end
			-- return table.insert(read_err[pipe], err)
		-- end
		-- for line in (data or ''):gmatch('[^\n]+') do
			-- if not line:match('^%s+$')
			-- then table.insert(output, line) end
		-- end
	-- end)
-- end

-- spawn = async.wrap(function (path, options, use_stdout, callback)
	-- local err = (type(path) ~= 'string' and 'bad argument #1 (string expected)')
	-- or (type(options) ~= 'table' and 'bad argument #2 (table expected)')
	-- if err then return callback(nil, err) end

	-- local stderr, error, read_err, stdout, output, handle = uv.new_pipe(), {}, {}
	-- if use_stdout then stdout, output = uv.new_pipe(), {} end
	-- options.stdio = {nil, stdout, stderr}
	-- handle = uv.spawn(path, options, function (code)
		-- if stdout then stdout:read_stop() stdout:close() end
		-- stderr:read_stop() stderr:close() handle:close()
		-- if code ~= 0 then
			-- local stderr_err = read_err[stderr]
			-- if stderr_err then callback(nil, (#stderr_err > 1 and stderr_err) or stderr_err[1])
			-- else callback(nil, (#error > 1 and error) or error[1] or '') end
		-- elseif output then
			-- local stdout_err = read_err[stdout]
			-- if stdout_err then callback(nil, (#stdout_err > 1 and stdout_err) or stdout_err[1])
			-- else callback((#output > 1 and output) or output[1] or '') end
		-- else callback(true) end
	-- end)
	-- if not handle then stderr:close()
		-- if stdout then stdout:close() end
		-- return callback(nil, 'failed to start the process')
	-- end
	-- onread(stderr, error, read_err)
	-- if stdout then onread(stdout, output, read_err) end
-- end)

spawn = async.wrap(function (path, options, callback)
	local handle = nil
	handle = uv.spawn(path, options, function (code)
		handle:close() callback(code == 0) end)
	if not handle then callback(nil, 'failed to start the process') end
end)

readline = async.sync(function (file)
	local output, stat, data, err = {}
	stat, err = async.wait(fs.stat(file[2]))
	if err then return nil, err end
	data, err = async.wait(fs.read(file[1], stat.size, 0))
	if err then return nil, err end
	for line in data:gmatch('[^\n]+') do
		if not line:match('^%s+$')
		then table.insert(output, line) end
	end return (#output > 1 and output) or output[1] or ''
end)

return async.sync(function (path, options, use_stdout, use_stderr)
	local err = (type(path) ~= 'string' and 'bad argument #1 (string expected)')
	or (type(options) ~= 'table' and 'bad argument #2 (table expected)')
	or (type(use_stdout) ~= 'boolean' and 'bad argument #3 (boolean expected)')
	or (type(use_stderr) ~= 'boolean' and 'bad argument #4 (boolean expected)')
	if err then return nil, err end
	local stdout, stderr, stdout_file, stderr_file, success, output, err_output
	if use_stdout then
		stdout_file, err = async.wait(fs.mkstemp(stdout_template))
		if err then return nil, err end
		stdout, err = uv.new_pipe()
		if err then goto cleanup end
		err = select(2, stdout:open(stdout_file[1]))
		if err then goto cleanup end
	end
	if use_stderr then
		stderr_file, err = async.wait(fs.mkstemp(stderr_template))
		if err then goto cleanup end
		stderr, err = uv.new_pipe()
		if err then goto cleanup end
		err = select(2, stderr:open(stderr_file[1]))
		if err then goto cleanup end
	end
	options.stdio = {nil, stdout, stderr}
	success, err = async.wait(spawn(path, options))
	if err then goto cleanup end
	if success and stdout_file then
		output, err = async.wait(readline(stdout_file))
	elseif not success and stderr_file then
		err_output, err = async.wait(readline(stderr_file))
	end
	::cleanup::
	if stdout then stdout:close() end
	if stderr then stderr:close() end
	if stdout_file then
		async.wait(fs.close(stdout_file[1]))
		async.wait(fs.unlink(stdout_file[2]))
	end
	if stderr_file then
		async.wait(fs.close(stderr_file[1]))
		async.wait(fs.unlink(stderr_file[2]))
	end
	collectgarbage()
	if err then return nil, err end
	return output or err_output or success
end)
