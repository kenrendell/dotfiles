#!/usr/bin/env lua
-- Convert number from byte unit or SI byte unit
-- or IEC byte unit to the appropriate IEC byte unit.

-- Usage: iecbyte.lua <unsigned number> [IEC/SI byte unit]

-- Units at even (except 0) and odd indices
-- are IEC byte and SI byte units, respectively.
local units = { [0] = 'B',
	'KB', 'KiB', 'MB', 'MiB',
	'GB', 'GiB', 'TB', 'TiB',
	'PB', 'PiB', 'EB', 'EiB',
	'ZB', 'ZiB', 'YB', 'YiB'
}

-- Add the inverse of 'units' table to itself.
for i = 0, #units do units[units[i]] = i end

local function iecbyte(digit, count)
	-- digit = unsigned number
	-- count = units[<IEC/SI byte unit>]

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
		while count < #units and digit >= 1024 do
			digit = digit / 1024
			count = count + 2
		end
	end

	return digit, units[count]
end

if arg[1] ~= ({...})[1] then -- Run as module
	return { convert = iecbyte, units = units }
else
	-- Match the usage restrictions
	if #arg == 0 or #arg > 2 then
		io.stderr:write('Usage: iecbyte.lua <unsigned number> [IEC/SI byte unit]\n')
		os.exit(1)
	end

	local digit, unit = arg[1], (not arg[2] and 0) or units[arg[2]]

	-- Check the digit validity
	if digit:match('^%d+%.?$') or digit:match('^%d*%.%d+$') then
		digit = tonumber(digit)
	else
		io.stderr:write('Use valid unsigned number!\n')
		os.exit(1)
	end

	-- Check the unit validity
	if #arg == 2 and not unit then
		io.stderr:write(string.format('No matching units!\nUnits: %s %s\n',
			units[0], table.concat(units, ' ')))
		os.exit(1)
	end

	-- Print the result
	io.write(string.format('%.2f %s\n', iecbyte(digit, unit)))
end
