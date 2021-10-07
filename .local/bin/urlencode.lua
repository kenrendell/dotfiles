#!/usr/bin/env lua
-- Convert string to URL encoded string

-- Usage: urlencode.lua <string>
if #arg ~= 1 then
	io.stderr:write('Usage: urlencode.lua <string>\n')
	os.exit(1)
end

local urlencode = ''

for c in arg[1]:gmatch('.') do
	urlencode = urlencode ..
		((c:match('[a-zA-Z0-9/_%.~%-]') and c)
		or string.format('%%%X', c:byte(i)))
end

-- Print the URL encoded string
io.write(urlencode .. '\n')
