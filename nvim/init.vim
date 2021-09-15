" Constants
let s:is_windows = has('win32') || has('win64') || has('win32unix')
let s:is_nvim = has('nvim')
let s:is_gui = has("gui_running")
let s:is_fast = !s:is_windows || (s:is_windows && s:is_gui) || (s:is_windows && has('nvim'))
let g:os = substitute(system('uname'), '\n', '', '')
let s:has_node = executable('node')
let s:path = expand('<sfile>:p:h')
let s:use_coc = v:false
let mapleader = " "

" Settings
autocmd FileType jsp set nosmarttab
autocmd FileType dbout set nofoldenable
set nowrap
set number relativenumber
set title
set wildchar=<TAB>
set wildignore=*.o,*.class,*.pyc,*.swp,*.bak
set nobackup noswapfile
set copyindent
set ignorecase
set smartcase
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
if s:is_nvim && s:is_gui
    autocmd VimEnter * GuiPopupmenu 0
endif

if executable('xsel')
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
Plug 'tjdevries/colorbuddy.nvim'
Plug 'maaslalani/nordbuddy'

"start page
if s:is_fast
    Plug 'mhinz/vim-startify'
endif

" snippet
if s:is_fast
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'rafamadriz/friendly-snippets'
    " Plug 'SirVer/ultisnips'
    " Plug 'honza/vim-snippets'
endif

" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" hg
Plug 'ludovicchabant/vim-lawrencium'

"diff tools
Plug 'whiteinge/diffconflicts'

" coc
if s:use_coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
else
    Plug 'neovim/nvim-lspconfig'
    "Plug 'hrsh7th/nvim-compe'
    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-path'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'ray-x/lsp_signature.nvim'
    " Plug 'nvim-lua/lsp-status.nvim'
endif

"db 
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" editing
" Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-commentary'
" Plug 'suy/vim-context-commentstring'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
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
" Plug 'Yggdroot/indentLine'
" Plug 'lukas-reineke/indent-blankline.nvim'

" file finder
if !s:is_windows 
    if isdirectory('~/.zplugin/plugins/junegunn---fzf')
        Plug '~/.zplugin/plugins/junegunn---fzf'
    else
        Plug 'junegunn/fzf'
    endif
    Plug 'junegunn/fzf.vim'
endif

if !s:is_windows
    Plug 'kevinhwang91/nvim-bqf'
endif

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" :TSInstall bash css elm html java javascript json lua php python regex scss yaml toml tsx vue ruby rust typescript vim


Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'   
" requires make / gcc on windows
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

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
    set guifont=Hack\ NF:h11
    " set guifont=Source_Code_Pro:h10
    set linespace=1
    set t_ut=
elseif exists('g:nvy')
    set guifont=Hack\ NF:h11
elseif exists('g:fvim_loaded')
    set guifont=Hack\ NF:h13
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    FVimFontLineHeight '+1.0'
    FVimFontAutoSnap v:true
endif

"gui options
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if s:is_windows && (s:is_gui || exists('g:nvy') || exists('g:fvim_loaded'))
    " colorscheme apprentice
    colorscheme nordbuddy
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
let g:signify_priority = 5
nnoremap <leader>hu :SignifyHunkUndo<cr>
nnoremap <leader>hd :SignifyHunkDiff<cr>

" Shortcuts / mappings

" paste on visual mode without chaning original register
vnoremap p "_dP

" reselect pasted selection
nnoremap gp `[v`]

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

"quick fix
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr> 

" vim-sneak
let g:sneak#s_next = 1
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" let g:indentLine_char = '▏'

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

if s:use_coc
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

else

    "lsp config

lua << EOF
    local lspconfig = require"lspconfig"
    local lspinstall = require"lspinstall"
    lspinstall.setup()
    local lsp_signature = require"lsp_signature"
    -- local servers = require"lspinstall".installed_servers()
    -- for _, server in pairs(servers) do
    --     print(server)
    -- end
    -- print(vim.inspect(lspconfig))
    local lsp_common_opt = {
        init_options = { formatting = false },
        on_attach = function(client)
          client.resolved_capabilities.document_formatting = false
          lsp_signature.on_attach()
        end
    }
    lspconfig.typescript.setup(lsp_common_opt) 
    lspconfig.vue.setup(lsp_common_opt) 

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            underline = true,
            signs = true
        }
    )
    local eslint = {
        lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %m" },
        lintIgnoreExitCode = true,
        -- formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
        -- formatStdin = true
    }
    local prettier = {
      formatCommand = 'prettierd "${INPUT}"',
      formatStdin = true
    }
    lspconfig.efm.setup {
        init_options = { documentFormatting = true},
        filetypes = { "javascript", "vue", "html", "css" },
        settings = {
            rootMarkers = {"package.json"},
            languages = {
                javascript = { prettier, eslint },
                html = { prettier, eslint },
                vue = { prettier, eslint },
                css = { prettier,  eslint }
            }
        }
    }

EOF
    augroup FormatAutogroup
      autocmd!
      " autocmd BufWritePost *.vue,*.js,*.css,*.scss,*.html FormatWrite
      autocmd BufWritePre *.js,*.js,*.css,*.html,*.vue lua vim.lsp.buf.formatting_sync(nil, 1000)
    augroup END
    nmap <leader>cj  <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
    nmap <leader>ck  <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
    nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <leader>K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

    "nvim-compe
    set completeopt=menuone,noselect
    set shortmess+=c

lua << EOF

  local luasnip = require'luasnip'
  vim.cmd [[ imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' ]]
  luasnip.config.set_config {
     history = true,
     updateevents = "TextChanged,TextChangedI",
  }
  require('luasnip/loaders/from_vscode').load({ 
    paths = { "~/.dotfiles/nvim/snippets" } 
  })
  require("luasnip/loaders/from_vscode").load()

  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        -- vim.fn["UltiSnips#Anon"](args.body)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      -- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<M-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), 
      -- ["<Tab>"] = function(fallback)
      --    if vim.fn.pumvisible() == 1 then
      --       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
      --    elseif require("luasnip").expand_or_jumpable() then
      --       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      --    else
      --       fallback()
      --    end
      -- end,
      -- ["<S-Tab>"] = function(fallback)
      --    if vim.fn.pumvisible() == 1 then
      --       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n")
      --    elseif require("luasnip").jumpable(-1) then
      --       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      --    else
      --       fallback()
      --    end
      -- end,
    },
    sources = {
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lsp" },
        -- { name = "ultisnips" }
        { name = "luasnip" }
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          path = "[Path]",
          -- ultisnips = "[UltiSnips]"
          luasnip = "[LuaSnip]",
          -- nvim_lua = "[Lua]",
          -- latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
      end,
    },
  })
    -- require'compe'.setup {
    --   enabled = true;
    --   autocomplete = true;
    --   debug = true;
    --   min_length = 1;
    --   preselect = 'enable';
    --   throttle_time = 80;
    --   source_timeout = 200;
    --   resolve_timeout = 800;
    --   incomplete_delay = 400;
    --   max_abbr_width = 100;
    --   max_kind_width = 100;
    --   max_menu_width = 100;
    --   documentation = true;

    --   source = {
    --     path = true;
    --     buffer = true;
    --     calc = true;
    --     nvim_lsp = true;
    --     nvim_lua = true;
    --     -- vsnip = true;
    --     ultisnips = true;
    --   };
    -- }

EOF
endif

" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv 

" function! VisualSelection()
"     let old_reg     = getreg('"')
"     let old_regmode = getregtype('"')
"     normal! gvy
"     let selection = @"
"     call setreg('"', old_reg, old_regmode)
"     return selection
" endfunction

function! VisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! Escaped(text)
    call inputsave()
    let result = escape(a:text, '\\/.*$^~[]')
    let result = substitute(result, "\n$", "", "")
    let result = substitute(result, "\n", '\\n', "g")
    call inputrestore()
    return result
endfunction


autocmd FileType TelescopePrompt let b:loaded_delimitMate = 1


lua << EOF
    local actions = require('telescope.actions')
    require('telescope').setup{
      defaults = {
        layout_config = {
            prompt_position = 'top',
        },
        sorting_strategy = "ascending",
        mappings = {
            i =  {
                ["<esc>"] = actions.close
            }
        }
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        }
      }
    }
EOF

if !s:is_windows
lua << EOF
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')
EOF
endif

function! TelescopeFindFiles()
    let txt = VisualSelection()
    Telescope find_files find_command=rg,--files
    execute "normal i" . txt
endfunction

if s:is_windows
    nnoremap <leader>f :Telescope find_files find_command=rg,--files<cr>
    nnoremap <leader>rg <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Rg: "), use_regex = true })<cr>
    nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
    nnoremap <leader>r <cmd>lua require('telescope.builtin').oldfiles()<cr>
    nnoremap <expr> <leader>F ':Telescope find_files<cr>' . "'" . expand('<cword>')
    vnoremap <leader>rg :<BS><BS><BS><BS><BS>Telescope grep_string use_regex=true search=<c-r>=VisualSelection()<cr><cr>
    vnoremap <leader>F :<BS><BS><BS><BS><BS>:call TelescopeFindFiles()<cr>
else
    nnoremap <leader>sf :Telescope find_files find_command=rg,--files<cr>
    nnoremap <leader>srg <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Rg: "), use_regex = true })<cr>
    nnoremap <leader>sb <cmd>lua require('telescope.builtin').buffers()<cr>
    nnoremap <leader>sr <cmd>lua require('telescope.builtin').oldfiles()<cr>
    nnoremap <expr> <leader>sF ':Telescope find_files<cr>' . "'" . expand('<cword>')
    vnoremap <leader>srg :<BS><BS><BS><BS><BS>Telescope grep_string use_regex=true search=<c-r>=VisualSelection()<cr><cr>
    vnoremap <leader>sF :<BS><BS><BS><BS><BS>:call TelescopeFindFiles()<cr>
endif

" fzf

if !s:is_windows 
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

xnoremap <leader>pt :!npx -q prettierd --stdin-filepath=%:p
xnoremap <leader>pjs :!npx -q prettierd --stdin-filepath=%:p --parser=babel --trailing-comma=none --tab-width=4
xnoremap <leader>psql :!npx -q sql-formatter-cli

xnoremap <leader>sc :!tw2s<cr>

" vim-vue
au BufNewFile,BufRead *.vue setlocal filetype=vue
autocmd FileType vue syntax sync fromstart
let g:vue_disable_pre_processors=1

" vim-json
let g:vim_json_syntax_conceal = 0


" ultisnips
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsExpandTrigger="<tab>"

" tmux
let g:tmux_navigator_disable_when_zoomed = 1

" yoink
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
nnoremap <F5> :UndotreeToggle<cr>

" vim-barbaric
let g:barbaric_ime = 'fcitx'
let g:barbaric_fcitx_cmd = 'fcitx-remote'

"dadbod-ui
let g:db_ui_debug = 1
let g:db_ui_save_location = '~/.config/db_ui'

"treesitter
" :TSInstall bash css elm html java javascript json lua php python regex scss yaml toml tsx vue ruby rust typescript

"commentstring
lua << EOF
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true
  }
}
EOF


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
        local errorCount = vim.lsp.diagnostic.get_count(0, [[Error]])
        if errorCount > 0 then
            s = s .. "E" .. errorCount
        end
        local warningCount = vim.lsp.diagnostic.get_count(0, [[Warning]]);
        if warningCount > 0 then
            s = s .. "W" .. warningCount
        end
        return s
    end
    return ""
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
  let ft  = "%{&filetype} "
  let sep = ' %= '
  if s:use_coc
    let lsp = '%{AddSpace(CocStatus())}'
  else
    let lsp = '%{AddSpace(LspStatus())}'
  endif
  
  " let ale = '%{AddSpace(ALELinterStatus())}'
  let ale = ''
  let pos = LineInfoStatus()
  " let dir = '%20.30{CurDir()} '
  return vcs.file.sep.lsp.ale.ft.pos
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
