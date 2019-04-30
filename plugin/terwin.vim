" Location: plugin/terwin.vim
" Maintainer: Kebin Liu <https://lkebin.com>

if exists('g:load_terwin') || v:version < 801 || &cp
    finish
endif
let g:load_terwin = 1

let g:TerWinSize = 10
let g:TerWinCmd = &shell 
let g:TerWinBufName = 'TerWin'
let g:TerWinLocation = 'botright'

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

function! s:terWinClose()
    silent! execute 'close ' . s:terWinNum()
endfunction

function! s:terWinOpen()
    silent! execute g:TerWinLocation . ' ' . g:TerWinSize . ' split'
    silent! execute 'buffer ' . g:TerWinBufName
endfunction

function! s:terWinCreate() abort
    silent! execute g:TerWinLocation . " " . g:TerWinSize . ' new'

    let l:options = {}
    let l:options['term_name'] = g:TerWinBufName
    let l:options['curwin'] = 1
    let l:options['term_finish'] = 'close'

    call term_start(g:TerWinCmd, l:options)

    setlocal winfixheight
    let b:TerWin = 1
endfunction

function! s:terWinExists()
    if !exists('g:TerWinBufName')
        return
    end

    "check b:TerWin is still there and hasn't been e.g. :bdeleted
    return !empty(getbufvar(bufnr(g:TerWinBufName), 'TerWin'))
endfunction

function! s:terWinNum() abort
    if exists('g:TerWinBufName')
        return bufwinnr(g:TerWinBufName)
    endif

    return -1
endfunction

function! s:terWinIsOpen()
    return s:terWinNum() != -1
endfunction
