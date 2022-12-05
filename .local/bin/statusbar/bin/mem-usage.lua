#!/usr/bin/env lua5.4
-- Show current memory usage (see 'proc' manual)
-- Dependencies: luaposix

-- Usage: mem-usage.lua [--expand]
if #arg > 1 or (#arg == 1 and arg[1] ~= '--expand') then
	io.stderr:write('Usage: mem-usage.lua [--expand]\n')
	os.exit(1)
end

local signal, unistd = require('posix.signal'), require('posix.unistd')

-- Units at even (except 0) and odd indices
-- are IEC byte and SI byte units, respectively.
local units = { [0] = 'B',
	'KB', 'KiB', 'MB', 'MiB',
	'GB', 'GiB', 'TB', 'TiB',
	'PB', 'PiB', 'EB', 'EiB',
	'ZB', 'ZiB', 'YB', 'YiB'
} for i = 0, #units do units[units[i]] = i end

-- Variables for memory usage calculation
local mem_info, mem_unit = '/proc/meminfo', 'KiB'
local mem_count, mem = 0, {
	MemTotal = 0, MemFree = 0, Buffers = 0,
	MemAvailable = 0, Cached = 0, SReclaimable = 0,
	SwapTotal = 0, SwapFree = 0, SwapCached = 0
} for _,_ in pairs(mem) do mem_count = mem_count + 1 end

-- Convert IEC/SI byte unit to the appropriate IEC byte unit.
local function iecbyte(digit, u)
	local n = units[u]
	if digit == 0 then n = 0
	elseif n > 0 and n % 2 == 0 and digit < 1 then
		-- Convert digit from IEC byte unit to the appropriate lower IEC byte unit.
		repeat digit, n = digit * 1024, n - 2 until n == 0 or digit >= 1
	else
		-- Convert digit from SI byte unit to byte unit.
		if n > 0 and n % 2 == 1 then digit = digit * (1000 ^ (1 + n // 2)) n = 0 end

		-- Convert digit from byte unit or IEC byte unit to the appropriate higher IEC byte unit.
		while n < #units and digit >= 1024 do digit, n = digit / 1024, n + 2 end
	end return digit, units[n]
end

-- Convert a digit to the specified byte unit
local function convert(digit, u1, u2)
	local a, b = units[u1], units[u2]
	local an, bn = a % 2, b % 2
	return digit * ((1024 - 24 * an) ^ (an + a // 2)) /
		((1024 - 24 * bn) ^ (bn + b // 2)), u2
end

-- Get the memory usage
local function mem_usage()
	local count, mem_used, swap_used = mem_count
	for line in io.lines(mem_info) do -- Search for memory variables
		local key, value = line:match('^(.+):%s*(%d+).+$')
		if mem[key] then count = count - 1
			mem[key] = tonumber(value)
			if count == 0 then break end
		end
	end if count > 0 then io.stderr:write('Missing memory variable!\n') os.exit(1) end
	mem_used = mem.MemTotal - mem.MemFree - mem.Buffers - mem.Cached - mem.SReclaimable
	swap_used = mem.SwapTotal - mem.SwapFree - mem.SwapCached
	return mem_used, mem.MemTotal, mem.MemAvailable, swap_used, mem.SwapTotal
end

-- Print the current memory usage
local function print_mem_usage(expand)
	local mem_avail_warn = convert(1, 'GiB', mem_unit)
	local mem_avail_crit = convert(256, 'MiB', mem_unit)
	local output, text, mem_used, mem_total, mem_avail, swap_used, swap_total
	repeat mem_used, mem_total, mem_avail, swap_used, swap_total = mem_usage()
		if expand then
			local n1, u1 = iecbyte(mem_used, mem_unit)
			local n2, u2 = iecbyte(mem_total, mem_unit)
			local n3, u3 = iecbyte(swap_used, mem_unit)
			local n4, u4 = iecbyte(swap_total, mem_unit)
			text = string.format('%.2f %s / %.2f %s (%.2f %s / %.2f %s)', n1, u1, n2, u2, n3, u3, n4, u4)
		else text = string.format('%.2f%% (%.2f%%)', 100 * mem_used / mem_total, 100 * swap_used / swap_total) end

		output = string.format('{"text": " %s", "class": "%s"}\n',
			text, (mem_avail <= mem_avail_crit and 'critical')
			or (mem_avail <= mem_avail_warn and 'warning') or '')

		io.stdout:write(output):flush()
		unistd.sleep(5)
	until false
end

local function exit(signum) os.exit(128 + signum) end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

print_mem_usage(arg[1])
