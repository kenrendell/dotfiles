#!/usr/bin/env lua5.4
-- Show current time and date (see 'strftime' manual)
-- Dependencies: luaposix

-- Usage: time.lua [--date]
if #arg > 1 or (#arg == 1 and arg[1] ~= '--date') then
	io.stderr:write('Usage: time.lua [--date]\n')
	os.exit(1)
end

local signal, unistd = require('posix.signal'), require('posix.unistd')

-- Print the current time/date
local function print_time(show_date)
	local date, output
	repeat date = os.date('*t')
		output = (show_date and
			string.format('{"text": " %s"}\n', os.date('%a %Y-%m-%d')))
			or string.format('{"text": " %s"}\n', os.date('%H:%M'))

		io.stdout:write(output):flush()
		unistd.sleep((not show_date and 60 - date.sec)
			or ((24 - date.hour) * 60 - date.min) * 60 - date.sec)
	until false
end

local function exit(signum) os.exit(128 + signum) end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

print_time(arg[1])
