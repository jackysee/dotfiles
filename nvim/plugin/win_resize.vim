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
        let h = char2nr('h')
        let H = char2nr('H')
        let j = char2nr('j')
        let J = char2nr('J')
        let k = char2nr('k')
        let K = char2nr('K')
        let l = char2nr('l')
        let L = char2nr('L')
        let step = (c == H || c == J || c == K || c == L)? 10 : 3 
        let shifted = 0
        if c == h || c == H
            if !HasWin('h') | wincmd h | let shifted = 1 | endif
            execute 'vertical resize '. (HasWin('l')? '+':'-'). step
        elseif (c == j || c == J && !(HasWin('k') && HasWin('j'))
            execute 'resize ' . (HasWin('j')?'-':'+') . step
        elseif ( c == k || c == K ) && !(HasWin('k') && HasWin('j'))
            execute 'resize ' . (HasWin('j')?'+':'-') . step
        elseif c == l  || c == L
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

command -nargs=0 WinResize :call <SID>WinResize()

