if vim.g.colors_name then vim.cmd.highlight('clear') end

vim.g.colors_name = 'terminal-colors'
vim.opt.background = 'dark'
vim.opt.termguicolors = true

local colors = {
	gray =    {'#' .. vim.env.COLOR_00, '#' .. vim.env.COLOR_08},
	red =     {'#' .. vim.env.COLOR_01, '#' .. vim.env.COLOR_09},
	green =   {'#' .. vim.env.COLOR_02, '#' .. vim.env.COLOR_10},
	yellow =  {'#' .. vim.env.COLOR_03, '#' .. vim.env.COLOR_11},
	blue =    {'#' .. vim.env.COLOR_04, '#' .. vim.env.COLOR_12},
	magenta = {'#' .. vim.env.COLOR_05, '#' .. vim.env.COLOR_13},
	cyan =    {'#' .. vim.env.COLOR_06, '#' .. vim.env.COLOR_14},
	white =   {'#' .. vim.env.COLOR_07, '#' .. vim.env.COLOR_15},
}

local highlights = {
	-- Syntax
	['Comment'] = { fg = colors.gray[2] },
	['Constant'] = { fg = colors.red[1] },
	['String'] = { fg = colors.yellow[1] },
	['Character'] = { fg = colors.yellow[1] },
	['Number'] = { fg = colors.red[1] },
	['Boolean'] = { fg = colors.red[1] },
	['Float'] = { fg = colors.red[1] },
	['Identifier'] = { fg = colors.cyan[1] },
	['Function'] = { fg = colors.blue[1] },
	['Statement'] = { fg = colors.green[1] },
	['Conditional'] = { fg = colors.green[1] },
	['Repeat'] = { fg = colors.green[1] },
	['Label'] = { fg = colors.green[1] },
	['Operator'] = { fg = colors.green[1] },
	['Keyword'] = { fg = colors.green[1] },
	['Exception'] = { fg = colors.green[1] },
	['PreProc'] = { fg = colors.magenta[1] },
	['Include'] = { fg = colors.magenta[1] },
	['Define'] = { fg = colors.magenta[1] },
	['Macro'] = { fg = colors.magenta[1] },
	['PreCondit'] = { fg = colors.magenta[1] },
	['Type'] = { fg = colors.yellow[1] },
	['StorageClass'] = { fg = colors.cyan[1] },
	['Structure'] = { fg = colors.yellow[1] },
	['Typedef'] = { fg = colors.yellow[1] },
	['Special'] = { fg = colors.red[1] },
	['SpecialChar'] = { fg = colors.red[1] },
	['Tag'] = { fg = colors.red[1] },
	['Delimiter'] = { fg = colors.white[1] },
	['SpecialComment'] = { fg = colors.red[1] },
	['Debug'] = { fg = colors.red[1] },
	['Underlined'] = { fg = colors.white[1], underline = true },
	['Ignore'] = {},
	['Error'] = { fg = colors.red[1], bold = true },
	['Todo'] = { fg = colors.white[1], bold = true },

	-- 
	['ColorColumn'] = { bg = colors.gray[1] },
	['Conceal'] = {},
	['Directory'] = { fg = colors.blue[1], bg = colors.gray[1] },
	['SignColumn'] = { fg = colors.white[1] },
	['MatchParen'] = { fg = colors.gray[1], bg = colors.blue[2] },
	['Normal'] = { fg = colors.white[1] },
	['NormalFloat'] = { fg = colors.white[1] },
	['NormalNC'] = { fg = colors.white[1] },
	['QuickFixLine'] = { fg = colors.gray[1], bg = colors.yellow[1] },
	['Visual'] = { bg = colors.gray[1] },
	['VisualNOS'] = { reverse = true },

	-- Window
	['WinSeparator'] = { fg = colors.gray[1] },
	['LspInfoBorder'] = { link = 'WinSeparator' },
	['FloatBorder'] = { link = 'WinSeparator' },

	-- Folding
	['Folded'] = { fg = colors.white[1], bg = colors.gray[1] },
	['FoldColumn'] = { fg = colors.white[1] },

	-- Cursor
	['Cursor'] = { fg = colors.gray[1], bg = colors.white[1] },
	['lCursor'] = { link = 'Cursor' },
	['CursorIM'] = { link = 'Cursor' },
	['TermCursor'] = { link = 'Cursor' },
	['TermCursorNC'] = {},

	-- Non-text
	['NonText'] = { fg = colors.gray[1] },
	['SpecialKey'] = { fg = colors.gray[2] },
	['Whitespace'] = { fg = colors.gray[1] },
	['EndOfBuffer'] = { fg = colors.gray[1] },

	-- Message area
	['Title'] = { fg = colors.magenta[1], bold = true },
	['MsgArea'] = { fg = colors.white[1] },
	['ModeMsg'] = { fg = colors.green[1], bold = true },
	['MoreMsg'] = { fg = colors.cyan[1], bold = true },
	['MsgSeparator'] = { fg = colors.gray[1] },
	['ErrorMsg'] = { fg = colors.red[1] },
	['WarningMsg'] = { fg = colors.yellow[1] },
	['Question'] = { fg = colors.cyan[1], bold = true },

	-- Column
	['CursorColumn'] = { bg = colors.gray[1] },

	-- Search
	['CurSearch'] = { fg = colors.yellow[1], bold = true },
	['Substitute'] = { fg = colors.yellow[1], bold = true },
	['IncSearch'] = { fg = colors.yellow[1], bold = true },
	['Search'] = { fg = colors.gray[1], bg = colors.yellow[1] },

	-- Diff mode
	['DiffAdd'] = { fg = colors.gray[1], bg = colors.green[1] },
	['DiffChange'] = { fg = colors.gray[1], bg = colors.magenta[1] },
	['DiffDelete'] = { fg = colors.gray[1], bg = colors.red[1] },
	['DiffText'] = { fg = colors.gray[1], bg = colors.magenta[2] },

	-- Number line
	['LineNr'] = { fg = colors.gray[2] },
	['LineNrAbove'] = { link = 'LineNr' },
	['LineNrBelow'] = { link = 'LineNr' },
	['CursorLineNr'] = { fg = colors.blue[2] },
	['CursorLineSign'] = {},
	['CursorLineFold'] = {},
	['CursorLine'] = {},

	-- Completion
	['Pmenu'] = { fg = colors.white[1], bg = colors.gray[1] },
	['PmenuSel'] = { fg = colors.gray[1], bg = colors.blue[2] },
	['PmenuSbar'] = { bg = colors.gray[1] },
	['PmenuThumb'] = { bg = colors.gray[2] },
	['WildMenu'] = { fg = colors.gray[1], bg = colors.blue[1] },
	['CmpItemAbbr'] = { fg = colors.white[1] },
	['CmpItemAbbrDeprecated'] = { fg = colors.red[1] },
	['CmpItemAbbrMatch'] = { bold = true },
	['CmpItemAbbrMatchFuzzy'] = { link = 'CmpItemAbbrMatch' },
	['CmpItemKind'] = { fg = colors.magenta[1] },
	['CmpItemMenu'] = { fg = colors.gray[2] },

	-- Spelling
	['SpellBad'] = { fg = colors.red[1], underline = true },
	['SpellCap'] = { fg = colors.yellow[1] },
	['SpellLocal'] = { fg = colors.yellow[1] },
	['SpellRare'] = { fg = colors.yellow[1] },

	-- Statusline, Tabline, and Winbar
	['User1'] = { fg = colors.red[1], bg = colors.gray[1] },
	['User2'] = { fg = colors.green[1], bg = colors.gray[1] },
	['User3'] = { fg = colors.yellow[1], bg = colors.gray[1] },
	['User4'] = { fg = colors.blue[1], bg = colors.gray[1] },
	['User5'] = { fg = colors.magenta[1], bg = colors.gray[1] },
	['User6'] = { fg = colors.cyan[1], bg = colors.gray[1] },
	['User7'] = { fg = colors.gray[2] },
	['User8'] = { fg = colors.green[1] },
	['User9'] = { fg = colors.magenta[1] },
	['TabLine'] = { fg = colors.white[1], bg = colors.gray[1] },
	['TabLineFill'] = { fg = colors.gray[2], bg = colors.gray[1] },
	['TabLineSel'] = { fg = colors.gray[1], bg = colors.green[1] },
	['StatusLine'] = { fg = colors.white[1], bg = colors.gray[1] },
	['StatusLineNC'] = { fg = colors.gray[1], bg = colors.gray[1] },

	-- Window bar
	['WinBar'] = { fg = colors.white[1] },
	['WinBarNC'] = { link = 'WinBar' },
	['WinBarDir'] = { fg = colors.gray[2] },
	['WinBarFile'] = { fg = colors.green[1] },
	['WinBarFileModified'] = { fg = colors.blue[1] },
	['WinBarBuffer'] = { fg = colors.magenta[1] },

	-- Treesitter rainbow
	['rainbowcol1'] = { fg = colors.red[1] },
	['rainbowcol2'] = { fg = colors.green[1] },
	['rainbowcol3'] = { fg = colors.yellow[1] },
	['rainbowcol4'] = { fg = colors.blue[1] },
	['rainbowcol5'] = { fg = colors.magenta[1] },
	['rainbowcol6'] = { fg = colors.cyan[1] },
	['rainbowcol7'] = { fg = colors.white[1] },

	-- Gitsigns plugin
	['GitSignsAdd'] = { fg = colors.green[1] },
	['GitSignsDelete'] = { fg = colors.red[1] },
	['GitSignsChange'] = { fg = colors.magenta[1] },

	-- LSP diagnostics
	['DiagnosticHint'] = { fg = colors.cyan[2] },
	['DiagnosticInfo'] = { fg = colors.blue[2] },
	['DiagnosticWarn'] = { fg = colors.yellow[1] },
	['DiagnosticError'] = { fg = colors.red[1] },
}

-- Set highlights
for name,opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, name, opts)
end vim.cmd.redraw({ bang = true })
