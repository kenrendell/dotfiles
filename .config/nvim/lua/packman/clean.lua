local gitcmd, async, runtime = require('packman.gitcmd'),
	require('utils.async'), require('packman.runtime')

local get_stale_branch = async.sync(function (plugin)
	local stale_branch = {}
	local local_branch = async.wait(gitcmd.get_local_branch(plugin))
	local remote_branch = async.wait(gitcmd.get_remote_branch(plugin))
	for i = 1, #remote_branch do remote_branch[remote_branch[i]] = true end
	for i = 1, #local_branch do local branch = local_branch[i]
		if not remote_branch[branch] then table.insert(stale_branch, branch) end
	end return stale_branch
end)

local clean = async.sync(function ()
	local err = select(2, async.wait(runtime.create()))
	if err then return nil, err end

	-- local files = vim.fn.readdir(packman.path)
	-- vim.fn.isdirectory(packman.path .. files[1])

	-- Declare for 'gitcmd.remove_stale_branch' function
	-- async.wait(gitcmd.remove_stale_branch(plugin))

	return async.wait(runtime.remove())
end)
