-- Asynchronous external commands

local excmd, async, spawn = {}, require('utils.async'), require('utils.spawn')

excmd.remove = async.sync(function (path)
	local options = {}
	options.args = {'--recursive', '--force', path}
	return async.wait(spawn('rm', options, false, true))
end)

return excmd
