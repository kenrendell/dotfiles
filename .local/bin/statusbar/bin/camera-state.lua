#!/usr/bin/env lua5.4
-- Show camera state
-- Dependencies: luaposix

-- Usage: camera-state.lua
if #arg > 0 then
	io.stderr:write('Usage: camera-state.lua\n')
	os.exit(1)
end

local signal, unistd = require('posix.signal'), require('posix.unistd')
local loaded_modules, camera_module = '/proc/modules', 'uvcvideo'

-- Print camera state
local function print_camera_state()
	local text, class, output
	repeat text, class = '', ''
		for line in io.lines(loaded_modules) do -- Search for memory variables
			local module = line:match('^([a-zA-Z0-9_]+)%s+.+$')
			if module == camera_module then text, class = '', 'active' end
		end output = string.format('{"text": "%s", "class": "%s"}\n', text, class)
		io.stdout:write(output):flush()
		unistd.sleep(5)
	until false
end

local function exit(signum) os.exit(128 + signum) end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

print_camera_state(arg[1])
