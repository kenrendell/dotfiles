-- Asynchronous File-system Operations

local fs, async = {}, require('utils.async')

local function bintodec(bin)
	local dec, count, lsb = 0, 0
	while bin > 0 do
		lsb = bin % 10
		dec = dec + lsb * math.pow(2, count)
		bin = math.floor(bin / 10)
		count = count + 1
	end return dec
end

local function dectobin(n)
	local bin, count = 0, 0
	while n > 0 do
		bin = bin + (n % 2) * math.pow(10, count)
		n = math.floor(n / 2)
		count = count + 1
	end return bin
end

local function bitwise_and(a, b)
	local res, count, a_lsb, b_lsb = 0, 0
	a, b = dectobin(a), dectobin(b)
	while a + b > 0 do
		a_lsb, b_lsb = a % 10, b % 10
		res = res + (a_lsb * b_lsb) * math.pow(10, count)
		if a > 0 then a = math.floor(a / 10) end
		if b > 0 then b = math.floor(b / 10) end
		count = count + 1
	end return bintodec(res)
end

fs.filetype = async.wrap(function (path, callback)
	local filetype = { -- see lstat(2) and inode(7) for more info
		[16384] = 'dir',  -- directory
		[8192]  = 'chr',  -- character device
		[24576] = 'blk',  -- block device
		[32768] = 'reg',  -- regular file
		[4096]  = 'fifo', -- named pipe
		[40960] = 'link', -- symbolic link
		[49152] = 'sock', -- socket
	}
	vim.loop.fs_lstat(path, function(err, stat)
		callback(stat and (filetype[bitwise_and(stat.mode, 61440)]
		or 'unknown'), err) end)
end)

fs.stat = async.wrap(function (path, callback)
	vim.loop.fs_stat(path, function(err, stat)
		callback(stat, err) end)
end)

fs.lstat = async.wrap(function (path, callback)
	vim.loop.fs_lstat(path, function(err, stat)
		callback(stat, err) end)
end)

fs.access = async.wrap(function (path, mode, callback)
	vim.loop.fs_access(path, mode,
		function (err, permission) callback(permission, err) end)
end)

fs.open = async.wrap(function (path, flags, mode, callback)
	vim.loop.fs_open(path, flags, mode,
		function (err, fd) callback(fd, err) end)
end)

fs.close = async.wrap(function (fd, callback)
	vim.loop.fs_close(fd, function (err, success)
		callback(success, err) end)
end)

fs.read = async.wrap(function (fd, size, offset, callback)
	vim.loop.fs_read(fd, size, offset,
		function (err, data) callback(data, err) end)
end)

fs.write = async.wrap(function (fd, data, offset, callback)
	vim.loop.fs_write(fd, data, offset,
		function (err, bytes) callback(bytes, err) end)
end)

fs.mkdir = async.wrap(function (path, mode, callback)
	vim.loop.fs_mkdir(path, mode,
		function (err, success) callback(success, err) end)
end)

fs.rmdir = async.wrap(function (path)
	vim.loop.fs_rmdir(path, function (err, success)
		callback(success, err) end)
end)

fs.unlink = async.wrap(function (path, callback)
	vim.loop.fs_unlink(path, function (err, success)
		callback(success, err) end)
end)

fs.opendir = async.wrap(function (path, entries, callback)
	vim.loop.fs_opendir(path, function (err, dir)
		callback(dir, err) end, entries)
end)

fs.readdir = async.wrap(function (dir, callback)
	vim.loop.fs_readdir(dir, function (err, item)
		callback(item, err) end)
end)

fs.closedir = async.wrap(function (dir, callback)
	vim.loop.fs_closedir(dir, function (err, success)
		callback(success, err) end)
end)

fs.mkdtemp = async.wrap(function (template, callback)
	vim.loop.fs_mkdtemp(template, function (err, path)
		callback(path, err) end)
end)

fs.mkstemp = async.wrap(function (template, callback)
	vim.loop.fs_mkstemp(template, function (err, fd, path)
		callback({fd, path}, err) end)
end)

return fs
