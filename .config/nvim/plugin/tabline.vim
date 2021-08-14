if exists('g:loaded_tabline') || $DISPLAY == ''
    finish
else
    let g:loaded_tabline = 1
endif

let s:save_cpo = &cpo
set cpo&vim

" =================================== "
" =================================== "

" ==== Tabline ==== "

function! Tabline()
    let [l:tablist, l:tabline, l:activetab, l:tab] = [[], '', 0, 1]
    let [l:tablen, l:maxlen] = [0, &columns]
    let [l:prevsym, l:sepsym, l:nextsym] = ['<|', '|', '|>']

    while l:tab <= tabpagenr('$')
        let l:active = (l:tab == tabpagenr())
        let l:splits = tabpagewinnr(l:tab, '$')
        let l:bufnum = tabpagebuflist(l:tab)[tabpagewinnr(l:tab) - 1]
        let l:bufname = bufname(l:bufnum)

        let l:tabname = (l:bufname !=# '' ? fnamemodify(l:bufname, ':t') : '[No Name]')
        let l:modified = getbufvar(l:bufnum, '&modified')
        let l:modifiable = getbufvar(l:bufnum, '&modifiable')

        let l:activetab = (l:active ? l:tab : l:activetab)
        let l:color = (l:active ? (l:modified ? '2' : '1' ) : (l:modified ? '7' : '3' )) . '*'

        let [l:lsym, l:rsym] = [(l:tab > 1 && empty(l:tablist) ? l:prevsym : (!empty(l:tablist) ? l:sepsym : '')), l:nextsym]
        let l:tabnum = ' ' . l:tab . (l:splits > 1 ? '.' . l:splits : '') . ' '
        let l:tablabel = l:tabname . ' ' . (l:modifiable ? '' : '- ') . (l:modified ? '+ ' : '')
        let l:len = strlen(l:lsym . l:tabnum . l:tablabel)
        let l:tablen += l:len

        let l:tabitem = l:lsym . '%' . l:tab . 'T%' . l:color . l:tabnum . l:tablabel . '%*%T'
        let l:tablist += (l:tablen <= l:maxlen ? [l:tabitem] : [])

        if l:tablen > l:maxlen && !empty(l:tablist)
            let l:tablen += strlen(l:rsym) - l:len

            if l:tablen > l:maxlen && len(l:tablist) > 1
                if l:activetab && l:activetab < l:tab - 1
                    let l:tablist = l:tablist[:-2]
                    let l:tablist[-1] = l:tablist[-1] . l:rsym
                    break
                else
                    let [l:tablist, l:tablen] = [[], 0]
                    let l:tab -= 1
                    continue
                endif
            endif

            if l:activetab && l:activetab < l:tab
                if len(l:tablist) == 1 && l:tablen > l:maxlen
                    let l:tablist = []
                else
                    let l:tablist[-1] = l:tablist[-1] . l:rsym
                endif
                break
            else
                let [l:tablist, l:tablen] = [[], 0]
                continue
            endif
        endif

        let l:tab += 1
    endwhile

    for tabitem in l:tablist
        let l:tabline .= tabitem
    endfor

    return l:tabline
endfunction

" ==== Set options ==== "

set tabline=%!Tabline()
set showtabline=1
set tabpagemax=12
set hidden

" =================================== "
" =================================== "

let &cpo = s:save_cpo
unlet s:save_cpo
