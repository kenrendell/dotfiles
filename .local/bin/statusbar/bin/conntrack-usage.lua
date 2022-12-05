#!/usr/bin/env lua5.4
-- Show tracked connections

-- Usage: conntrack-usage.lua [--expand]
if #arg > 1 or (#arg == 1 and arg[1] ~= '--expand') then
	io.stderr:write('Usage: conntrack-usage.lua [--expand]\n')
	os.exit(1)
end

local signal, unistd = require('posix.signal'), require('posix.unistd')

-- Read the first line of file
local function read(filename)
	local success, file, data = pcall(io.open, filename, 'r')
	if success then data = file:read() file:close() end
	return data
end

-- Print the netfilter conntrack usage
local function print_conntrack_usage(expand)
	local sys_netfilter_dir = '/proc/sys/net/netfilter/'
	local warn_count, crit_count = 4096, 1024
	local text, output, conntrack_count, conntrack_max, conntrack_avail
	repeat conntrack_max = tonumber(read(sys_netfilter_dir .. 'nf_conntrack_max'))
		conntrack_count = tonumber(read(sys_netfilter_dir .. 'nf_conntrack_count'))
		if conntrack_count and conntrack_max and conntrack_max > 0 then
			conntrack_avail = conntrack_max - conntrack_count
			if expand then text = string.format('%d / %d', conntrack_count, conntrack_max)
			else text = string.format('%.2f%%', (conntrack_count / conntrack_max) * 100) end

			output = string.format('{"text": " %s", "class": "%s"}\n', text, (conntrack_avail <= crit_count and 'critical')
			or (conntrack_avail <= warn_count and 'warning') or '')
		else output = '{"text": ""}\n' end

		io.stdout:write(output):flush()
		unistd.sleep(5)
	until false
end

local function exit(signum) os.exit(128 + signum) end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

print_conntrack_usage(arg[1])
