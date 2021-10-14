#!/usr/bin/env lua
-- Show current time and date

-- Usage: time.lua [--date]
-- Dependencies: luaposix

-- Match the usage restrictions
if #arg > 1 or (#arg == 1 and arg[1] ~= '--date') then
	io.stderr:write('Usage: time.lua [--date]\n')
	os.exit(1)
end

local signal, unistd = require('posix.signal'),
	require('posix.unistd')

local function exit(signum)
	-- Exit the program
	os.exit(128 + signum)
end

local function time(show_date)
	-- Get the current time and date
	local date, output repeat
		date = os.date('*t')

		output = (show_date and
			string.format('{"text": " %s"}\n', os.date('%a %Y-%m-%d')))
			or string.format('{"text": " %s"}\n', os.date('%H:%M'))

		io.write(output):flush()
		unistd.sleep((not show_date and 60 - date.sec)
			or ((24 - date.hour) * 60 - date.min) * 60 - date.sec)
	until false
end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

time(arg[1])
