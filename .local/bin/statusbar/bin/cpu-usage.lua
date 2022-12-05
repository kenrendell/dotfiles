#!/usr/bin/env lua5.4
-- Show current CPU usage and load average (see 'proc' manual)
-- Dependencies: luaposix

-- Usage: cpu-usage.lua [--loadavg]
if #arg > 1 or (#arg == 1 and arg[1] ~= '--loadavg') then
	io.stderr:write('Usage: cpu-usage.lua [--loadavg]\n')
	os.exit(1)
end

local signal, unistd, file = require('posix.signal'), require('posix.unistd')

-- Close the file and exit the program
local function exit(signum)
	if io.type(file) == 'file' then file:close() end
	os.exit(128 + signum)
end

-- Read the first line of file
local function read(filename)
	local data = nil
	file = assert(io.open(filename, 'r'))
	data = assert(file:read())
	assert(file:close())
	return data
end

-- Get the number of processing units
local function processor_count()
	local procs = 0
	for line in io.lines('/proc/cpuinfo') do
		if line:match('^%s*processor%s*:%s*%d+%s*$') then procs = procs + 1 end
	end return procs
end

-- Print the load average
local function print_loadavg()
	local output, procs, avg1, avg5, avg15 repeat
		avg1, avg5, avg15 = read('/proc/loadavg'):match('^(%d+%.%d+)%s+(%d+%.%d+)%s+(%d+%.%d+).+$')
		avg1, avg5, avg15, procs = tonumber(avg1), tonumber(avg5), tonumber(avg15), processor_count()
		output = string.format('{"text": " %.2f %.2f %.2f (%d)", "class": "%s"}\n',
			avg1, avg5, avg15, procs, (avg15 > procs and avg5 > procs and avg1 > procs and 'critical')
			or ((avg1 > procs or avg5 > procs or avg15 > procs) and 'warning') or '')

		io.write(output):flush()
		unistd.sleep(5)
	until false
end

-- Get the CPU usage
local function cpu_usage(n)
	local total, info, cpu, idle = 0
	for line in io.lines('/proc/stat') do
		info = line:match(string.format('^cpu%s%%s+(.+)$', n or ''))
		if info then break end
	end if not info then io.stderr:write(string.format("Failed to find 'cpu%s'!\n", n or '')) os.exit(1) end

	-- Get the time spent in user, nice, system, idle, iowait,
	-- irq, softirq, and steal (guest time is included in user time).
	cpu = table.pack(info:match('^(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+%d+%s+%d+%s*$'))
	if not cpu[1] then io.stderr:write('Failed to parse CPU values!\n') os.exit(1) end
	for i, v in ipairs(cpu) do
		cpu[i] = tonumber(v) total = total + cpu[i]
	end idle = cpu[4] + cpu[5] -- idle + iowait
	return total, idle
end

-- Print the CPU usage
local function print_cpu_usage(n)
	local idle, total, totald, idled, result = nil
	local prev_total, prev_idle = 0, 0
	repeat total, idle = cpu_usage(n)
		totald, idled = total - prev_total, idle - prev_idle
		result = 100 * (totald - idled) / totald

		output = string.format('{"text": " %.2f%%", "class": "%s"}\n',
			result, (result >= 95 and 'critical') or (result >= 80 and 'warning') or '')

		io.stdout:write(output):flush()
		prev_total, prev_idle = total, idle
		unistd.sleep(2)
	until false
end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

if arg[1] then print_loadavg() end print_cpu_usage()
