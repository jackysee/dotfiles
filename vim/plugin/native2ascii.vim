let s:n2a= {}

function! s:n2a.encode(s)
    " `s' is &encoding
    let chars= split(a:s, '\zs')
    let length= len(chars)
    let buf= []
    let i= 0

    while i < length
        let c= iconv(chars[i], &encoding, 'utf8')
        let cn= char2nr(c, 1)
        let i+= 1

        if cn > 0x003d && cn < 0x007f
            let buf+= [c]
        elseif c ==# ' '
            let buf+= [' ']
        elseif c ==# "\t"
            let buf+= ['\', 't']
        elseif c ==# "\n"
            let buf+= ['\', 'n']
        elseif c ==# "\r"
            let buf+= ['\', 'r']
        elseif c ==# "\f"
            let buf+= ['\', 'f']
        else
            if cn < 0x0020 || cn > 0x007e
                let buf+= ['\', 'u', printf('%04x', cn)]
            else
                let buf+= [c]
            endif
        endif
    endwhile

    return iconv(join(buf, ''), 'utf8', &encoding)
endfunction

function! s:n2a.decode(s)
    let chars= split(a:s, '\zs')
    let length= len(chars)
    let buf= []
    let i= 0

    while i < length
        let c= chars[i]
        let i+= 1

        if c ==# '\' && i < length
            let c= chars[i]
            let i+= 1

            if c ==# 'u'
                " read the xxxx
                let buf+= s:nr2char(eval('0x' . join(chars[i : (i + 3)], '')))
                let i+= 4
            else
                let buf+= ['\', c]
            endif
        else
            let buf+= [c]
        endif
    endwhile

    return join(buf, '')
endfunction

function! s:nr2char(nr)
    let c= iconv(nr2char(a:nr, 1), 'utf8', &encoding)

    if c !=# '?'
        return [c]
    else
        return ['\', 'u'] + split(printf('%04x', a:nr), '\zs')
    endif
endfunction

function! s:decode(lnum, ...)
    let lines= getline(a:lnum, get(a:000, 0, a:lnum))
    let buf= []

    for line in lines
        let buf+= [s:n2a.decode(line)]
    endfor

    call setline(a:lnum, buf)
endfunction

" あ => \uxxxx
function! s:encode(lnum, ...)
    let lines= getline(a:lnum, get(a:000, 0, a:lnum))
    let buf= []

    for line in lines
        let buf+= [s:n2a.encode(line)]
    endfor

    call setline(a:lnum, buf)
endfunction

command! -nargs=? -range EditPropsEncode call <SID>encode(<line1>, <line2>)
command! -nargs=? -range EditPropsDecode call <SID>decode(<line1>, <line2>)
