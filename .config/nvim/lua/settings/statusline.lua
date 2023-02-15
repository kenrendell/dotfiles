local modes = {
	['n'] = {'NORMAL', 2},
	['v'] = {'VISUAL', 6},
	['V'] = {'VISUAL-LINE', 6},
	['\022'] = {'VISUAL-BLOCK', 6},
	['s'] = {'SELECT', 3},
	['S'] = {'SELECT-LINE', 3},
	['\019'] = {'SELECT-BLOCK', 3},
	['i'] = {'INSERT', 4},
	['R'] = {'REPLACE', 4},
	['c'] = {'COMMAND', 5},
	['r'] = {'PROMPT', 5},
	['!'] = {'SHELL', 5},
	['t'] = {'TERMINAL', 5},
}

local function get_mode()
	local mode = modes[vim.api.nvim_get_mode().mode:sub(1, 1)]
	return string.format(' %%0*[%%%d*%s%%*%%0*]', mode[2] or 1, mode[1])
end

local function get_lsp_diagnostics()
	local diagnostics = {}
	local get, severity = vim.diagnostic.get, vim.diagnostic.severity

	local error = #get(0, { severity = severity.ERROR })
	local warn = #get(0, { severity = severity.WARN })
	local info = #get(0, { severity = severity.INFO })
	local hint = #get(0, { severity = severity.HINT })

	table.insert(diagnostics, (hint > 0 and string.format(' %%6*H:%d%%*', hint)) or '')
	table.insert(diagnostics, (info > 0 and string.format(' %%4*I:%d%%*', info)) or '')
	table.insert(diagnostics, (warn > 0 and string.format(' %%3*W:%d%%*', warn)) or '')
	table.insert(diagnostics, (error > 0 and string.format(' %%1*E:%d%%*', error)) or '')

	return table.concat(diagnostics)
end

local function get_git_status()
	local gitsigns_status = {}
	local gitsigns_status_dict = vim.b.gitsigns_status_dict
	if not gitsigns_status_dict then return '' end

	local head = gitsigns_status_dict['head'] or ''
	local added = gitsigns_status_dict['added'] or 0
	local changed = gitsigns_status_dict['changed'] or 0
	local removed = gitsigns_status_dict['removed'] or 0

	table.insert(gitsigns_status, (head ~= '' and string.format(' %%4*%s%%*', head)) or '')
	table.insert(gitsigns_status, (added > 0 and string.format(' %%3*+%d%%*', added)) or '')
	table.insert(gitsigns_status, (changed > 0 and string.format(' %%8*~%d%%*', changed)) or '')
	table.insert(gitsigns_status, (removed > 0 and string.format(' %%7*-%d%%*', removed)) or '')

	return table.concat(gitsigns_status)
end

function Statusline()
	local statusline = {}

	table.insert(statusline, get_mode())
	table.insert(statusline, get_git_status())
	table.insert(statusline, get_lsp_diagnostics())
	table.insert(statusline, ' %=%< ')
	table.insert(statusline, '%3*%{&filetype!=#""?&filetype:"no-ft"} %{&fileencoding!=#""?&fileencoding:&encoding}%*')
	table.insert(statusline, '%8*%( %{&readonly?"RO":""}%)%( %{&previewwindow?"PRV":""}%)%( %{&spell?"SPELL":""}%)')
	table.insert(statusline, '%( %{&paste?"PASTE":""}%)%* %c:0x%B %l/%L %*')

	return table.concat(statusline)
end

vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.statusline = '%!luaeval("Statusline()")'
