#!/usr/bin/env lua
-- Show current CPU usage and load average

-- Usage: cpu_usage.lua [--loadavg]
-- Dependencies: luaposix

-- Match the usage restrictions
if #arg > 1 or (#arg == 1 and arg[1] ~= '--loadavg') then
	io.stderr:write('Usage: cpu_usage.lua [--loadavg]\n')
	os.exit(1)
end

local signal, unistd, file = require('posix.signal'),
	require('posix.unistd')

local function exit(signum)
	-- Close the file and exit the program
	if io.type(file) == 'file' then file:close() end
	os.exit(128 + signum)
end

local function read(filename)
	-- Return the first line of file
	file = io.open(filename, 'r')
	local data = file:read()
	file:close()

	return data
end

local function loadavg()
	-- Get the load average from '/proc/loadavg' file:
	--     1: 1 minute load average
	--     2: 5 minute load average
	--     3: 15 minute load average
	--     4: running processes / total processes
	--     5: PID of the process that recently created

	local output repeat
		output = read('/proc/loadavg'):gsub(
			'^(%d+%.%d+)%s+(%d+%.%d+)%s+(%d+%.%d+).+$',
			'{"text": " %1 %2 %3", "class": ""}\n')

		io.write(output):flush()
		unistd.sleep(5)
	until false
end

local function cpu_usage()
	-- Get the CPU usage from '/proc/stat' file (in line 1):
	--     user: time spent in user mode.
	--     nice: time spent with niced processes in user mode.
	--     system: time spent running in kernel mode.
	--     idle: time spent idle.
	--     iowait: time spent waiting for I/O to completed.
	--     irq: time spent serving hardware interrupts.
	--     softirq: time spent serving software interrupts.
	--     steal: time stolen by other OS running in a virtual environment.
	--     guest: time spent running a virtual CPU for a guest OS.
	--     guest_nice: time spent running a virtual CPU for a niced guest OS.

	local prev_sum, prev_idle, change,
		cpu_usage, sum, idle, i, n, output = 0, 0

	repeat sum, i = 0, 1
		for s in read('/proc/stat'):gmatch('%d+') do
			n = tonumber(s)
			sum = sum + n

			if i == 4 then idle = n end i = i + 1
		end

		-- Calculate the CPU usage percentage
		change = sum - prev_sum
		cpu_usage = 100 * (change - idle + prev_idle) / change

		output = string.format('{"text": " %.2f%%", "class": "%s"}\n',
			cpu_usage, (cpu_usage >= 95 and 'critical') or
			(cpu_usage >= 80 and 'warning') or '')

		io.write(output):flush()
		unistd.sleep(2)

		-- Save the previous data
		prev_sum, prev_idle = sum, idle
	until false
end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

if arg[1] then loadavg() end cpu_usage()
