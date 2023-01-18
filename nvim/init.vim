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
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
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

set list listchars=tab:»-,trail:.,extends:>,precedes:<,nbsp:+

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
set termencoding=utf-8
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
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Add semi colon at end of line
noremap <leader>; g_a;<Esc>

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
    nnoremap <leader>vva <Plug>VueDotValue 
endfunction
autocmd FileType vue call Vue_Refactoring()

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

autocmd User VeryLazy execute 'source ' . s:path  . '/statusline.vim'

" plugins managed by lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
    vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

local fzf_spec = function()
    if vim.fn.isdirectory(vim.env.HOME .. '/.zplugin/plugins/junegunn---fzf') then
        return {
            name = 'junegunn/fzf',
            dir = '~/.zplugin/plugins/junegunn---fzf',
            event = 'BufWinEnter'
        }
    else
        return { 'junegunn/fzf', event = 'BufWinEnter' }
    end
end

local colorscheme = function(repo, scheme, load)
    local event = 'VeryLazy'
    if load == true then event = nil end
    return {
        repo,
        event = event,
        config = function()
            if load then
                vim.cmd('colorscheme '..scheme)
                vim.cmd('set termguicolors')
            end
        end
    }
end

local spec = {
    colorscheme('romainl/Apprentice', 'Apprentice'),
    colorscheme('haishanh/night-owl.vim', 'night-owl'),
    colorscheme('folke/tokyonight.nvim', 'tokyonight'),
    colorscheme('EdenEast/nightfox.nvim', 'nightfox', true),
    colorscheme('whatyouhide/vim-gotham', 'gotham'),
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

    { 'whiteinge/diffconflicts', event = 'BufReadPre' },
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
    { 'elihunter173/dirbuf.nvim', event = 'CmdlineEnter' },
    {
        'ggandor/leap.nvim',
        event='BufReadPost',
        config = function()
            require('leap').set_default_keymaps()
        end
    },
    {
        'ggandor/flit.nvim',
        event='BufReadPost',
        dependencies = { 'ggandor/leap.nvim' },
        config = true
    },
    {
        'ggandor/leap-spooky.nvim',
        event='BufReadPost',
        dependencies = { 'ggandor/leap.nvim' },
        config = true
    },
    fzf_spec(),
    {
        'ibhagwan/fzf-lua',
        event = 'BufWinEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'junegunn/fzf' },
        config = function()
            vim.env.FZF_DEFAULT_OPTS = ' --reverse' 
            local f = require('fzf-lua');
            local files = function(txt)
                f.files({ fzf_opts = { ['--query'] = vim.fn.shellescape(txt) } })
            end
            f.setup({
                winopts = { height=0.9, width=0.9 },
                files = { actions = { ['ctrl-x'] = f.actions.file_split } }
            })
            vim.keymap.set('n', '<leader>f', f.files, { silent = true, desc = 'fzf files' })
            vim.keymap.set('n', '<leader>F', function() files("'"..vim.fn.expand('<cword>')) end, { silent = true, desc = 'exact file match <cword>'});
            vim.keymap.set('v', '<leader>F', function() files("'"..f.utils.get_visual_selection()) end, { silent = true, desc = 'exact file match selection' });
            vim.keymap.set('n', '<leader>b', f.buffers, { silent = true, desc = 'buffers' })
            vim.keymap.set('n', '<leader>o', f.oldfiles, { silent = true, desc = 'oldfiles' })
            vim.keymap.set('n', '<leader>rg', f.grep_cword, { silent = true, desc = 'rg <cword>' })
            vim.keymap.set('v', '<leader>rg', f.grep_visual, { silent = true, desc = 'rg selection' })
            vim.keymap.set('n', '<leader>z', ':FzfLua ', { desc = 'cmd :FzfLua '});
            vim.api.nvim_create_user_command('Rg', function(opts) f.grep_project({ search = opts.args }) end, { nargs = '*'})
            vim.keymap.set('n', '<leader>y', function() require('fzf_util').yanky() end, { silent = true, desc = 'yank ring history' })
            vim.keymap.set('n', '<leader>s', function() require('fzf_util').persistence_session() end, { silent = true, desc = 'sessions' })
        end
    },
    -- { 'nvim-lua/plenary.nvim' },
    require('null_ls_spec'),
    -- { 'rafamadriz/friendly-snippets', event = 'InsertCharPre' },
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        event = 'InsertCharPre',
        config = function()
            local luasnip = require('luasnip')
            vim.cmd [[ imap <silent><expr> <C-e> luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '' ]]
            vim.cmd [[ imap <silent><expr> <C-j> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Plug>luasnip-expand-or-jump' ]]
            vim.cmd [[ imap <silent><expr> <C-k> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-k>' ]]

            luasnip.config.set_config {
                history = true,
                -- updateevents = 'TextChanged,TextChangedI',
                store_selection_keys = '<Tab>'
            }
            require('luasnip/loaders/from_vscode').lazy_load();
            require('luasnip/loaders/from_vscode').lazy_load({ paths = { './snippets' } });
            -- require('./snippets/javascript');
            luasnip.filetype_extend('vue', {'html', 'javascript', 'css'})
            luasnip.filetype_extend('typescript', { 'javascript'})
        end
    },


    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path'
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require'luasnip'.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-e>'] = cmp.mapping(cmp.mapping.disable),
                    ['<C-E>'] = cmp.mapping(cmp.mapping.disable),
                    ['<C-y>'] = cmp.mapping(cmp.mapping.disable),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                },
                completion = {
                    keyword_length = 2
                },
                sources = {
                    {
                        name = 'buffer' ,
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                    },
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            buffer = '[Buffer]',
                            nvim_lsp = '[LSP]',
                            path = '[Path]',
                            luasnip = '[LuaSnip]',
                        })[entry.source.name]
                        return vim_item
                    end
                }
            })
        end
    },
    { 'williamboman/mason.nvim', config = true, cmd = 'Mason' },
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        dependencies = { 
            'hrsh7th/nvim-cmp', 
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim' 
        },
        config = function()
            local lspconfig = require('lspconfig')

            vim.diagnostic.config({ virtual_text = true, signs = true });

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end

            lspconfig.denols.setup ({
                root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
                init_options = { formatting = false },
                capabilities = capabilities,
                on_attach = on_attach
            })
            lspconfig.emmet_ls.setup({
                capabilities = capabilities,
                filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'vue' }
            })
        end
    },

    -- { 'b0o/SchemaStore.nvim', lazy = true },
    -- { 'nvim-tree/nvim-web-devicons' },

    {
        'kristijanhusak/vim-dadbod-ui',
        cmd = 'DBUI',
        dependencies = { 'tpope/vim-dadbod' },
        config = function()
            vim.g.db_ui_debug = 1
            vim.g.db_ui_save_location = '~/.config/db_ui'
        end
    },
    { 'tpope/vim-commentary', event='BufReadPost' },
    { 'windwp/nvim-autopairs', event='InsertCharPre' },
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
    { 'wellle/targets.vim', event='BufReadPost' },
    -- { 'terryma/vim-expand-region' },
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufReadPost',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('nvim-treesitter.configs').setup({
                -- context_commentstring = { enable = true, enable_autocmd = false },
                context_commentstring = { enable = true },
                highlight = { enable = true },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { 'BufWrite', 'CursorHold' }
                },
                matchup = { enable = true },
                ensure_installed = { 'css', 'html', 'javascript', 'json', 'lua', 'python', 'regex', 'scss', 'vue', 'ruby', 'vim', 'typescript', 'bash'}
            })
        end
        -- " :TSInstall bash css elm html java javascript json lua php python regex scss yaml toml tsx vue ruby rust typescript vim
    },
    {
        'NvChad/nvim-colorizer.lua',
        event = 'BufReadPre',
        config = {
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
    -- { 'mattn/emmet-vim' , ft = {'javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' }},
    { 'elmcast/elm-vim', ft = 'elm' },
    { 
        'folke/which-key.nvim', 
        event = 'VeryLazy',
        config = function()
            local presets = require("which-key.plugins.presets")
            presets.operators["v"] = nil
            presets.operators["d"] = nil
            presets.operators["c"] = nil
            require('which-key').setup()
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
    }
}

require('lazy').setup({
    spec = spec,
    rtp = { disabled_plugins = {'matchit', 'matchparen'} }
})

EOF
