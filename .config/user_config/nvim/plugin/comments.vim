if exists('g:loaded_comments') || $SHLVL == 1
    finish
else
    let g:loaded_comments = 1
endif

let s:save_cpo = &cpo
set cpo&vim

" =================================== "
" =================================== "

" ==== Comments ==== "

let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "zsh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "dosini": ';',
    \   "dircolors": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "sxhkdrc": '#',
    \   "vim": '"',
    \   "tex": '%',
    \ }

" ==== Toggle comments ==== "

function! ToggleComment()
    if getline('.') =~ '^\s*$'
        " Skip empty line
        return
    elseif has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ '^\s*' . comment_leader
            " Uncomment the line
            exe 'silent s/\v\s*\zs' . comment_leader . '\s*\ze//'
        else
            " Comment the line
            exe 'silent s/\v^(\s*)/\1' . comment_leader . ' /'
        endif
    else
        echo "No comment leader found for filetype"
    endif
endfunction

" =================================== "
" =================================== "

let &cpo = s:save_cpo
unlet s:save_cpo
