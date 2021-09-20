if exists('g:loaded_statusline') || $WAYLAND_DISPLAY == ''
    finish
else
    let g:loaded_statusline = 1
endif

let s:save_cpo = &cpo
set cpo&vim

" =================================== "
" =================================== "

" ==== Statusline ==== "

function! Statusline(mode)
    let l:statusline = ''

    if a:mode == 1
        let l:stlparts = [s:FilePath(), s:SetOptions(), s:CurrentPosition(), s:FileInfo(),
            \ s:FormatStatus(), s:GitStatus(), s:LinterStatus(), s:FileName()]

        let [l:filepath, l:setopts, l:current_pos, l:fileinfo, l:format_status,
            \ l:git_status, l:linter_status, l:filename] = s:TrimStatusline(l:stlparts)

        let l:statusline .= '%' . (&modified ? '2' : '1') . '*' . l:filename . '%*%3*' . l:filepath . '%*%='
        let l:statusline .= '%7*' . l:git_status . '%*%5*' . l:fileinfo . '%*%8*' . l:setopts . '%*'
        let l:statusline .= '%9*' . l:current_pos . '%*%6*' . l:format_status . '%*%4*' . l:linter_status . '%*'
    elseif a:mode == 2
        let l:statusline .= ' %3*%{b:term_title}%* %=%< '
    else
        let l:statusline .= ' %t%{&modifiable?"":" -"}%{&modified?" +":""} %=%< %{&filetype!=#""?&filetype:"no-ft"}'
        let l:statusline .= '%( %{&fileencoding!=#""?&fileencoding:&encoding}%)%( %{&fileformat!=#""?&fileformat:""}%)'
        let l:statusline .= '%( %R%)%( %W%)%{&spell?" SPELL":""}%{&paste?" PASTE":""} %c:0x%B %l/%L %p%% '
    endif

    return l:statusline
endfunction

" ==== Statusline functions ==== "

" ---- Update statusline for inactive windows ---- "

" Useful when opening vim with multiple files in split
" Iterates over windows and set inactive statuslines
function! s:SetInactiveStatusline() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!Statusline(0)')
        endif
    endfor
endfunction

" ---- Trim active statusline ---- "

function! s:TrimStatusline(stlparts) abort
    let l:winwidth = winwidth(0)

    for count in range(len(a:stlparts))
        if strlen(join(a:stlparts, '')) <= l:winwidth
            break
        endif

        let a:stlparts[count] = ''
    endfor

    return a:stlparts
endfunction

" ---- File name ---- "

function! s:FileName() abort
    let l:filename = expand('%:t')
    let l:filename = ' ' . (l:filename !=# '' ? l:filename : '[No Name]') .
        \ (&modifiable ? '' : ' -') . (&modified ? ' +' : '') . ' '
    return l:filename
endfunction

" ---- File path ---- "

function! s:FilePath() abort
    let l:filepath = ' ' . expand('%:~:.:h') . ' '
    return l:filepath
endfunction

" ---- Set options ---- "

function! s:SetOptions() abort
    let l:setopts = (&readonly ? ' RO' : '') . (&previewwindow ? ' PRV' : '') . (&spell ? ' SPELL' : '') . (&paste ? ' PASTE' : '')
    let l:setopts .= (l:setopts !=# '' ? ' ' : '')
    return l:setopts
endfunction

" ---- Current position ---- "

function! s:CurrentPosition() abort
    if !exists('b:current_pos')
        let l:curline = line('.')
        let l:lastline = line('$')
        let l:curcol = col('.')

        redir => l:charinfo
        silent! ascii
        redir END

        let l:chardec = split(substitute(l:charinfo, '^.*>\s\+', '', ''), ',')[0]
        let l:curlineperc = (l:curline * 100.0) / l:lastline
        let b:current_pos = printf(' %d:0x%X %d/%d %.2f%%%% ', l:curcol, l:chardec, l:curline, l:lastline, l:curlineperc)
    endif

    return b:current_pos
endfunction

" ---- File permission ---- "

function! s:FilePermission() abort
    if !exists('b:fileperm')
        let b:fileperm = ''
        let l:perm = getfperm(expand('%:p'))

        if l:perm !=# ''
            let [l:permnr, l:count] = [0, 0]

            for char in split(l:perm, '\zs')
                let [l:permnr, l:count] += [(char !=# '-' ? [4, 2, 1][l:count] : 0), 1]

                if l:count > 2
                    let b:fileperm .= l:permnr
                    let [l:permnr, l:count] = [0, 0]
                endif
            endfor
        endif
    endif

    return b:fileperm
endfunction

" ---- File size ---- "

function! s:HumanByte(bytes) abort
    let l:bytes = a:bytes
    let l:iec_unit = ['B', 'KiB', 'MiB', 'GiB']
    let l:count = 0

    while l:bytes >= 1024
        let l:bytes = l:bytes / 1024.0
        let l:count += 1
    endwhile

    return printf('%0.2f %s', l:bytes, l:iec_unit[l:count])
endfunction

function! s:FileSize() abort
    if !exists('b:filesize')
        let b:filesize = ''
        let l:bytes = getfsize(expand('%:p'))

        if l:bytes > 0
            let b:filesize = s:HumanByte(l:bytes)
        endif
    endif

    return b:filesize
endfunction

" ---- File information ---- "

function! s:FileInfo() abort
    let l:fileperm = s:FilePermission()
    let l:filesize = s:FileSize()
    let l:fileinfo = ' ' . (&filetype !=# '' ? &filetype : 'no-ft') .
        \ (&fileencoding !=# '' ? ' ' . &fileencoding : ' ' . &encoding) .
        \ (&fileformat !=# '' ? ' ' . &fileformat : '') .
        \ (l:fileperm !=# '' ? ' ' . l:fileperm : '') .
        \ (l:filesize !=# '' ? ' ' . l:filesize : '') . ' '

    return l:fileinfo
endfunction

" ---- Indent warning ---- "

" return '&et' if &et (expandtab) is set wrong
" return 'mix' if spaces and tabs are used to indent
" return an empty string if everything is fine
function! s:IndentWarning() abort
    let l:indent_warning = ''
    let l:tabs = search('^\t', 'nw') > 0
    let l:spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') > 0

    if l:tabs && l:spaces
        let l:indent_warning = 'mix'
    elseif (l:spaces && !&et) || (l:tabs && &et)
        let l:indent_warning = '&et'
    endif

    return l:indent_warning
endfunction

" ---- Trailing space warning ---- "

function! s:TrailSpaceWarning() abort
    let l:trail_space_warning = ''

    if search('\s\+$', 'nw') > 0
        let l:trail_space_warning = '*\s'
    endif

    return l:trail_space_warning
endfunction

" ---- Formatting status ---- "

function! s:FormatStatus() abort
    if !exists('b:format_status')
        let b:format_status = ''

        if &modifiable
            let l:indent_warning = s:IndentWarning()
            let l:trail_space_warning = s:TrailSpaceWarning()
            let b:format_status = (l:indent_warning !=# '' ? ' ' . l:indent_warning : '') .
                \ (l:trail_space_warning !=# '' ? ' ' . l:trail_space_warning : '')
            let b:format_status .= (b:format_status !=# '' ? ' ' : '')
        endif
    endif

    return b:format_status
endfunction

" ---- Linter status ---- "

function! s:LinterStatus() abort
    if !exists('b:linter_status')
        let b:linter_status = ''

        if exists('g:loaded_ale')
            let l:counts = ale#statusline#Count(bufnr())
            let l:errors = l:counts.error + l:counts.style_error
            let l:warnings = l:counts.total - l:errors
            let b:linter_status = (l:warnings > 0 ? ' W:' . l:warnings : '') . (l:errors > 0 ? ' E:' . l:errors : '')
            let b:linter_status .= (b:linter_status !=# '' ? ' ' : '')
        endif
    endif

    return b:linter_status
endfunction

" ---- Git status ---- "

function! s:GitStatus() abort
    if !exists('b:git_status')
        let b:git_status = ''

        if exists('g:loaded_gitgutter')
            let [l:added, l:modified, l:removed] = GitGutterGetHunkSummary()
            let b:git_status = (l:added > 0 ? ' +' . l:added : '') .
                \ (l:modified > 0 ? ' ~' . l:modified : '') .
                \ (l:removed > 0 ? ' -' . l:removed : '')
            let b:git_status .= (b:git_status !=# '' ? ' ' : '')
        endif
    endif

    return b:git_status
endfunction

" ==== Statusline autocommands ==== "

augroup StatuslineEvents
    autocmd!
    autocmd CursorMoved,CursorMovedI * unlet! b:current_pos
    autocmd CursorHold,InsertLeave,BufWritePost * unlet! b:format_status
    autocmd FileChangedShellPost,BufWritePost * unlet! b:fileperm b:filesize
    autocmd User ALELintPost unlet! b:linter_status
    autocmd User GitGutter unlet! b:git_status
    autocmd VimEnter * call s:SetInactiveStatusline()
    autocmd WinEnter,BufWinEnter * if &buftype != 'terminal' |
        \ setlocal statusline=%!Statusline(1) | endif
    autocmd WinLeave * if &buftype != 'terminal' |
        \ setlocal statusline=%!Statusline(0) | endif
augroup END

augroup TerminalEvents
    autocmd!
    autocmd WinEnter,BufWinEnter term://* startinsert
    autocmd TermOpen * startinsert
    autocmd TermEnter * setlocal statusline=%!Statusline(2) nonu nornu
    autocmd TermClose * call feedkeys("\<Esc>")
augroup END

" ==== Set options ==== "

set laststatus=2
set showmode
set noruler

" =================================== "
" =================================== "

let &cpo = s:save_cpo
unlet s:save_cpo
