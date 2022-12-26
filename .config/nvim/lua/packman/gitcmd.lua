-- Git commands

local gitcmd, async, spawn = {}, require('utils.async'), require('utils.spawn')

-- Get the URL of remote repository
gitcmd.get_url = async.sync(function (dir)
	local args = {'remote', 'get-url', 'origin'}
	return async.wait(spawn('git', {args = args, cwd = dir}, true, true))
end)

-- Get the current commit
gitcmd.get_commit = async.sync(function (dir)
	local args = {'rev-parse', '--short', 'HEAD'}
	return async.wait(spawn('git', {args = args, cwd = dir}, true, true))
end)

-- Get the current branch
gitcmd.get_branch = async.sync(function (dir)
	local args, output, err = {'rev-parse', '--abbrev-ref', 'HEAD'}
	output, err = async.wait(spawn('git', {args = args, cwd = dir}, true, true))
	if err then return nil, err end return output ~= 'HEAD' and output
end)

-- Get the default branch from local repository
gitcmd.get_default_branch = async.sync(function (dir)
	local args, output, err = {'rev-parse', '--abbrev-ref', 'origin/HEAD'}
	output, err = async.wait(spawn('git', {args = args, cwd = dir}, true, true))
	if err then return nil, err end return output:match('^[^/]+/([^/]+)$')
end)

-- Get the list of local branches
gitcmd.get_local_branch = async.sync(function (dir)
	local args = {'for-each-ref', '--format', '%(refname:lstrip=2)', 'refs/heads'}
	return async.wait(spawn('git', {args = args, cwd = dir}, true, true))
end)

-- Get the list of remote branches
gitcmd.get_remote_branch = async.sync(function (dir)
	local args = {
		'for-each-ref', '--format',
		'%(if:notequals=HEAD)%(refname:lstrip=3)%(then)%(refname:lstrip=3)%(end)',
		'refs/remotes/origin'
	} return async.wait(spawn('git', {args = args, cwd = dir}, true, true))
end)

-- Switch to another branch
gitcmd.switch_branch = async.sync(function (branch, dir)
	local args = {'switch', branch}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Switch to a specific commit (detached HEAD)
gitcmd.switch_commit = async.sync(function (commit, dir)
	local args = {'switch', '--detach', commit}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Clone the remote repository
gitcmd.clone = async.sync(function (url, dir)
	local args, env = {'clone', '--depth', '5', '--no-single-branch',
		'--no-tags', '--quiet', url, dir}, {'GIT_TERMINAL_PROMPT=0'}
	return async.wait(spawn('git', {args = args, env = env}, false, true))
end)

-- Fetch the updates from a remote repository
gitcmd.fetch = async.sync(function (dir)
	local args = {'fetch', '--no-tags', '--prune', '--quiet', 'origin'}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Apply the remote updates to the current branch
gitcmd.merge_remote = async.sync(function (branch, dir)
	local args = {'merge', '--ff-only', '--quiet', 'origin/' .. branch}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Set the default branch to the HEAD of remote repository
gitcmd.set_default_branch = async.sync(function (dir)
	local args = {'remote', 'set-head', 'origin', '--auto'}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Remove any local branch that no longer exist on the remote repository
gitcmd.remove_stale_branch = async.sync(function (stale_branch, dir)
	local args = {'branch', '--delete', '--force'}
	for i = 1, #stale_branch do table.insert(args, stale_branch[i]) end
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)

-- Cleanup unnecessary files and optimize the local repository
gitcmd.garbage_collect = async.sync(function (dir)
	local args = {'gc', '--aggressive'}
	return async.wait(spawn('git', {args = args, cwd = dir}, false, true))
end)


-- TESTING !

print2 = async.sync(function (mes)
	local options = {}
	options.args = {mes}
	return async.wait(spawn('printf', options, true, true))
end)

gitcmd.test = async.sync(function (limit)
	local processes, numbers = {}, {'one', 'two', 'three', 'four', 'five'}
	local n, c = #numbers, 0
	for i = 1, 100 do
		table.insert(processes, print2(numbers[c + 1]))
		c = (c + 1) % n
	end table.insert(processes, limit)
	_G.result = {async.wait(unpack(processes))}
end)

return gitcmd
