" Constants
let s:is_windows = has('win32') || has('win64') || has('win32unix')
let s:is_gui = has("gui_running")
let s:is_fast = !s:is_windows || (s:is_windows && s:is_gui) || (s:is_windows && has('nvim'))
let g:os = substitute(system('uname'), '\n', '', '')
let s:has_node = executable('node')
let s:path = expand('<sfile>:p:h')
let mapleader = " "

" Settings
autocmd FileType jsp set nosmarttab
set nowrap
set number relativenumber
set title
set wildchar=<TAB>
set wildignore=*.o,*.class,*.pyc,*.swp,*.bak
set nobackup noswapfile
set copyindent
set ignorecase
set smartcase
if g:os == "Linux"
    let g:clipboard = {
        \   'name': 'xsel_override',
        \   'copy': {
        \      '+': 'xsel --input --clipboard',
        \      '*': 'xsel --input --primary',
        \    },
        \   'paste': {
        \      '+': 'xsel --output --clipboard',
        \      '*': 'xsel --output --primary',
        \   },
        \   'cache_enabled': 1,
        \ }
endif
set clipboard+=unnamedplus
set splitbelow splitright
set hidden
set mouse=a
set scrolloff=1
set sidescrolloff=5
set display+=lastline
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

set lazyredraw

nnoremap <silent> <leader>/ :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

set list listchars=tab:»-,trail:.,extends:>,precedes:<,nbsp:+

set undofile
let &undodir= s:path . '/undo'

" set block cursor
if $TERM == "xterm" || $TERM == "xterm-256color" || $TERM == "screen-256color"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

if !s:is_windows && empty(glob(s:path . '/autoload/plug.vim'))
    silent exe '!curl -fLo '.s:path.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins
packadd cfilter
call plug#begin(s:path . '/plugged')

" colorscheme
Plug 'romainl/Apprentice'
Plug 'junegunn/seoul256.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
" Plug 'rktjmp/lush.nvim'
" Plug 'npxbr/gruvbox.nvim'
Plug 'habamax/vim-gruvbit'

"start page
if s:is_fast
    Plug 'mhinz/vim-startify'
endif

" snippet
if s:is_fast
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif

" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" hg
Plug 'ludovicchabant/vim-lawrencium'

"diff tools
Plug 'whiteinge/diffconflicts'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"db 
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" editing
" Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring'
" Plug 'Shougo/context_filetype.vim'
" Plug 'tyru/caw.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'Raimondi/delimitMate'
Plug 'chiedojohn/vim-case-convert'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'pbrisbin/vim-mkdir'
Plug 'svermeulen/vim-yoink'
Plug 'haya14busa/vim-asterisk'
Plug 'markonm/traces.vim'
Plug 'mbbill/undotree'
Plug 'rlue/vim-barbaric'
Plug 'junegunn/vim-peekaboo'


" file finder
if s:is_windows 
    Plug 'Yggdroot/LeaderF', { 'do': './install.bat' }
else
    if isdirectory('~/.zplugin/plugins/junegunn---fzf')
        Plug '~/.zplugin/plugins/junegunn---fzf'
    else
        Plug 'junegunn/fzf'
    endif
    Plug 'junegunn/fzf.vim'
endif

Plug 'ap/vim-css-color'

" js / vue
if s:is_fast
    " Plug 'w0rp/ale', { 'for': ['javascript', 'vue', 'javascript.jsx', 'css', 'scss', 'html', 'json' ]}
    Plug 'mattn/emmet-vim',  { 'for':['javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' ]}
    Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html', 'vue'] }
    Plug 'elzr/vim-json', { 'for': ['json']}
    Plug 'posva/vim-vue', { 'for': ['vue']}
    " Plug 'sgur/vim-editorconfig'
    Plug '1995eaton/vim-better-javascript-completion',  { 'for': [ 'javascript', 'vue' ]}
endif

" elm
Plug 'elmcast/elm-vim', { 'for': ['elm']}

call plug#end()

" auto reload vimrc when editing it
autocmd! bufwritepost init.vim source $MYVIMRC

" GUI
if s:is_gui && s:is_windows
    au GUIEnter * simalt ~x
    " set guifont=Anonymous_Pro:h11
    " set guifont=Fira_Code_Medium:h10
    set guifont=Source_Code_Pro:h10
    set linespace=1
    set t_ut=
endif

"gui options
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if s:is_windows && s:is_gui
    colorscheme apprentice
    " colorscheme gruvbit
else
    
    let g:gruvbox_invert_selection = '0'
    set background=dark
    colorscheme gruvbox

    " let g:gruvbox_invert_selection = '0'
    " let g:gruvbox_material_background = 'hard'
    " set background=dark
    " colorscheme gruvbox-material

    " colorscheme apprentice
    
    " colorscheme gruvbit

    " let g:seoul256_background = 233
    " set background=dark
    " colorscheme seoul256

endif

highlight NonText guifg=#444444 guibg=NONE gui=NONE cterm=NONE
highlight SpecialKey guifg=#444444 guibg=NONE gui=NONE cterm=NONE


if s:is_fast
    set cursorline
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
endif

" disable sound on errors
set noerrorbells
set novisualbell

" TAB setting{
    set expandtab        "replace <TAB> with spaces
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
"}

set path=.,src/main/java,src/main/test,src/frontend/src,frontend/src
set includeexpr=substitute(v:fname,'/','src/frontend/src/','')
set suffixesadd=.js,.vue,.scss

autocmd BufEnter *.jsp set ft=html.jsp

"startify
" let g:startify_custom_header = ['']
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
            \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
            \ { 'header': ['   MRU'],            'type': 'files' },
            \ { 'header': ['   Sessions'],       'type': 'sessions' }
            \ ]

" hg/git gutter
let g:signify_realtime = 0
let g:signify_sign_change = '~'
let g:signify_update_on_focusgained = 1

" Shortcuts / mappings

" paste on visual mode without chaning original register
vnoremap p "_dP

"; :
nnoremap ; :
nnoremap > ;
nnoremap < ,

" beginning / end of line
nnoremap <leader>h ^
nnoremap <leader>l $

" indent in visual model
vnoremap < <gv
vnoremap > >gv

" Encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

" open file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" edit vimrc
execute 'nnoremap <silent> <leader>vv :vsp '.s:path.'/init.vim<CR>'


"jump between split
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" vim-sneak
let g:sneak#s_next = 1
let g:sneak#label = 1

" netw
let g:netrw_browse_split=2
" let g:netrw_banner=0
" let g:netrw_winresize=10
nnoremap <leader>pv :wincmd v <bar>  :wincmd h <bar> :Ex <bar> :vertical resize 35<CR>

"textobj for bracket function like block (linewise) 
xnoremap <silent> af :<c-u>normal! g_v%V<cr>
onoremap <silent> af :<c-u>normal! g_v%V<cr>

" vimdiff
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffput<CR>

" ~/.vim/plugin/win_resize.vim
nnoremap <leader>w :WinResize<CR>

" sudo tee save with w!!
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

" Profile Vim by running this command once to start it and again to stop it.
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction

command! -bang Profile call s:profile(<bang>0)

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

function! Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
endfunction

" emmet
imap <C-E> <C-y>,

" Add semi colon at end of line
noremap <leader>; g_a;<Esc>

" vim-asterisk
nnoremap n nzz
nnoremap N Nzz
map *  <Plug>(asterisk-z*)
map g* <Plug>(asterisk-zg*)
map #  <Plug>(asterisk-z#)
map g# <Plug>(asterisk-zg#)

" coc
let g:coc_global_extensions = [
            \   'coc-css',
            \   'coc-html',
            \   'coc-json',
            \   'coc-emmet',
            \   'coc-ultisnips',
            \   'coc-prettier',
            \   'coc-eslint'
            \ ]
            "\   'coc-pairs',
set updatetime=300
set shortmess+=c
set signcolumn=yes
" remap goto
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gt <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
" Remap for do codeAction of current line
nmap <leader>ca  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>cf  <Plug>(coc-fix-current)
nmap <leader>cj  <Plug>(coc-diagnostic-next-error)
nmap <leader>ck  <Plug>(coc-diagnostic-prev-error)

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <leader>cd :call <SID>show_documentation()<CR>
nnoremap <leader>cs :call CocActionAsync('showSignatureHelp')<CR>

" manual trigger LSP completion
inoremap <silent><expr> <c-j> coc#refresh()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

fun! EnableCocJava()
    call coc#config('java.enabled', v:true)
    call CocAction('reloadExtension', 'coc-java')
endfun
command! EnableCocJava call EnableCocJava()

augroup coc 
    autocmd!
    " update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " autocmd User CocStatusChange call RefreshStatusline()
augroup end


" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv 

function! VisualSelection()
    let old_reg     = getreg('"')
    let old_regmode = getregtype('"')
    normal! gvy
    let selection = @"
    call setreg('"', old_reg, old_regmode)
    return selection
endfunction

function! Escaped(text)
    call inputsave()
    let result = escape(a:text, '\\/.*$^~[]')
    let result = substitute(result, "\n$", "", "")
    let result = substitute(result, "\n", '\\n', "g")
    call inputrestore()
    return result
endfunction

" leaderF
if s:is_windows
    nnoremap <leader>f :LeaderfFile<CR>
    nnoremap <leader>r :LeaderfMru<CR>
    nnoremap <leader>rg :Leaderf rg -e<Space>
    let g:Lf_WindowHeight = 0.90
    let g:Lf_MruFileExclude = ['*.so', '*.tmp', '*.bak', '*.exe', '*.dll']
    let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
    let g:Lf_CommandMap = { '<C-]>': ['<C-V>'], '<C-J>':['<C-N>'], '<C-K>':['<C-P>'] }
    let g:Lf_WindowPosition = 'popup'
else
    " fzf
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction
    let $FZF_DEFAULT_OPTS = ' --reverse'
    if (v:version >= 802 && has('patch194')) || has('nvim')
        let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
    else
        let g:fzf_layout = { 'down': '~30%' }
    endif
    let g:fzf_colors =
                \ { 'fg': ['fg', 'Normal'],
                \ 'bg': ['bg', 'Normal']}
    let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit'
        \ }
    nnoremap <leader>f :Files<cr>
    command! -bang -nargs=? -complete=dir FilesSearch
                \ call fzf#vim#files('', 
                \   fzf#vim#with_preview({'options':['--query='.<q-args>]}), <bang>0)
    nnoremap <leader>F :FilesSearch '<c-r><c-w><cr>
    vnoremap <leader>F :<BS><BS><BS><BS><BS>FilesSearch '<c-r>=VisualSelection()<cr><cr>
    nnoremap <leader>r :History<cr>
    nnoremap <leader>b :Buffers<cr>
    nnoremap <leader>ag :Ag <c-r><c-w><cr>
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   "rg --column --line-number --no-heading --color=always --smart-case --trim -- ".shellescape(<q-args>), 1,
      \   fzf#vim#with_preview('right', 'ctrl-/'), <bang>0)
    nnoremap <leader>rg :Rg <c-r><c-w><cr>
    vnoremap <leader>rg :<BS><BS><BS><BS><BS>Rg <c-r>=VisualSelection()<cr><cr>
endif

xnoremap <leader>pt :!npx -q prettier --stdin-filepath=%:p
xnoremap <leader>pjs :!npx -q prettier --stdin-filepath=%:p --parser=babel --trailing-comma=none --tab-width=4
xnoremap <leader>psql :!npx -q sql-formatter-cli

xnoremap <leader>sc :!tw2s<cr>

" vim-vue
au BufNewFile,BufRead *.vue setlocal filetype=vue
autocmd FileType vue syntax sync fromstart
let g:vue_disable_pre_processors=1

" vim-json
let g:vim_json_syntax_conceal = 0


" ultisnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<tab>"

" tmux
let g:tmux_navigator_disable_when_zoomed = 1

" yoink
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" vim-over
" nnoremap <leader>s :OverCommandLine<cr>%s/
" xnoremap <leader>s :OverCommandLine<cr>s/

" undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
nnoremap <F5> :UndotreeToggle<cr>

" vim-barbaric
" let g:barbaric_ime = 'fcitx'
let g:barbaric_fcitx_cmd = 'fcitx-remote'

"dadbod-ui
let g:db_ui_debug = 1
let g:db_ui_save_location = '~/.config/db_ui'

" statusline {{

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction


function! FugitiveStatus() abort
    if !exists('g:loaded_fugitive')
        return ''
    endif
    let l:status = fugitive#head()
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

function! CocCurrentFunction() abort
    return get(b:, 'coc_current_function', '')
endfunction

function! CocLineStatus() abort
  if s:is_tmp_file()
      return ''
  endif
  if exists('g:coc_status') && get(g:, 'coc_enabled', 0)
      return g:coc_status
  endif
  return ''
endfunction

function! CocDignostic() abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
        call add(msgs, 'E' . info['error'])
    endif
    if get(info, 'warning', 0)
        call add(msgs, 'W' . info['warning'])
    endif
    return join(msgs, ' ')
endfunction

function! CocStatus() abort
    let s1 = CocCurrentFunction()
    let s3 = CocDignostic()
    let s2 = CocLineStatus()
    return join([s1, s3, s2], ' ')
endfunction


function! ModifiedStatus()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! ReadonlyStatus()
    return &ft !~? 'help' && &readonly ? '!' : ''
endfunction

function! FilenameStatus()
    return ReadonlyStatus() .
            \ ('' != expand('%:t') ? expand('%:p:.') : '[No Name]') .
            \ ('' != ModifiedStatus() ? ModifiedStatus() : '')
endfunction

function! LineInfoStatus()
    return '%-10(%3l:%c%)%P'
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
  let ft  = "%{&filetype}"
  let sep = ' %= '
  let coc = '%{AddSpace(CocStatus())}'
  " let ale = '%{AddSpace(ALELinterStatus())}'
  let ale = ''
  let pos = LineInfoStatus()
  " let dir = '%20.30{CurDir()} '
  return vcs.file.sep.coc.ale.ft.pos
endfunction

function! RefreshStatusline()
    call setwinvar(winnr(), '&statusline', Statusline())
endfunction

" vanilla statusline
" set noshowmode
set laststatus=2
let &statusline = Statusline()
"

" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
