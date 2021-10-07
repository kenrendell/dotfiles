#!/usr/bin/env lua
-- Convert number from byte unit or SI byte unit
-- or IEC byte unit to the appropriate IEC byte unit.

-- Usage: iecbyte.lua <unsigned number> [IEC/SI byte unit]
if #arg == 0 or #arg > 2 then
	io.stderr:write('Usage: iecbyte.lua <unsigned number> [IEC/SI byte unit]\n')
	os.exit(1)
end

-- Units at even (except 0) and odd indices
-- are IEC byte and SI byte units, respectively.
local units = { [0] = 'B',
	'KB', 'KiB', 'MB', 'MiB',
	'GB', 'GiB', 'TB', 'TiB',
	'PB', 'PiB', 'EB', 'EiB',
	'ZB', 'ZiB', 'YB', 'YiB'
}
local unit_count = #units
local digit = arg[1]
local count = 0

-- Check digit validity
if digit:match('^%d+%.?$') or digit:match('^%d*%.%d+$') then
	digit = tonumber(digit)
else
	io.stderr:write('Use valid unsigned number!\n')
	os.exit(1)
end

-- Check unit validity
if #arg == 2 and arg[2] ~= units[0] then
	repeat
		count = count + 1
		if units[count] == arg[2] then break end
	until count > unit_count

	if count > unit_count then
		io.stderr:write(string.format(
			'No matching units!\nUnits: %s %s\n',
			units[0], table.concat(units, ' ')))
		os.exit(1)
	end
end

if digit == 0 then count = 0
elseif count > 0 and count % 2 == 0 and digit < 1 then
	-- Convert digit from IEC byte unit to
	-- the appropriate lower IEC byte unit.
	repeat
		digit = digit * 1024
		count = count - 2
	until count == 0 or digit >= 1
else
	-- Convert digit from SI byte unit to byte unit.
	if count > 0 and count % 2 == 1 then
		digit = digit * 1000 ^ (1 + count // 2)
		count = 0
	end

	-- Convert digit from byte unit or IEC byte unit
	-- to the appropriate higher IEC byte unit.
	while count < unit_count and digit >= 1024 do
		digit = digit / 1024
		count = count + 2
	end
end

-- Print the result
io.write(string.format('%.2f %s\n', digit, units[count]))
