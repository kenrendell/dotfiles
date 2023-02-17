local modes = {
	['n'] = {'NORMAL', 'Normal'},
	['v'] = {'VISUAL', 'Visual'},
	['V'] = {'VISUAL-LINE', 'Visual'},
	['\022'] = {'VISUAL-BLOCK', 'Visual'},
	['s'] = {'SELECT', 'Select'},
	['S'] = {'SELECT-LINE', 'Select'},
	['\019'] = {'SELECT-BLOCK', 'Select'},
	['i'] = {'INSERT', 'Insert'},
	['R'] = {'REPLACE', 'Replace'},
	['c'] = {'COMMAND', 'Command'},
	['r'] = {'PROMPT', 'Prompt'},
	['!'] = {'SHELL', 'Shell'},
	['t'] = {'TERMINAL', 'Terminal'},
}

local function get_mode()
	local mode = modes[vim.api.nvim_get_mode().mode:sub(1, 1)] or { 'UNKNOWN', 'Unknown' }
	return table.concat({ '%#StatusLineMode', mode[2], '# ', mode[1], ' %#StatusLine#' })
end

local function get_lsp_diagnostics()
	local get, severity = vim.diagnostic.get, vim.diagnostic.severity
	local error = #get(0, { severity = severity.ERROR })
	local warn = #get(0, { severity = severity.WARN })
	local info = #get(0, { severity = severity.INFO })
	local hint = #get(0, { severity = severity.HINT })

	return table.concat({
		(hint > 0 and string.format(' %%9*H:%d%%*', hint)) or '',
		(info > 0 and string.format(' %%5*I:%d%%*', info)) or '',
		(warn > 0 and string.format(' %%4*W:%d%%*', warn)) or '',
		(error > 0 and string.format(' %%2*E:%d%%*', error)) or ''
	})
end

local function get_git_status()
	local gitsigns_status_dict = vim.b.gitsigns_status_dict
	if not gitsigns_status_dict then return '' end

	local head = gitsigns_status_dict['head'] or ''
	local added = gitsigns_status_dict['added'] or 0
	local changed = gitsigns_status_dict['changed'] or 0
	local removed = gitsigns_status_dict['removed'] or 0

	return table.concat({
		(head ~= '' and string.format(' %%7*%s%%*', head)) or '',
		(added > 0 and string.format(' %%3*+%d%%*', added)) or '',
		(changed > 0 and string.format(' %%6*~%d%%*', changed)) or '',
		(removed > 0 and string.format(' %%2*-%d%%*', removed)) or ''
	})
end

local function set_statusline()
	vim.opt.statusline = table.concat({
		get_mode(), get_git_status(), get_lsp_diagnostics(), '%=',
		(vim.bo.filetype ~= '' and string.format(' %%6*%s%%*', vim.bo.filetype)) or '',
		' %3*', (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.go.encoding, '%*',
		' %3*', vim.bo.fileformat, '%*', (vim.bo.bomb and ' %3*BOM%*') or '',
		(vim.bo.binary and ' %2*BIN%*') or '', (vim.bo.readonly and ' %2*RO%*') or '',
		(vim.wo.spell and ' %2*SPELL%*') or '', ' %8*%c:0x%B %l/%L%* '
	})
end

local group_id = vim.api.nvim_create_augroup('statusline', { clear = true })

vim.api.nvim_create_autocmd(
	{ 'VimEnter', 'WinEnter', 'BufWinEnter', 'FileChangedShell', 'FileType', 'OptionSet', 'ModeChanged', 'DiagnosticChanged' },
	{ group = group_id, callback = set_statusline }
)

vim.api.nvim_create_autocmd('User', {
	pattern = 'GitSignsUpdate',
	callback = set_statusline,
	group = group_id
})

vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.laststatus = 3
