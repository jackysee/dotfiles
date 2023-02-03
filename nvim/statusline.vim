
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
    return FugitiveStatus(). LawrenciumStatus(). ChangedStatus()
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
    local lsp = vim.lsp.util.get_progress_messages()[1]
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
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
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
    return '%P %-8(%3l:%c%)'
endfunction

function! AddBracket(s)
    if exists('a:s')
        return (a:s == '')? '': ' ['.a:s.'] '
    endif
    return ''
endfunction

function! AddSpace(s)
    if exists('a:s')
        return (a:s == '')? '': ' '.a:s.' '
    endif
    return ''
endfunction

function! Statusline()
  let vcs = "%{AddBracket(VcsInfoStatus())}"
  let file = '%{FilenameStatus()}'
  let ft  = "%{&filetype} "
  let sep = ' %= '
 let lsp = '%{AddSpace(LspStatus())}'
  
  let pos = LineInfoStatus()
  return vcs.file.sep.lsp.ft.pos
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

