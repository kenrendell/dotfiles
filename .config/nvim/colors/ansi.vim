
" Reset to dark background, then reset everything to defaults.
set background=dark
highlight clear

if exists('syntax_on')
    syntax reset
endif

set notermguicolors

" Colorscheme name
let g:colors_name = 'ansi'

" Colors
let s:black   = [0, 8]
let s:red     = [1, 9]
let s:green   = [2, 10]
let s:yellow  = [3, 11]
let s:blue    = [4, 12]
let s:magenta = [5, 13]
let s:cyan    = [6, 14]
let s:white   = [7, 15]

" Highlighter function
function! s:hl(hlgroup)
    for [group, fg, bg, attr] in a:hlgroup
        execute 'highlight ' . group
            \ . ' ctermfg=' . (!empty(fg) ? fg : 'NONE')
            \ . ' ctermbg=' . (!empty(bg) ? bg : 'NONE')
            \ . ' cterm=' . (attr !=# '' ? attr : 'NONE')
    endfor
endfunction

" Syntax Groups (see 'W18')
let s:hlsyntax = [
    \ ['Comment',         s:black[1],   s:black[0], ''],
    \ ['Constant',        s:red[0],     s:black[0], ''],
    \ ['String',          s:yellow[0],  s:black[0], ''],
    \ ['Character',       s:yellow[0],  s:black[0], ''],
    \ ['Number',          s:red[0],     s:black[0], ''],
    \ ['Boolean',         s:red[0],     s:black[0], ''],
    \ ['Float',           s:red[0],     s:black[0], ''],
    \ ['Identifier',      s:cyan[0],    s:black[0], ''],
    \ ['Function',        s:blue[0],    s:black[0], ''],
    \ ['Statement',       s:green[0],   s:black[0], ''],
    \ ['Conditional',     s:green[0],   s:black[0], ''],
    \ ['Repeat',          s:green[0],   s:black[0], ''],
    \ ['Label',           s:green[0],   s:black[0], ''],
    \ ['Operator',        s:green[0],   s:black[0], ''],
    \ ['Keyword',         s:green[0],   s:black[0], ''],
    \ ['Exception',       s:red[0],     s:black[0], ''],
    \ ['PreProc',         s:magenta[0], s:black[0], ''],
    \ ['Include',         s:magenta[0], s:black[0], ''],
    \ ['Define',          s:magenta[0], s:black[0], ''],
    \ ['Macro',           s:magenta[0], s:black[0], ''],
    \ ['PreCondit',       s:magenta[0], s:black[0], ''],
    \ ['Type',            s:yellow[1],  s:black[0], ''],
    \ ['StorageClass',    s:cyan[0],    s:black[0], ''],
    \ ['Structure',       s:yellow[1],  s:black[0], ''],
    \ ['Typedef',         s:yellow[1],  s:black[0], ''],
    \ ['Special',         s:red[1],     s:black[0], ''],
    \ ['SpecialChar',     s:red[1],     s:black[0], ''],
    \ ['Tag',             s:red[1],     s:black[0], ''],
    \ ['Delimiter',       s:white[0],   s:black[0], ''],
    \ ['SpecialComment',  s:red[1],     s:black[0], ''],
    \ ['Debug',           s:red[1],     s:black[0], ''],
    \ ['Underlined',      s:white[0],   s:black[0], 'underline'],
    \ ['Ignore',          '',           '',         ''],
    \ ['Error',           s:red[0],     s:black[0], 'bold'],
    \ ['Todo',            s:white[0],   s:black[0], 'bold'],
    \ ]

call s:hl(s:hlsyntax)

" Highlight groups (see 'highlight-groups'/'hl-debug')
let s:hlgroup = [
    \ ['ColorColumn',     '',          s:black[1],   ''],
    \ ['Conceal',         s:yellow[0], s:black[0],   ''],
    \ ['Cursor',          s:black[1],  s:white[1],   ''],
    \ ['CursorIM',        s:black[1],  s:white[1],   ''],
    \ ['CursorColumn',    '',          s:black[1],   ''],
    \ ['CursorLine',      '',          s:black[1],   ''],
    \ ['Directory',       s:blue[0],   s:black[0],   ''],
    \ ['DiffAdd',         s:green[0],  s:black[1],   ''],
    \ ['DiffChange',      s:yellow[0], s:black[1],   ''],
    \ ['DiffDelete',      s:red[0],    s:black[1],   ''],
    \ ['DiffText',        s:blue[0],   s:black[0],   ''],
    \ ['EndOfBuffer',     s:black[1],  s:black[0],   ''],
    \ ['TermCursor',      s:black[1],  s:white[1],   ''],
    \ ['TermCursorNC',    '',          '',          ''],
    \ ['ErrorMsg',        s:red[0],    s:black[0],   ''],
    \ ['WinBar',          s:black[1],   s:black[0],   ''],
    \ ['WinBarNC',        s:black[1],   s:black[0],   ''],
    \ ['WinSeparator',    s:black[1],   s:black[0],   ''],
    \ ['Folded',          s:black[1],   s:black[0],   ''],
    \ ['FoldColumn',      s:white[0],   s:black[1],   ''],
    \ ['SignColumn',      s:white[0],   s:black[0],   ''],
    \ ['IncSearch',       s:yellow[1], s:black[0],   'bold'],
    \ ['Substitute',      s:yellow[1], s:black[0],   'bold'],
    \ ['LineNr',          s:black[1],   s:black[0],   ''],
    \ ['CursorLineNr',    s:blue[1],   s:black[0],   ''],
    \ ['MatchParen',      s:black[0],   s:blue[1],   'bold'],
    \ ['ModeMsg',         s:green[1],  s:black[0],   'bold'],
    \ ['MsgArea',         s:white[0],   s:black[0],   ''],
    \ ['MsgSeparator',    s:white[0],   s:black[1],   ''],
    \ ['MoreMsg',         s:green[1],  s:black[0],   'bold'],
    \ ['NonText',         s:black[1],   s:black[0],   ''],
    \ ['Normal',          s:white[0],   s:black[0],   ''],
    \ ['NormalFloat',     s:white[0],   s:black[0],   ''],
    \ ['NormalNC',        s:white[0],   s:black[0],   ''],
    \ ['Pmenu',           s:white[0],   s:black[1],   ''],
    \ ['PmenuSel',        s:black[1],   s:green[0],  ''],
    \ ['PmenuSbar',       '',          s:black[1],   ''],
    \ ['PmenuThumb',      '',          s:white[0],   ''],
    \ ['Question',        s:blue[0],   s:black[0],   ''],
    \ ['QuickFixLine',    s:black[0],   s:yellow[1], ''],
    \ ['Search',          s:yellow[1],   s:black[0], 'reverse'],
    \ ['SpecialKey',      s:white[0],   s:black[0],   ''],
    \ ['SpellBad',        s:red[0],    s:black[0],   'underline'],
    \ ['SpellCap',        s:yellow[0], s:black[0],   ''],
    \ ['SpellLocal',      s:yellow[0], s:black[0],   ''],
    \ ['SpellRare',       s:yellow[0], s:black[0],   ''],
    \ ['Title',           '',          s:black[0],   ''],
    \ ['Visual',          '',          s:black[0],   'reverse'],
    \ ['VisualNOS',       '',          s:black[0],   'reverse'],
    \ ['WarningMsg',      s:red[0],    s:black[0],   ''],
    \ ['Whitespace',      s:black[1],   s:black[0],   ''],
    \ ['WildMenu',        s:black[1],   s:green[0],  ''],
    \ ['debugPC',         '',          s:black[0],   ''],
    \ ['debugBreakpoint', '',          s:black[0],   ''],
    \ ]

call s:hl(s:hlgroup)

let s:gitsigns = [
    \ ['GitSignsAdd',    s:green[0],   s:black[0], ''],
    \ ['GitSignsDelete', s:red[0],     s:black[0], ''],
    \ ['GitSignsChange', s:magenta[0], s:black[0], ''],
    \ ]

call s:hl(s:gitsigns)

let s:ts_rainbow = [
	\ ['rainbowcol1', s:red[0],     s:black[0], ''],
	\ ['rainbowcol2', s:green[0],   s:black[0], ''],
	\ ['rainbowcol3', s:yellow[0],  s:black[0], ''],
	\ ['rainbowcol4', s:blue[0],    s:black[0], ''],
	\ ['rainbowcol5', s:magenta[0], s:black[0], ''],
	\ ['rainbowcol6', s:cyan[0],    s:black[0], ''],
	\ ['rainbowcol7', s:white[0],   s:black[0], ''],
	\ ]

call s:hl(s:ts_rainbow)

" Statusline and Tabline colors
let s:status = [
    \ ['User1',        s:green[0],   s:black[0], 'reverse'],
    \ ['User2',        s:blue[0],    s:black[0], 'reverse'],
    \ ['User3',        s:green[1],   s:black[1],  ''],
    \ ['User4',        s:blue[1],    s:black[1],  ''],
    \ ['User5',        s:yellow[1],  s:black[1],  ''],
    \ ['User6',        s:yellow[0],  s:black[1],  ''],
    \ ['User7',        s:red[0],     s:black[1],  ''],
    \ ['User8',        s:magenta[1], s:black[1],  ''],
    \ ['User9',        s:white[1],   s:black[1],  ''],
    \ ['TabLine',      s:black[1],   s:white[0],  ''],
    \ ['TabLineFill',  s:white[0],   s:black[1],  ''],
    \ ['TabLineSel',   s:black[1],   s:green[0], ''],
    \ ['StatusLine',   s:white[1],   s:black[1],  ''],
    \ ['StatusLineNC', s:white[0],   s:black[1],  ''],
    \ ]

call s:hl(s:status)
