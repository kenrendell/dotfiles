
local runtime, async, fs = {},
	require('utils.async'), require('utils.fs')

runtime.create = async.sync(function ()
	if async.wait(fs.lstat(_G.packman.runtime))
	then return nil, 'packman is already running' end
	local fd, err = async.wait(fs.open(_G.packman.runtime, 'w', 0x1C0))
	if not fd then return nil, err end
	err = select(2, async.wait(fs.write(fd, '', false)))
	if err then return nil, err end
	return async.wait(fs.close(fd))
end)

runtime.remove = async.sync(function ()
	return async.wait(fs.remove(_G.packman.runtime))
end)

return runtime
