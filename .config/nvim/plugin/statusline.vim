if exists('g:loaded_statusline') || $WAYLAND_DISPLAY ==# ''
    finish
else
    let g:loaded_statusline = 1
endif

let s:save_cpo = &cpoptions
set cpoptions&vim

" =================================== "
" =================================== "

" ==== Statusline ==== "

function! Statusline(mode, return)
    let l:statusline = ''

    if a:mode == 2
        setlocal nonumber norelativenumber
        let &l:statusline = '%9* %{b:term_title} %*%<'
        return
    elseif &buftype ==# 'terminal'
        return
    elseif a:mode == 1
        let l:statusline .= '%{%&modified?"%2*":"%1*"%}%( %{get(b:,"gitsigns_status","")} |%) '
        let l:statusline .= '%t%( %{&modifiable?"":"-"}%)%( %{&modified?"+":""}%) %* %=%<%9*%{expand("%:~:.:h")}%* '
        let l:statusline .= '%3*%{&filetype!=#""?&filetype:"no-ft"} %{&fileencoding!=#""?&fileencoding:&encoding}%*'
        let l:statusline .= '%8*%( %{&readonly?"RO":""}%)%( %{&previewwindow?"PRV":""}%)%( %{&spell?"SPELL":""}%)'
        let l:statusline .= '%( %{&paste?"PASTE":""}%)%* %c:0x%B %l/%L %(%{%LinterStatus()%} %)%*'
    else
        let l:statusline .= '%* %t%( %{&modifiable?"":"-"}%)%( %{&modified?"+":""}%) %=%<'
        let l:statusline .= '%{&filetype!=#""?&filetype:"no-ft"} %{&fileencoding!=#""?&fileencoding:&encoding}'
        let l:statusline .= '%( %{&readonly?"RO":""}%)%( %{&previewwindow?"PRV":""}%)%( %{&spell?"SPELL":""}%)'
        let l:statusline .= '%( %{&paste?"PASTE":""}%) %c:0x%B %l/%L '
    endif

    if a:return == 1
        return l:statusline
    endif

    let &l:statusline = l:statusline
endfunction

" ==== Statusline functions ==== "

" ---- Update statusline for inactive windows ---- "

" Useful when opening vim with multiple files in split
" Iterates over windows and set inactive statuslines
function! SetInactiveStatusline() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', Statusline(0, 1))
        endif
    endfor
endfunction

" ---- Linter status ---- "

function! LinterStatus() abort
    if !exists('b:linter_status')
        let b:linter_status = ''

        if exists('g:loaded_ale')
            let l:count = ale#statusline#Count(bufnr())
            let l:info = l:count.info
            let l:warning = l:count.warning + l:count.style_warning
            let l:error = l:count.error + l:count.style_error

            let b:linter_status = (l:info > 0 ? '%5*I:' . l:info : '')
                \ . (l:warning > 0 ? (l:info > 0 ? ' ' : '') . '%6*W:' . l:warning : '')
                \ . (l:error > 0 ? (l:info + l:warning > 0 ? ' ' : '') . '%7*E:' . l:error : '')
        endif
    endif

    return b:linter_status
endfunction

" ==== Statusline autocommands ==== "

augroup StatuslineEvents
    autocmd!
    autocmd User ALELintPost unlet! b:linter_status
    autocmd VimEnter * call SetInactiveStatusline()
    autocmd WinEnter,BufWinEnter * call Statusline(1, 0)
    autocmd WinLeave * call Statusline(0, 0)
augroup END

augroup TerminalEvents
    autocmd!
    autocmd WinEnter,BufWinEnter term://* startinsert
    autocmd TermOpen * startinsert
    autocmd TermEnter * call Statusline(2, 0)
    autocmd TermClose * call feedkeys("\<Esc>")
augroup END

" ==== Set options ==== "

set laststatus=2
set showmode
set noruler

" =================================== "
" =================================== "

let &cpoptions = s:save_cpo
unlet s:save_cpo
