
-- bufnr: use 0 for current buffer or nil for all buffers
local function get_lsp_diagnostics(bufnr)
	local get, severity = vim.diagnostic.get, vim.diagnostic.severity
	return { -- Count current diagnostics
		error = #get(bufnr, { severity = severity.ERROR }),
		warn = #get(bufnr, { severity = severity.WARN }),
		info = #get(bufnr, { severity = severity.INFO }),
		hint = #get(bufnr, { severity = severity.HINT })
	}
end

function statusline()
	local statusline = ''
	local diagnostic = get_lsp_diagnostics(0)

	if vim.bo.buftype == 'terminal' then statusline = ' %3*%{b:term_title}%* %=%< '
	else
		statusline = '%{%&modified?"%2*":"%1*"%}%( %{get(b:,"gitsigns_status","")} |%) '
		.. '%t%( %{&modifiable?"":"-"}%)%( %{&modified?"+":""}%) %* %=%<%9*%{expand("%:~:.:h")}%* '
		.. '%3*%{&filetype!=#""?&filetype:"no-ft"} %{&fileencoding!=#""?&fileencoding:&encoding}%*'
		.. '%8*%( %{&readonly?"RO":""}%)%( %{&previewwindow?"PRV":""}%)%( %{&spell?"SPELL":""}%)'
		.. '%( %{&paste?"PASTE":""}%)%* %c:0x%B %l/%L %*'
	end
	return statusline
end

vim.opt.ruler = false
vim.opt.showmode = true
vim.opt.laststatus = 3
vim.opt.statusline = '%!luaeval("statusline()")'
