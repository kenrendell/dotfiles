-- 'lewis6991/gitsigns.nvim' plugin configuration

local c = {}

c.signs = {
	add          = { text = '+', hl = 'GitSignsAdd'    },
	change       = { text = '+', hl = 'GitSignsChange' },
	delete       = { text = '_', hl = 'GitSignsDelete' },
	topdelete    = { text = '^', hl = 'GitSignsDelete' },
	changedelete = { text = '~', hl = 'GitSignsChange' },
}

c.status_formatter = function (status)
	local added, changed, removed = status.added, status.changed, status.removed

	added = (added and added > 0 and added) or nil
	changed = (changed and changed > 0 and changed) or nil
	removed = (removed and removed > 0 and removed) or nil

	return ((added and ('+' .. added)) or '')
		.. ((changed and (((added and ' ~') or '~') .. changed)) or '')
		.. ((removed and ((((added and ' -') or (changed and ' -')) or '-')
		.. removed)) or '')
end

return function () require('gitsigns').setup(c) end
