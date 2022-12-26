" NEOVIM Configuration file

if $WAYLAND_DISPLAY ==# ''
    finish
endif

" Colors
syntax on
colorscheme ansi

" ====================== OPTIONS ====================== "

filetype plugin indent on

set title
set autoread
set wildmenu

" Don't show the startup message
set shortmess+=I

" Indentation
set autoindent
set smartindent
set smarttab
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Scrolling
set nowrap
set sidescrolloff=4
set scrolloff=4

" Searching
set inccommand=nosplit
set incsearch
set hlsearch
set ignorecase
set smartcase

" Line number
set number
set relativenumber
set numberwidth=5

" List
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Spelling
set spelllang=en_us

" Folding
set nofoldenable
set foldmethod=indent
set foldlevel=20

" Windows
set equalalways
set eadirection=both
set winminheight=0
set winminwidth=0
set splitbelow
set splitright

" Clipboard
set clipboard=unnamedplus

" ====================== PLUGINS ====================== "

" Install plugins：           :PlugInstall
" Update plugins：            :PlugUpdate
" Remove plugins：            :PlugClean
" Check the plugin status：   :PlugStatus
" Examine changes:            :PlugDiff
" Upgrade vim-plug itself：   :PlugUpgrade

" Install vim-plug if not installed
" if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
    " silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
        " \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    " autocmd VimEnter * PlugInstall --sync
" endif

" Load plugins
" call plug#begin('$XDG_DATA_HOME/nvim/plugged')
" Plug 'junegunn/fzf.vim'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'neovim/nvim-lspconfig'
" Plug 'hrsh7th/nvim-cmp'
" Plug 'mfussenegger/nvim-dap'
" Plug 'lewis6991/gitsigns.nvim'
" Plug 'dense-analysis/ALE'
" Plug 'sheerun/vim-polyglot'
" Plug 'airblade/vim-gitgutter'
" call plug#end()


" ===================== MAPPINGS ====================== "

"==== Tab management ===="

" F{1..12}          := Move focus to tab 1 - 12.
" shift + F{1..12}  := Move current tab to tab 1 - 12.
" alt + ctrl + n    := Move focus to next tab.
" alt + ctrl + p    := Move focus to previous tab.
" alt + ctrl + i    := Insert new tab.
" alt + ctrl + u    := Close current tab.
" alt + ctrl + o    := Close all tabs except the current tab.

"==== Window management ===="

" alt + shift + {a, s, w, d}  := Resize current window.
" alt + shift + {h, j, k, l}  := Move current window focus to the {left, bottom, top, right}.
" alt + ctrl + {h, j, k, l}   := Move current window to be at the far {left, bottom, top, right}.
" alt + e                     := Edit new window in horizontal split.
" alt + shift + e             := Edit new window in vertical split.
" alt + r                     := Equalize all windows.
" alt + shift + r             := Maximize the current window.
" alt + x                     := Close all windows except the current window.
" alt + shift + x             := Move current window to new tab.
" alt + q                     := Save (if changed) and close the current window.
" alt + shift + q             := Close (without checking for changes) the current window.

for mde in ['n', 't', 'i', 'v']
    let nmde = (mde ==# 'n' ? '' : '<C-\><C-n>')
    let tmde = [(mde ==# 't' ? ' \| else \| startinsert' : ''), (mde ==# 't' ? '<Esc>' : ''), (mde ==# 't' ? ' \| startinsert' : '')]

    for nr in range(1, 12)
        let checktab = ':if tabpagenr("$") >= ' . nr . ' && tabpagenr() != ' . nr . ' \| '
        exe mde . 'noremap <silent> <F' . nr . '> ' . nmde . checktab . 'tabnext ' . nr . tmde[0] . ' \| endif<CR>'
        exe mde . 'noremap <silent> <F' . (nr + 12) . '> ' . nmde . checktab . 'let step = ' . nr . ' - tabpagenr() \| exec "tabmove " . (step > 0 ? "+" . step : step) \| unlet step \| endif' . tmde[2] . '<CR>'
    endfor

    exe mde . 'noremap <silent> <A-C-n> ' . nmde . ':if tabpagenr("$") > 1 \| tabnext' . tmde[0] . ' \| endif<CR>'
    exe mde . 'noremap <silent> <A-C-p> ' . nmde . ':if tabpagenr("$") > 1 \| tabprevious' . tmde[0] . ' \| endif<CR>'
    exe mde . 'noremap <silent> <A-C-u> ' . nmde . ':if tabpagenr("$") > 1 \| tabclose' . tmde[0] . ' \| endif<CR>'
    exe mde . 'noremap <silent> <A-C-o> ' . nmde . ':if tabpagenr("$") > 1 \| tabonly \| endif' . tmde[2] . '<CR>'
    exe mde . 'noremap <silent> <A-C-i> ' . nmde . ':tabnew<CR>' . tmde[1]

    for key in [['h', 'a'], ['j', 's'], ['k', 'w'], ['l', 'd']]
        let res = [(key[0] ==# 'h' || key[0] ==# 'l' ? 'vertical ' : ''), (key[0] ==# 'h' || key[0] ==# 'j' ? '-' : '+')]
        exe mde . 'noremap <silent> <A-S-' . key[1] . '> ' . nmde . ':if winnr("$") > 1 \| ' . res[0] . 'resize ' . res[1] . '5 \| endif' . tmde[2] . '<CR>'
        exe mde . 'noremap <silent> <A-S-' . key[0] . '> ' . nmde . ':if winnr() != winnr("' . key[0] . '") \| wincmd ' . key[0] . tmde[0] . ' \| endif<CR>'
        exe mde . 'noremap <silent> <A-C-' . key[0] . '> ' . nmde . ':if winnr("$") > 1 \| wincmd ' . toupper(key[0]) . ' \| endif' . tmde[2] . '<CR>'
    endfor

    exe mde . 'noremap <silent> <A-e> ' . nmde . ':new<CR>' . tmde[1]
    exe mde . 'noremap <silent> <A-S-e> ' . nmde . ':vnew<CR>' . tmde[1]
    exe mde . 'noremap <silent> <A-r> ' . nmde . ':if winnr("$") > 1 \| wincmd = \| endif' . tmde[2] . '<CR>'
    exe mde . 'noremap <silent> <A-S-r> ' . nmde . ':if winnr("$") > 1 \| wincmd _ \| wincmd \| \| endif' . tmde[2] . '<CR>'
    exe mde . 'noremap <silent> <A-x> ' . nmde . ':if winnr("$") > 1 \| only \| endif' . tmde[2] . '<CR>'
    exe mde . 'noremap <silent> <A-S-x> ' . nmde . ':if winnr("$") > 1 \| wincmd T \| endif' . tmde[2] . '<CR>'
    exe mde . 'noremap <silent> <A-q> ' . nmde . ':exit<CR>'
    exe mde . 'noremap <silent> <A-S-q> ' . nmde . ':quit!<CR>'
endfor

unlet mde nmde tmde nr checktab key res

" Map leader
let mapleader = ' '

" Radraw
nnoremap <silent> <C-l> :nohlsearch<C-r>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-l>

" Location list
nnoremap <silent> <A-z> :lopen<CR>
nnoremap <silent> <A-S-z> :lclose<CR>
nnoremap <silent> <A-S-n> :lnext<CR>
nnoremap <silent> <A-S-p> :lprevious<CR>

" Formatting (Remove trail whitespaces and fix indentation)
nnoremap <silent> <leader><space> mz:%s/\s\+$//e<CR>`z
nnoremap <silent> <leader><tab> mzgg=G`z

" Invert options
nnoremap <silent> <leader>m :setlocal invmodifiable<CR>
nnoremap <silent> <leader>p :setlocal invpaste<CR>
nnoremap <silent> <leader>s :setlocal invspell<CR>

lua << EOF
require('settings.statusline')
require('settings.tabline')
require('settings.options')
require('settings.autocmds')
require('settings.mappings')

require('packman.setup') {
	-- Additional module for nvim-treesitter
	'https://github.com/p00f/nvim-ts-rainbow.git',

	-- Dependency for gitsigns and telescope plugin
	'https://github.com/nvim-lua/plenary.nvim.git',

	{ -- Highlighting
		'https://github.com/nvim-treesitter/nvim-treesitter.git',
		config = 'plugin-config/nvim-treesitter.lua'
	},

	{ -- Git decorations
		'https://github.com/lewis6991/gitsigns.nvim.git',
		config = 'plugin-config/gitsigns.lua'
	},

	{ -- Fuzzy finder
		'https://github.com/nvim-telescope/telescope.nvim.git',
		config = 'plugin-config/telescope.lua'
	},

	{ -- File explorer tree
		'https://github.com/kyazdani42/nvim-tree.lua.git',
		config = 'plugin-config/nvim-tree.lua'
	},

	{ -- Commenter
		'https://github.com/numToStr/Comment.nvim.git',
		config = 'plugin-config/comment.lua'
	},
	
	{ -- Debugger
		'https://github.com/mfussenegger/nvim-dap.git',
		config = 'plugin-config/nvim-dap.lua'
	},

	{ -- Notes
		'https://github.com/nvim-neorg/neorg',
		config = 'plugin-config/neorg.lua'
	},

	{
		'https://github.com/mickael-menu/zk-nvim',
		config = 'plugin-config/zk-nvim.lua'
	}
}
EOF
