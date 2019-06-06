" Location: plugin/terwin.vim
" Maintainer: Kebin Liu <https://lkebin.com>

if exists('g:load_terwin') || v:version < 801 || &cp
    finish
endif
let g:load_terwin = 1

let s:TerWinSize = 10
let s:TerWinCmd = &shell 
let s:TerWinBufName = 'TerWin'
let s:TerWinLocation = 'botright'

command! TerWinToggle call TerWinToggle()

function! TerWinToggle()
    if s:terWinExists()
        if s:terWinIsOpen()
            call s:terWinClose()
        else
            call s:terWinOpen()
        endif
    else
        call s:terWinCreate()
    endif
endfunction

function! s:getTerWinSize()
    if !exists('g:TerWinSize')
        return s:TerWinSize
    else
        return get(g:, 'TerWinSize', s:TerWinSize)
    endif
endfunction

function! s:getTerWinCmd()
    if !exists('g:TerWinCmd')
        return s:TerWinCmd
    else
        return get(g:, 'TerWinCmd', s:TerWinCmd)
    endif
endfunction

function! s:getTerWinBufName()
    if !exists('g:TerWinBufName')
        return s:TerWinBufName
    else
        return get(g:, 'TerWinBufName', s:TerWinBufName)
    endif
endfunction

function! s:getTerWinLocation()
    if !exists('g:TerWinLocation')
        return s:TerWinLocation
    else
        return get(g:, 'TerWinLocation', s:TerWinLocation)
    endif
endfunction

function! s:terWinClose()
    silent! execute 'close ' . s:terWinNum()
endfunction

function! s:terWinOpen()
    silent! execute s:getTerWinLocation() . ' ' . s:getTerWinSize() . ' split'
    silent! execute 'buffer ' . s:getTerWinBufName()
endfunction

function! s:terWinCreate() abort
    silent! execute s:getTerWinLocation() . " " . s:getTerWinSize() . ' new'

    let l:options = {}
    let l:options['term_name'] = s:getTerWinBufName()
    let l:options['curwin'] = 1
    let l:options['term_finish'] = 'close'

    call term_start(s:getTerWinCmd(), l:options)

    setlocal winfixheight
    setlocal nobl
    let b:TerWin = 1
endfunction

function! s:terWinExists()
    return !empty(getbufvar(bufnr(s:getTerWinBufName()), 'TerWin'))
endfunction

function! s:terWinNum() abort
    return bufwinnr(s:getTerWinBufName())
endfunction

function! s:terWinIsOpen()
    return s:terWinNum() != -1
endfunction

