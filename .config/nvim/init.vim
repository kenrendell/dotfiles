" NEOVIM Configuration file

if $WAYLAND_DISPLAY == ''
    finish
endif

" Colors
syntax on
colorscheme hidark

" ====================== OPTIONS ====================== "

if !isdirectory(expand('$XDG_DATA_HOME/nvim/undo/', 1))
    silent call mkdir(expand('$XDG_DATA_HOME/nvim/undo', 1), 'p')
endif

if !isdirectory(expand('$XDG_DATA_HOME/nvim/backup/', 1))
    silent call mkdir(expand('$XDG_DATA_HOME/nvim/backup', 1), 'p')
endif

if !isdirectory(expand('$XDG_DATA_HOME/nvim/swap/', 1))
    silent call mkdir(expand('$XDG_DATA_HOME/nvim/swap', 1), 'p')
endif

" Swap file
set directory=$XDG_DATA_HOME/nvim/swap

" Backup file
set backup
set writebackup
set backupdir=$XDG_DATA_HOME/nvim/backup

" Undo file
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set undolevels=1000
set undoreload=10000

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
if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
    silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
endif

" Load plugins
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ALE'
Plug 'sheerun/vim-polyglot'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
call plug#end()

" Fuzzy finder
let g:fzf_layout = { 'down': '40%' }
let g:fzf_action = { 'ctrl-t': 'tab split',
                   \ 'ctrl-s': 'split',
                   \ 'ctrl-v': 'vsplit' }

" ALE Linter
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_delay = 1000
let g:ale_sign_error = '●'
let g:ale_sign_warning = '•'
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_set_highlights = 1
let g:ale_set_signs = 1
let g:ale_echo_cursor = 1
let g:ale_virtualtext_cursor = 0
let g:ale_cursor_detail = 0
let g:ale_set_balloons = 0

" Disable netrw file explorer
let g:loaded_netrwPlugin = 1

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

" alt + {a, s, w, d}          := Move current window focus to the {left, bottom, top, right}.
" alt + shift + {a, s, w, d}  := Move current window to be at the far {left, bottom, top, right}.
" alt + ctrl + {h, j, k, l}   := Resize current window.
" alt + e                     := Edit new window in horizontal split.
" alt + shift + e             := Edit new window in vertical split.
" alt + r                     := Equalize all windows.
" alt + shift + r             := Maximize the current window.
" alt + x                     := Close all windows except the current window.
" alt + shift + x             := Move current window to new tab.
" alt + q                     := Save (if changed) and close the current window.
" alt + shift + q             := Close (without checking for changes) the current window.

for mde in ['n', 't', 'i', 'v']
    let nmde = (mde == 'n' ? '' : '<C-\><C-n>')
    let tmde = [(mde == 't' ? ' \| else \| startinsert' : ''), (mde == 't' ? '<Esc>' : ''), (mde == 't' ? ' \| startinsert' : '')]

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
        let res = [(key[0] == 'h' || key[0] == 'l' ? 'vertical ' : ''), (key[0] == 'h' || key[0] == 'j' ? '-' : '+')]
        exe mde . 'noremap <silent> <A-' . key[1] . '> ' . nmde . ':if winnr() != winnr("' . key[0] . '") \| wincmd ' . key[0] . tmde[0] . ' \| endif<CR>'
        exe mde . 'noremap <silent> <A-S-' . key[1] . '> ' . nmde . ':if winnr("$") > 1 \| wincmd ' . toupper(key[0]) . ' \| endif' . tmde[2] . '<CR>'
        exe mde . 'noremap <silent> <A-C-' . key[0] . '> ' . nmde . ':if winnr("$") > 1 \| ' . res[0] . 'resize ' . res[1] . '5 \| endif' . tmde[2] . '<CR>'
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

" Commenting
nnoremap <silent> <leader>- :call ToggleComment()<CR>
vnoremap <silent> <leader>- :call ToggleComment()<CR>

" Formatting (Remove trail whitespaces and fix indentation)
nnoremap <silent> <leader><space> mz:%s/\s\+$//e<CR>`z
nnoremap <silent> <leader><tab> mzgg=G`z

" Invert options
nnoremap <silent> <leader>m :setlocal invmodifiable<CR>
nnoremap <silent> <leader>p :setlocal invpaste<CR>
nnoremap <silent> <leader>s :setlocal invspell<CR>

" FZF
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>f\ :Lines<CR>
nnoremap <silent> <leader>fh :History<CR>
