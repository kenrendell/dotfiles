
local async = {}

local function pack(...)
	local t = {...}
	t.n = select('#', ...)
	return t
end

async.wrap = function (fn)
	if type(fn) ~= 'function'
	then return nil, 'bad argument #1 (function expected)' end
	return function (...)
		local args = pack(...)
		return function (step) --> thunk (insert callback function)
			if step and type(step) ~= 'function'
			then return nil, 'bad argument #1 (function expected)' end
			args[args.n + 1] = step or function () end
			return fn(unpack(args, 1, args.n + 1))
		end
	end
end

async.sync = function (fn)
	if type(fn) ~= 'function'
	then return nil, 'bad argument #1 (function expected)' end
	return async.wrap(function (...)
		local thread, callback = coroutine.create(fn), select(-1, ...)
		local function step(...)
			local result = pack(coroutine.resume(thread, ...))
			if not result[1] then callback(nil, result[2])
			elseif coroutine.status(thread) ~= 'dead' then result[2](step)
			else callback(unpack(result, 2, result.n)) end
		end step(...)
	end)
end

async.wait = function (...)
	local thunks, result, thread = {...}, {}
	local nthunks, running, limit = #thunks, 0
	if nthunks > 0 and type(thunks[nthunks]) == 'number'
	then limit, nthunks = table.remove(thunks), nthunks - 1 end
	thread = coroutine.create(function (step)
		if nthunks == 0 or (limit and limit < 1) then return step() end
		for i, thunk in ipairs(thunks) do
			if type(thunk) == 'function' then
				running = running + 1
				thunk(function (...)
					running, result[i] = running - 1, pack(...)
					if coroutine.status(thread) ~= 'running'
					then coroutine.resume(thread) end
				end) if limit and running == limit then coroutine.yield() end
			else result[i] = {nil, 'bad thunk (not callable)', n = 2} end
		end while running > 0 do coroutine.yield() end
		if nthunks > 1 then step(unpack(result))
		else step(unpack(result[1], 1, result[1].n)) end
	end)
	return coroutine.yield(function (step)
		coroutine.resume(thread, step) end)
end

async.main = function () async.wait(vim.schedule) end

return async
