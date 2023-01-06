function! ClearCmdLine(timer)
    echo ''
endfunction

function HasWin(c) 
    let from = winnr()
    execute "wincmd " . a:c
    let to = winnr()
    execute from . "wincmd w"
    return from == to
endfunction

function s:WinResize() 
    while 1
        if HasWin('h') && HasWin('j') && HasWin('k') && HasWin('l') 
            echo "[only window, no resize]"
            return
        endif
        echo '[window resize... <CR> to quit]'
        if exists('s:winResizeTimer')
            call timer_stop(s:winResizeTimer)
        endif
        let s:winResizeTimer = timer_start(800, {-> feedkeys("\<CR>")})
        let c = getchar()
        let n = winnr()
        let isCap = c == char2nr('H') || c == char2nr('J') || c == char2nr('K') || c == char2nr('L')
        let step = isCap? 10 : 3 
        let shifted = 0
        if c == char2nr("h") || c == char2nr("H")
            if !HasWin('h') | wincmd h | let shifted = 1 | endif
            execute 'vertical resize '. (HasWin('l')? '+':'-'). step
        elseif (c == char2nr("j") || c == char2nr("J")) && !(HasWin('k') && HasWin('j'))
            execute 'resize ' . (HasWin('j')?'-':'+') . step
        elseif ( c == char2nr("k") || c == char2nr("K") ) && !(HasWin('k') && HasWin('j'))
            execute 'resize ' . (HasWin('j')?'+':'-') . step
        elseif c == char2nr("l")  || c == char2nr("L")
            if !HasWin('h') | wincmd h | let shifted = 1 | endif
            execute 'vertical resize '. (HasWin('l')? '-':'+'). step
        elseif c == char2nr('=')
            execute 'wincmd ='
        elseif c == 13
            redraw
            echo "[window resize done]"
            call timer_start(1500, 'ClearCmdLine')
            return
        endif
        if shifted 
            execute n . "wincmd w" 
        endif
        redraw
    endwhile
endfun

command! -nargs=0 WinResize :call <SID>WinResize()

