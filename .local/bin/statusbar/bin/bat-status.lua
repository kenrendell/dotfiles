#!/usr/bin/env lua5.4
-- Show the current battery status
-- Dependencies: luaposix

-- Usage: bat-status.lua [--design]
if #arg > 1 or (#arg == 1 and arg[1] ~= '--design') then
	io.stderr:write('Usage: bat-status.lua [--design]\n')
	os.exit(1)
end

local signal, unistd, glob = require('posix.signal'),
	require('posix.unistd'), require('posix.glob')

-- Get the data in the first line of specified files in a directory
local function get_file_value(dir, ...)
	local files, result, success, file = table.pack(...), {}
	for i = 1, files.n do
		success, file = pcall(io.open, dir .. files[i], 'r')
		if not success or not file then result = nil break end
		result[files[i]] = file:read() file:close()
	end return result
end

-- Get the battery information
local function get_battery(design, excluded, invert)
	local battery = { percentage = 0, count = 0 }
	local status, energy, energy_full = 'status', 'energy_now', (design and 'energy_full_design') or 'energy_full'
	local success, paths = pcall(glob.glob, '/sys/class/power_supply/*', glob.GLOB_MARK)
	if not success or not paths then return nil end
	for _, path in ipairs(paths) do
		local name = path:match('/([^/]+)/$')
		if not name then goto continue end
		if invert then if not excluded[name] then goto continue end
		else if excluded[name] then goto continue end end

		local success, file = pcall(io.open, path .. 'type', 'r')
		local power_supply_type = success and file:read() file:close()
	
		if power_supply_type and power_supply_type == 'Battery' then
			local info = get_file_value(path, status, energy, energy_full)
			if not info or not info[status] then goto continue end

			info[energy], info[energy_full] = tonumber(info[energy]), tonumber(info[energy_full])
			if info[energy] and info[energy_full] and info[energy_full] > 0 then
				local percentage = 100 * (info[energy] / info[energy_full])
				if percentage > battery.percentage then
					battery.name, battery.status, battery.percentage = name, info[status], percentage
				end battery.count = battery.count + 1
			end
		end ::continue::
	end return (battery.count >= 1 and battery) or nil
end

-- Print the battery status
local function print_battery(design, excluded, invert)
	local bat, status_label, class, output
	repeat bat = get_battery(design, excluded or {}, invert)
		if bat then
			if bat.status == 'Full' then class, status_label = 'full', ' '
			elseif bat.status == 'Charging' then class, status_label = 'charging', ' '
			elseif bat.status == 'Unknown' then class, status_label = 'unknown', ' '
			else class, status_label = (bat.percentage <= 10 and 'critical') or (bat.percentage <= 25 and 'warning') or '', '' end

			output = string.format('{"text": "%s %.2f%%%s", "class": "%s", "tooltip": "%s"}\n', status_label
			, bat.percentage, (bat.count == 1 and '') or string.format(' (%d)', bat.count), class, bat.name)
		else output = '{"text": ""}\n' end

		io.stdout:write(output):flush()
		unistd.sleep(5)
	until false
end

local function exit(signum) os.exit(128 + signum) end

-- Handle SIGTERM and SIGINT signal
signal.signal(signal.SIGINT, exit)
signal.signal(signal.SIGTERM, exit)

print_battery(arg[1] == '--design')
