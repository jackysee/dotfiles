
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction


function! FugitiveStatus() abort
    if !exists('g:loaded_fugitive')
        return ''
    endif
    let l:status = FugitiveHead()
    return l:status
    " return l:status == '' ? '': "\ue725".l:status
endfunction

function! LawrenciumStatus() abort
    if !exists('g:loaded_lawrencium')
        return ''
    endif
    let l:status = lawrencium#statusline()
    return l:status
    " return l:status == '' ? '': "\ue725".l:status
endfunction

function! ChangedStatus() abort
    let l:summary = [0, 0, 0]
    if exists('b:sy.stats')
        let l:summary = b:sy.stats
    elseif exists('b:gitgutter.summary')
        let l:summary = b:gitgutter.summary
    endif
    if max(l:summary) > 0
        return '' . 
            \  (summary[0] > 0 ? printf('+%d', summary[0]) : '') .
            \  (summary[1] > 0 ? printf('~%d', summary[1]) : '') .
            \  (summary[2] > 0 ? printf('-%d', summary[2]) : '') . 
            \  ''
    endif
    return ''
endfunction

function! VcsInfoStatus() abort
    return FugitiveStatus(). LawrenciumStatus()
endfunction

function! s:is_tmp_file() abort
  if !empty(&buftype)
        \ || index(['startify', 'gitcommit'], &filetype) > -1
        \ || expand('%:p') =~# '^/tmp'
    return 1
  else
    return 0
  endif
endfunction

lua << EOF
function _G.lsp_progress()
    local lsp = vim.lsp.status()[1]
    if lsp then
        local name = lsp.name or ""
        local msg = lsp.message or ""
        local percentage = lsp.percentage or 0
        local title = lsp.title or ""
        return string.format(
            "%s: %s %s (%s%%%%) ",
            name,
            title,
            msg,
            percentage
        )
    end
    return ""
end

function _G.lsp_error()
    if not vim.tbl_isempty(vim.lsp.get_clients()) then
        local s = ""
        local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        if #errors > 0 then
            s = s .. "E" .. #errors
        end
        local warns = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        if #warns > 0 then
            s = s .. "W" .. #warns
        end
        return s
    end
    return ""
end

function is_empty(str)
    return str == nil or string.len(str) == 0
end

function _G.statusline_file_icon()
    if is_empty(vim.api.nvim_buf_get_name(0)) or not vim.g.nvim_web_devicons then
        return ""
    end
    return require("nvim-web-devicons").get_icon(vim.fn.expand("%"), nil, { default = true }) .. " "
end

EOF

function! LspStatus() abort
    return v:lua.lsp_progress() . v:lua.lsp_error()
endfunction

function! ModifiedStatus()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! ReadonlyStatus()
    return &ft !~? 'help' && &readonly ? '!' : ''
endfunction

function! FilenameStatus()
    let filename = '[No Name]'
    if expand('%:t') != ''
        let filename = expand('%:p:.')
        let sep = has('win64') ? '\\' : '/'
        let paths = split(filename, sep)
        if len(paths) > 4
            let filename = '.../' . join(paths[-3:], sep)
        endif
        let filename = v:lua.statusline_file_icon() . filename
    endif
    return ReadonlyStatus() . filename . ModifiedStatus()
endfunction

function! LineInfoStatus()
    " return '%P %-8(%3l:%c%)'
    return '%l|%L %2v|%-2{virtcol("$") - 1}'
endfunction


function! Matchup() abort
    if !exists('g:loaded_matchup')
        return ''
    endif
    let l:status = MatchupStatusOffscreen()
    return l:status
    " return l:status == '' ? '': "\ue725".l:status
endfunction

function! AddBracket(s)
    if exists('a:s')
        return (a:s == '')? '': ' ['.a:s.']'
    endif
    return ''
endfunction

function! AddSpace(s)
    if exists('a:s')
        return (a:s == '')? '': ' '.a:s.' '
    endif
    return ''
endfunction

function! AddHl(hl, s, padLeft = 1, padRight = 1)
    if exists('a:s')
        return (a:s == '')? '': '%#'.a:hl.'#'. (a:padLeft? ' ': '') . a:s . (a:padRight? ' ': '') . '%#StatusLine#'
    endif
endfunction

highlight StatusLineAccentBold guifg=#eeffff guibg=#515559 gui=bold
highlight StatusLineAccent guifg=#eeffff guibg=#515559
" highlight StatusLineNormal guifg=#263238 guibg=#82aaff gui=bold 
" highlight StatusLineInsert guifg=#263238 guibg=#c3e88d gui=bold 
" highlight StatusLineVisual guifg=#263238 guibg=#c792ea gui=bold 
" highlight StatusLineReplace guifg=#263238 guibg=#f07178 gui=bold 
" highlight StatusLineOther guifg=#eeffff guibg=#2e3c43 gui=bold 
" highlight StatusLine guifg=#eeffff guibg=#2e3c43
" gray1  = '#314549',
" gray2  = '#2E3C43',
" gray3  = '#515559',

" function! ModeHl()
"     let l:mode = mode()
"     if l:mode == 'n' | return '%#StatusLineNormal#' | endif
"     if l:mode == 'v' | return '%#StatusLineVisual#' | endif
"     if l:mode == 'v' | return '%#StatusLineVisual#' | endif
"     if l:mode == 'CTRL_V' | return '%#StatusLineVisual#' | endif
"     if l:mode == 's' | return '%#StatusLineVisual#' | endif
"     if l:mode == 'S' | return '%#StatusLineVisual#' | endif
"     if l:mode == 'i' | return '%#StatusLineInsert#' | endif
"     if l:mode == 'R' | return '%#StatusLineReplace#' | endif
"     if l:mode == 'c' | return '%#StatusLineOther#' | endif
"     return '%#StatusLineOther#'
" endfunction

function! Statusline()
  let hlStatusLine = '%#StatusLine#'
  " let hlMode = "%{%ModeHl()%}"
  let vcs = "%{%AddHl('StatusLineAccentBold',VcsInfoStatus(), 1, 1)%}"
  let change = "%{%AddHl('StatusLineAccent',ChangedStatus(), 0, 1)%}"
  let file = '%{AddSpace(FilenameStatus())}'
  let ft  = " %{&filetype} "
  let sep = ' %= '
  let matchup = ' %{%Matchup()%} '.hlStatusLine
  let lsp = '%{AddSpace(LspStatus())}'
  let pos = '%#StatusLineAccent# '.LineInfoStatus()
  return vcs.change.file.sep.matchup.lsp.ft.pos
endfunction

function! RefreshStatusline()
    call setwinvar(winnr(), '&statusline', Statusline())
endfunction

" vanilla statusline
set laststatus=2
let &statusline = Statusline()
" set noshowmode
" set cmdheight=0
" hi WinBarContent gui=NONE guifg=SlateBlue 
" let &winbar = '%#WinBarContent#%=%t'

