" Constants
let s:path = expand('<sfile>:p:h')
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
set mouse=a
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set lazyredraw
set timeoutlen=300
" autocmd FileType * setlocal fo-=c fo-=r fo-=o
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" if executable('xsel')
"     let g:clipboard = {
"           \   'name': 'xsel_override',
"           \   'copy': {
"           \      '+': 'xsel --input --clipboard',
"           \      '*': 'xsel --input --primary',
"           \    },
"           \   'paste': {
"           \      '+': 'xsel --output --clipboard',
"           \      '*': 'xsel --output --primary',
"           \   },
"           \   'cache_enabled': 1,
"           \ }
" endif
"
" if executable('/mnt/c/windows/system32/clip.exe')
"     let g:clipboard = {
"         \   'name': 'WslClipboard',
"         \   'copy': {
"         \      '+': '/mnt/c/Windows/System32/clip.exe',
"         \      '*': '/mnt/c/Windows/System32/clip.exe',
"         \    },
"         \   'paste': {
"         \      '+': '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -noprofile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"         \      '*': '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -noprofile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"         \   },
"         \   'cache_enabled': 0,
"         \ }
" endif

set list listchars=tab:»\ ,trail:.,extends:>,precedes:<,nbsp:+

set undofile
let &undodir= s:path . '/undo'

" auto reload vimrc when editing it
" autocmd! bufwritepost init.vim source $MYVIMRC

highlight NonText guifg=#444444 guibg=NONE gui=NONE cterm=NONE
highlight SpecialKey guifg=#444444 guibg=NONE gui=NONE cterm=NONE

set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" TAB setting
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set path=.,src/main/java,src/main/test,src/frontend/src,frontend/src
set includeexpr=substitute(v:fname,'/','src/frontend/src/','')
set suffixesadd=.js,.vue,.scss

autocmd BufEnter *.jsp set ft=html.jsp

let g:vimsyn_embed = 'l'

" Encoding
set encoding=utf-8
" set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

" Shortcuts / mappings

nnoremap <silent> <leader>/ :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
nnoremap <leader><leader> <c-^>

" paste on visual mode without chaning original register
vnoremap <leader>p "_dP
xnoremap <leader>p "_dP
vnoremap <leader>d "_d
nnoremap <leader>d "_d

" reselect pasted selection
nnoremap gy `[v`]

"; :
nnoremap ; :
nnoremap > ;
nnoremap < ,

" indent in visual model
vnoremap < <gv
vnoremap > >gv

" open file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" edit vimrc
execute 'nnoremap <silent> <leader>vv :vsp '.s:path.'/init.vim<CR>'

"quick fix
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>

" netw
let g:netrw_browse_split=2
" nnoremap <leader>pv :wincmd v <bar>  :wincmd h <bar> :Ex <bar> :vertical resize 35<CR>

"textobj for bracket function like block (linewise)
xnoremap <silent> af :<c-u>normal! g_v%V<cr>
onoremap <silent> af :<c-u>normal! g_v%V<cr>

" vimdiff
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffput<CR>

" sudo tee save with w!!
" cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
cnoreabbrev w!! SudaWrite

" Add semi colon at end of line
noremap <leader>; m`A;<Esc>``
noremap <leader>, m`A,<Esc>``

" new line
noremap <leader>o o<Esc>k
noremap <leader>O O<Esc>j

" vim-asterisk-like behavior
nnoremap n nzz
nnoremap N Nzz
nnoremap * *N
nnoremap # #N


"lsp
nmap <leader>ck  <cmd>lua vim.diagnostic.goto_prev()<cr>
nmap <leader>cj  <cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <leader>gs <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <c-s> <cmd>lua vim.lsp.buf.signature_help()<CR>
set completeopt=menuone,noselect
set shortmess+=c


" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

function! VisualSelection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)         
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

command! -range Prettier '<,'>!npx -q prettierd %:p
command! -range PrettierJs '<,'>!npx -q prettierd %:p --parser=babel --trailing-comma=none --tab-width=2
command! -range SqlFormat '<,'>!npx -q sql-formatter-cli
command! -range Tw2s '<,'>!tw2s

" ~/.vim/plugin/win_resize.vim
nnoremap <leader>w :WinResize<CR>

" vue3_emits
"
function! Vue_Refactoring()
    lua require('vue_3_refactoring').setup()
    nnoremap <leader>vem A,<CR><C-O><Plug>VueEmit<cr><esc>==
    vnoremap <leader>vmv <Plug>VueModelValue
    nnoremap <leader>vcp <Plug>VueComputed
    nnoremap <leader>vmt <Plug>VueMethod
    nnoremap <leader>vpr <Plug>VueProps
    nnoremap <leader>vrf <Plug>VueRef
    nnoremap <leader>vmd <Plug>VueVModel
    nnoremap <leader>vdp <Plug>VueDeep
    nnoremap <leader>vdd <Plug>VueDeep2
    nnoremap <leader>vsl <Plug>VueSlot
    nnoremap <leader>vso <Plug>VueSlot2
endfunction
autocmd FileType vue call Vue_Refactoring()
autocmd FileType css call Vue_Refactoring()

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter,CmdlineLeave * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave,CmdlineEnter *   if &nu                  | set nornu | redraw | endif
augroup END

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

function! Scratch()
    let scr_winnr = bufwinnr('scratch')
    if winnr() == scr_winnr
        return
    endif
    let bnr = bufexists('scratch')
    if bnr > 0
        split scratch
    else
        split
        noswapfile hide enew
        setlocal buftype=nofile bufhidden=hide nobuflisted
        "lcd ~
        file scratch
    endif
endfunction
nnoremap <leader>j :call Scratch()<cr>

function! CopyMatches(reg)
    let hits = []
    %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

augroup auto_create_dir
    autocmd!
    autocmd BufWritePre * call mkdir(expand('%:p:h'), 'p')
augroup END

".test.js filetype
au BufRead,BufNewFile *.test.js  setlocal filetype=javascript.jest
au BufRead,BufNewFile *.spec.js  setlocal filetype=javascript.jest

" autocmd User VeryLazy execute 'source ' . s:path  . '/statusline.vim'
" autocmd User VeryLazy execute 'lua require("statusline").setup()'
lua require("statusline").setup()


" plugins managed by lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
    vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

local spec = {
    { import = "config.plugins" },
    -- {
    --     'mhinz/vim-startify',
    --     event = 'VimEnter',
    --     config = function()
    --         vim.g.startify_change_to_dir = 0
    --         vim.g.startify_change_to_vcs_root = 1
    --         vim.g.startify_lists = {
    --             {  header = { '   MRU '..vim.fn.getcwd() }, type = 'dir' },
    --             {  header = { '   MRU' }, type = 'files' },
    --             {  header = { '   Sessions' }, type = 'sessions' }
    --         }
    --     end
    -- },
    {
        'goolord/alpha-nvim',
        event = 'VimEnter',
        config = function()
            local section = require('alpha.themes.startify').section
            section.header.val = require('util').cowsay(require('alpha.fortune')())
            require('alpha').setup(require('alpha.themes.startify').config)
        end
    },
    {
        'mbbill/undotree',
        event = 'BufReadPre',
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.keymap.set('n', '<F5>', ':UndotreeToggle<cr>')
        end
    },
    { 'lambdalisue/suda.vim', event = 'BufReadPre' },
    -- vcs
    { 'tpope/vim-fugitive', event = 'BufReadPre' },
    {
        'mhinz/vim-signify',
        event = 'BufReadPre',
        config = function()
            vim.g.signify_realtime = 0
            vim.g.signify_sign_change = '~'
            vim.g.signify_update_on_focusgained = 1
            vim.g.signify_priority = 5
            vim.keymap.set('n', '<leader>hu', ':SignifyHunkUndo<cr>')
            vim.keymap.set('n', '<leader>hd', ':SignifyHunkDiff<cr>')
        end
    },
    { 'ludovicchabant/vim-lawrencium', event = 'BufReadPre' },

    { 'whiteinge/diffconflicts', event = 'BufWinEnter' },
    {
        'gbprod/yanky.nvim',
        event = 'BufReadPost',
        keys = {
            {'p', '<Plug>(YankyPutAfter)', mode = {'n', 'x'}},
            {'P', '<Plug>(YankyPutBefore)', mode = {'n', 'x'}},
            {'gp', '<Plug>(YankyGPutAfter)', mode = {'n', 'x'}},
            {'gP', '<Plug>(YankyGPutBefore)', mode = {'n', 'x'}},
            {'<c-n>', '<Plug>(YankyCycleForward)'},
            {'<c-p>', '<Plug>(YankyCycleBackward)'}
        },
        config = true
    },
    { 'tpope/vim-repeat', event='BufReadPost' },
    {
        'tpope/vim-surround',
        event = 'BufReadPost',
        init = function() 
            vim.g.surround_no_mappings = 1
        end,
        keys = {
            {'ds', '<Plug>Dsurround'},
            {'cs', '<Plug>Csurround'},
            {'cS', '<Plug>CSurround'},
            {'ys', '<Plug>Ysurround'},
            {'yS', '<Plug>YSurround'},
            {'yss', '<Plug>Yssurround'},
            {'ySs', '<Plug>YSsurround'},
            {'ySS', '<Plug>YSsurround'},
            {'gs', '<Plug>VSurround', mode = "x" },
            {'gS', '<Plug>VgSurround', mode = "x" }
        }
    },
    { 'tpope/vim-eunuch', event = 'CmdlineEnter' },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = { search = { enabled = true }}
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        cmd = "Trouble"
    },

    -- { 'b0o/SchemaStore.nvim', lazy = true },
    -- { 'nvim-tree/nvim-web-devicons' },

    {
        'kristijanhusak/vim-dadbod-ui',
        cmd = 'DBUI',
        dependencies = { 
            { 'tpope/vim-dadbod', lazy = true },
            {
                'kristijanhusak/vim-dadbod-completion',
                ft = { 'sql', 'mysql', 'plsql'},
                lazy = true 
            } 
        },
        config = function()
            vim.g.db_ui_debug = 1
            vim.g.db_ui_save_location = '~/.config/db_ui'
            vim.g.db_ui_use_nerd_fonts = 1
        end
    },
    -- { 'tpope/vim-commentary', event='BufReadPost' },
    { 
        'numToStr/Comment.nvim', 
        -- dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        opts = {}
    },

    { 'windwp/nvim-autopairs', event='InsertEnter', config = true },
    -- { 'Raimondi/delimitMate', event = 'InsertCharPre' },
    {
        'andymass/vim-matchup',
        event = 'BufReadPost',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
        end
    },
    { 'arthurxavierx/vim-caser', event = 'BufReadPost' },
    { 'christoomey/vim-tmux-navigator', event = 'BufReadPost' },
    {
        'tmux-plugins/vim-tmux-focus-events',
        event = 'BufReadPost',
        config = function()
            vim.g.tmux_navigator_disable_when_zoomed = 1
        end
    },
    {
        'wellle/targets.vim', event='BufReadPost',
        config = function()
            vim.api.nvim_create_autocmd('User' , {
              -- group = 'mappings_control',
              pattern = 'targets#mappings#user',
              callback = function()
                vim.cmd [[
                  call targets#mappings#extend({
                    \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]},
                    \ })
                ]]
              end,
            })
        end
    },
    -- { 'terryma/vim-expand-region' },
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { 'stevearc/quicker.nvim', event = 'FileType qf', opts = {} },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufReadPre',
        config = function()
            require('nvim-treesitter.configs').setup({
                -- context_commentstring = { enable = true, enable_autocmd = false },
                -- context_commentstring = { enable = true },
                highlight = { enable = true },
                indent = { enable = true },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { 'BufWrite', 'CursorHold' }
                },
                matchup = { enable = true },
                ensure_installed = { 'css', 'html', 'javascript', 'json', 'lua', 'python', 'regex', 'scss', 'vue', 'ruby', 'vim', 'vimdoc', 'typescript', 'bash', 'jsp'}
            })
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.jsp = {
                install_info = {
                    url = "https://github.com/merico-dev/tree-sitter-jsp.git", -- local path or git repo
                    files = { "src/parser.c", "src/scanner.cc" },
                },
            }
        end
        -- " :TSInstall bash css elm html java javascript json lua php python regex scss yaml toml tsx vue ruby rust typescript vim
    },
    {
        'NvChad/nvim-colorizer.lua',
        event = 'BufReadPre',
        opts = {
            filetypes = { '*', '!lazy' },
            buftype = { '*', '!prompt', '!nofile' },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- 'Name' codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes: foreground, background
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = 'background', -- Set the display mode.
                virtualtext = '■',
            },
        }
    },
    -- { 'leafOfTree/vim-vue-plugin', ft = { 'vue' } },
    { 
        'mattn/emmet-vim' , 
        ft = {'javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' },
        init = function()
            vim.g.user_emmet_leader_key = '<C-I>'
        end
    },
    { 'elmcast/elm-vim', ft = 'elm' },
    { 'alunny/pegjs-vim', ft= 'pegjs' },
    { 
        'folke/which-key.nvim', 
        event = 'VeryLazy',
        config = function()
            local presets = require("which-key.plugins.presets")
            presets.operators["v"] = nil
            presets.operators["d"] = nil
            presets.operators["c"] = nil
            require('which-key').setup({
                preset = "helix",
                plugins = {
                    presets = {
                        operators = false,
                        motions = false,
                        text_objects = false,
                        windows = false
                    }
                }
               -- triggers_blacklist = { c = {"w", "%"} }
            })
        end
    },
    { 
        'folke/persistence.nvim',  
        event = 'VimEnter', 
        config = function()
            local l = require('persistence');
            l.setup()
            vim.keymap.set('n', '<leader>qs', function() l.load() end, { desc = 'restore session for cwd' } )
            vim.keymap.set('n', '<leader>ql', function() l.load({ last = true }) end, { desc = 'restore last session' } )
            vim.keymap.set('n', '<leader>qd', function() l.stop({ last = true }) end, { desc = 'stop persist session' } )
        end
    },
    {
        'stevearc/oil.nvim',
        opts = {
            view_options = {
                show_hidden = true
            }
        },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
        config = function()
            require('oil').setup()
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
    },
    {
        "roobert/search-replace.nvim",
        config = function()
            require("search-replace").setup()
            local opts = {}
            vim.keymap.set("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
            vim.keymap.set("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
            vim.keymap.set("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

            vim.keymap.set("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
            vim.keymap.set("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
            vim.keymap.set("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
            vim.keymap.set("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
            vim.keymap.set("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
            vim.keymap.set("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

            vim.keymap.set("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
            vim.keymap.set("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
            vim.keymap.set("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
            vim.keymap.set("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
            vim.keymap.set("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
            vim.keymap.set("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)

            -- show the effects of a search / replace in a live preview window
            -- vim.o.inccommand = "split"
        end
    },
    {
        'folke/snacks.nvim',
        opts = { 
            bigfile = {},
            -- indent = {},
        }
    }
    -- {
    --     "keaising/im-select.nvim",
    --     config = function()
    --         require("im_select").setup({
    --             keep_quiet_on_no_binary = true,
    --             async_switch_im = true
    --         })
    --     end
    -- }
}

require('lazy').setup({
    spec = spec,
    rtp = { disabled_plugins = {'matchit', 'matchparen'} },
    install = { colorscheme = {"codeschool"} }
})

EOF
