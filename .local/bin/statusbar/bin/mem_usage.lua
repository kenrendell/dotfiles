#!/usr/bin/env lua
-- Show current memory usage

-- Usage: mem_usage.lua [--expand]
-- Dependencies: luaposix

-- Match the usage restrictions
if #arg > 1 or (#arg == 1 and arg[1] ~= '--expand') then
	io.stderr:write('Usage: mem_usage.lua [--expand]\n')
	os.exit(1)
end

-- Add '~/.local/bin' to Lua PATH
package.path = string.format('%s;%s/%s', package.path,
	os.getenv('HOME'), '.local/bin/?.lua')

local signal, unistd, iecbyte = require('posix.signal'),
	require('posix.unistd'), require('iecbyte')

local function exit(signum)
	-- Exit the program
	os.exit(128 + signum)
end

local function mem_usage(expand)
	-- Get the memory usage from '/proc/meminfo' file.
	
	local mem, output = {
		MemTotal = 0, MemFree = 0, Buffers = 0,
		Cached = 0, SReclaimable = 0, unit = iecbyte.units['KiB'],

		usage = function (self)
			local count, mem_used, key, value = 5

			-- Search the required variables in '/proc/meminfo'.
			for line in io.lines('/proc/meminfo') do
				key, value = line:match('^(.+):%s*(%d+).+$')
			
				if self[key] then self[key] = tonumber(value)
					count = count - 1
					if count == 0 then break end
				end
			end

			-- Exit the program if there are missing variables.
			if count > 0 then os.exit(1) end

			-- Calculate the used memory
			mem_used = self.MemTotal - self.MemFree -
				self.Buffers - self.Cached - self.SReclaimable

			if expand then
				-- Convert the result to appropriate IEC byte unit.
				local n1, u1 = iecbyte.convert(mem_used, self.unit)
				local n2, u2 = iecbyte.convert(self.MemTotal, self.unit)

				return n1, u1, n2, u2
			end

			-- Calculate the memory usage percentage
			return 100 * mem_used / self.MemTotal
		end
	}

	repeat
		output = string.format((expand and
			'{"text": " %.2f %s / %.2f %s", "class": ""}\n')
			or '{"text": " %.2f%%", "class": ""}\n', mem:usage())

		io.write(output):flush()
		unistd.sleep(5)
	until false
end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

mem_usage(arg[1])
