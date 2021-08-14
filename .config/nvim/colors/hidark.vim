
" Reset to dark background, then reset everything to defaults.
set background=dark
highlight clear

if exists('syntax_on')
    syntax reset
endif

" Set 24-bit colors if not set.
if has('gui_running') || (has('termguicolors') && !&termguicolors)
    set termguicolors
elseif &t_Co != 256
    finish
endif

" Colorscheme name
let g:colors_name = 'hidark'

" Colors
let s:red     = [['#DC657D', 168], ['#E48698', 211]]
let s:green   = [['#79B370', 107], ['#98C491', 114]]
let s:yellow  = [['#E18051', 209], ['#E79D78', 216]]
let s:blue    = [['#5596E2',  74], ['#78ACE7', 111]]
let s:magenta = [['#B07AB8', 139], ['#C095C6', 176]]
let s:cyan    = [['#4AB0A6',  73], ['#73C4BC', 115]]
let s:base    = [['#1D2025', 234], ['#282D33', 235],
               \ ['#363B45', 237], ['#5E6878', 241],
               \ ['#A1A8B5', 248], ['#BAC0C9', 251]]

" Neovim terminal colors
let g:terminal_color_0  = s:base[2][0]
let g:terminal_color_1  = s:red[0][0]
let g:terminal_color_2  = s:green[0][0]
let g:terminal_color_3  = s:yellow[0][0]
let g:terminal_color_4  = s:blue[0][0]
let g:terminal_color_5  = s:magenta[0][0]
let g:terminal_color_6  = s:cyan[0][0]
let g:terminal_color_7  = s:base[4][0]
let g:terminal_color_8  = s:base[3][0]
let g:terminal_color_9  = s:red[1][0]
let g:terminal_color_10 = s:green[1][0]
let g:terminal_color_11 = s:yellow[1][0]
let g:terminal_color_12 = s:blue[1][0]
let g:terminal_color_13 = s:magenta[1][0]
let g:terminal_color_14 = s:cyan[1][0]
let g:terminal_color_15 = s:base[5][0]

" Vim terminal colors
let g:terminal_ansi_colors = [
    \ s:base[2][0], s:red[0][0],     s:green[0][0], s:yellow[0][0],
    \ s:blue[0][0], s:magenta[0][0], s:cyan[0][0],  s:base[4][0],
    \ s:base[3][0], s:red[1][0],     s:green[1][0], s:yellow[1][0],
    \ s:blue[1][0], s:magenta[1][0], s:cyan[1][0],  s:base[5][0],
    \ ]

" Highlighter function
function! s:hl(hlgroup)
    for [group, fg, bg, attr] in a:hlgroup
        let l:fg = (!empty(fg) ? fg : ['NONE', 'NONE'])
        let l:bg = (!empty(bg) ? bg : ['NONE', 'NONE'])
        let l:attr = (attr !=# '' ? attr : 'NONE')

        exe 'highlight ' . group   . ' guisp='   . 'NONE'  .
            \ ' guifg='   . l:fg[0] . ' ctermfg=' . l:fg[1] .
            \ ' guibg='   . l:bg[0] . ' ctermbg=' . l:bg[1] .
            \ ' gui='     . l:attr  . ' cterm='   . l:attr
    endfor
endfunction

" Syntax Groups (see 'W18')
let s:hlsyntax = [
    \ ['Comment',         s:base[3],    s:base[0], 'italic'],
    \ ['Constant',        s:red[0],     s:base[0], ''],
    \ ['String',          s:yellow[0],  s:base[0], ''],
    \ ['Character',       s:yellow[0],  s:base[0], ''],
    \ ['Number',          s:red[0],     s:base[0], ''],
    \ ['Boolean',         s:red[0],     s:base[0], ''],
    \ ['Float',           s:red[0],     s:base[0], ''],
    \ ['Identifier',      s:cyan[0],    s:base[0], ''],
    \ ['Function',        s:blue[0],    s:base[0], ''],
    \ ['Statement',       s:green[0],   s:base[0], ''],
    \ ['Conditional',     s:green[0],   s:base[0], ''],
    \ ['Repeat',          s:green[0],   s:base[0], ''],
    \ ['Label',           s:green[0],   s:base[0], ''],
    \ ['Operator',        s:green[0],   s:base[0], ''],
    \ ['Keyword',         s:green[0],   s:base[0], ''],
    \ ['Exception',       s:red[0],     s:base[0], ''],
    \ ['PreProc',         s:magenta[0], s:base[0], ''],
    \ ['Include',         s:magenta[0], s:base[0], ''],
    \ ['Define',          s:magenta[0], s:base[0], ''],
    \ ['Macro',           s:magenta[0], s:base[0], ''],
    \ ['PreCondit',       s:magenta[0], s:base[0], ''],
    \ ['Type',            s:yellow[1],  s:base[0], ''],
    \ ['StorageClass',    s:cyan[0],    s:base[0], ''],
    \ ['Structure',       s:yellow[1],  s:base[0], ''],
    \ ['Typedef',         s:yellow[1],  s:base[0], ''],
    \ ['Special',         s:red[1],     s:base[0], ''],
    \ ['SpecialChar',     s:red[1],     s:base[0], ''],
    \ ['Tag',             s:red[1],     s:base[0], ''],
    \ ['Delimiter',       s:base[4],    s:base[0], ''],
    \ ['SpecialComment',  s:red[1],     s:base[0], ''],
    \ ['Debug',           s:red[1],     s:base[0], ''],
    \ ['Underlined',      s:base[4],    s:base[0], 'underline'],
    \ ['Ignore',          '',           '',        ''],
    \ ['Error',           s:red[0],     s:base[0], 'bold'],
    \ ['Todo',            s:base[4],    s:base[0], 'bold'],
    \ ]

call s:hl(s:hlsyntax)

" Highlight groups (see 'highlight-groups'/'hl-debug')
let s:hlgroup = [
    \ ['ColorColumn',     '',          s:base[1],   ''],
    \ ['Conceal',         s:yellow[0], s:base[0],   ''],
    \ ['Cursor',          s:base[2],   s:base[4],   ''],
    \ ['CursorIM',        s:base[2],   s:base[4],   ''],
    \ ['CursorColumn',    '',          s:base[1],   ''],
    \ ['CursorLine',      '',          s:base[1],   ''],
    \ ['Directory',       s:blue[0],   s:base[0],   ''],
    \ ['DiffAdd',         s:green[0],  s:base[1],   ''],
    \ ['DiffChange',      s:yellow[0], s:base[1],   ''],
    \ ['DiffDelete',      s:red[0],    s:base[1],   ''],
    \ ['DiffText',        s:blue[0],   s:base[0],   ''],
    \ ['EndOfBuffer',     s:base[0],   s:base[0],   ''],
    \ ['TermCursor',      s:base[2],   s:base[4],   ''],
    \ ['TermCursorNC',    '',          '',          ''],
    \ ['ErrorMsg',        s:red[0],    s:base[0],   ''],
    \ ['VertSplit',       s:base[1],   s:base[1],   ''],
    \ ['Folded',          s:base[2],   s:base[0],   ''],
    \ ['FoldColumn',      s:base[3],   s:base[1],   ''],
    \ ['SignColumn',      s:base[4],   s:base[0],   ''],
    \ ['IncSearch',       s:yellow[1], s:base[0],   'bold'],
    \ ['Substitute',      s:yellow[1], s:base[0],   'bold'],
    \ ['LineNr',          s:base[2],   s:base[0],   ''],
    \ ['CursorLineNr',    s:blue[1],   s:base[0],   ''],
    \ ['MatchParen',      s:base[0],   s:blue[1],   'bold'],
    \ ['ModeMsg',         s:green[1],  s:base[0],   'bold'],
    \ ['MsgArea',         s:base[4],   s:base[0],   ''],
    \ ['MsgSeparator',    s:base[3],   s:base[1],   ''],
    \ ['MoreMsg',         s:green[1],  s:base[0],   'bold'],
    \ ['NonText',         s:base[2],   s:base[0],   ''],
    \ ['Normal',          s:base[4],   s:base[0],   ''],
    \ ['NormalFloat',     s:base[4],   s:base[0],   ''],
    \ ['NormalNC',        s:base[4],   s:base[0],   ''],
    \ ['Pmenu',           s:base[4],   s:base[2],   ''],
    \ ['PmenuSel',        s:base[2],   s:green[0],  ''],
    \ ['PmenuSbar',       '',          s:base[1],   ''],
    \ ['PmenuThumb',      '',          s:base[3],   ''],
    \ ['Question',        s:blue[0],   s:base[0],   ''],
    \ ['QuickFixLine',    s:base[0],   s:yellow[1], ''],
    \ ['Search',          s:base[0],   s:yellow[1], ''],
    \ ['SpecialKey',      s:base[3],   s:base[0],   ''],
    \ ['SpellBad',        s:red[0],    s:base[0],   'underline'],
    \ ['SpellCap',        s:yellow[0], s:base[0],   ''],
    \ ['SpellLocal',      s:yellow[0], s:base[0],   ''],
    \ ['SpellRare',       s:yellow[0], s:base[0],   ''],
    \ ['StatusLine',      s:base[4],   s:base[1],   ''],
    \ ['StatusLineNC',    s:base[3],   s:base[1],   ''],
    \ ['TabLine',         s:base[1],   s:base[3],   ''],
    \ ['TabLineFill',     s:base[3],   s:base[1],   ''],
    \ ['TabLineSel',      s:base[1],   s:green[0],  ''],
    \ ['Title',           '',          s:base[0],   ''],
    \ ['Visual',          '',          s:base[0],   'reverse'],
    \ ['VisualNOS',       '',          s:base[0],   'reverse'],
    \ ['WarningMsg',      s:red[0],    s:base[0],   ''],
    \ ['Whitespace',      s:base[2],   s:base[0],   ''],
    \ ['WildMenu',        s:base[1],   s:green[0],  ''],
    \ ['debugPC',         '',          s:base[0],   ''],
    \ ['debugBreakpoint', '',          s:base[0],   ''],
    \ ]

call s:hl(s:hlgroup)

" User colors (see 'hl-User')
let s:hluser = [
    \ ['User1', s:base[0],    s:green[1], ''],
    \ ['User2', s:base[0],    s:blue[1],  ''],
    \ ['User3', s:base[3],    s:base[1],  ''],
    \ ['User4', s:red[0],     s:base[1],  ''],
    \ ['User5', s:green[0],   s:base[1],  ''],
    \ ['User6', s:yellow[1],  s:base[1],  ''],
    \ ['User7', s:blue[1],    s:base[1],  ''],
    \ ['User8', s:magenta[0], s:base[1],  ''],
    \ ['User9', s:base[4],    s:base[1],  ''],
    \ ]

call s:hl(s:hluser)
