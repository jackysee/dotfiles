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


nnoremap <silent> <leader>/ :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
nnoremap <leader><leader> <c-^>

set list listchars=tab:»-,trail:.,extends:>,precedes:<,nbsp:+

set undofile
let &undodir= s:path . '/undo'

" auto reload vimrc when editing it
autocmd! bufwritepost init.vim source $MYVIMRC

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


" Shortcuts / mappings

" paste on visual mode without chaning original register
vnoremap p "_dP

" reselect pasted selection
nnoremap gp `[v`]

"; :
nnoremap ; :
nnoremap > ;
nnoremap < ,

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

"quick fix
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>


" netw
let g:netrw_browse_split=2
nnoremap <leader>pv :wincmd v <bar>  :wincmd h <bar> :Ex <bar> :vertical resize 35<CR>

"textobj for bracket function like block (linewise)
xnoremap <silent> af :<c-u>normal! g_v%V<cr>
onoremap <silent> af :<c-u>normal! g_v%V<cr>

" vimdiff
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffput<CR>


" sudo tee save with w!!
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

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



" auto create folder when saving files
lua << EOF
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(ctx)
        local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
        vim.fn.mkdir(dir, "p")
    end
})
EOF

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

".test.js filetype
au BufRead,BufNewFile *.test.js  setlocal filetype=javascript.jest

" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

xnoremap <leader>pt :!npx -q prettierd --stdin-filepath=%:p
xnoremap <leader>pjs :!npx -q prettierd --stdin-filepath=%:p --parser=babel --trailing-comma=none --tab-width=4
xnoremap <leader>psql :!npx -q sql-formatter-cli

xnoremap <leader>sc :!tw2s<cr>


" paste without polluting register
xnoremap <leader>p "_dP
vnoremap <leader>d "_d
nnoremap <leader>d "_d

" ~/.vim/plugin/win_resize.vim
nnoremap <leader>w :WinResize<CR>

" vue3_emits
function! Vue_Refactoring()
    lua vim.api.nvim_create_user_command("VueEmits", function() require('vue_3_emits').get_emits() end, {})
    nnoremap <leader>ve A,<CR><C-O>:VueEmits<cr><esc>==
    vnoremap <leader>vm :s/:value/:modelValue/g<cr>gv:s/@input/@update:modelValue/g<cr>
endfunction
autocmd FileType vue call Vue_Refactoring()

execute "source " . s:path  . '/statusline.vim'

" plugins managed by lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
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
        return { 'junegunn/fzf', event = "BufWinEnter" }
    end
end

local colorscheme = function(repo, scheme, load)
    return {
        repo,
        lazy = load == false,
        config = function()
            if load then
                vim.cmd("colorscheme "..scheme)
                vim.cmd("set termguicolors")
            end
        end
    }
end

local spec = {
    colorscheme('romainl/Apprentice', 'Apprentice'),
    colorscheme('haishanh/night-owl.vim', 'night-owl'),
    colorscheme('folke/tokyonight.nvim', 'tokyonight'),
    colorscheme('EdenEast/nightfox.nvim', 'nightfox', true),
    {
        'mhinz/vim-startify',
        event = 'BufWinEnter',
        config = function()
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
            vim.g.startify_lists = {
                {  header = { '   MRU '..vim.fn.getcwd() }, type = 'dir' },
                {  header = { '   MRU' }, type = 'files' },
                {  header = { '   Sessions' }, type = 'sessions' }
            }
        end
    },
    {
        'mbbill/undotree',
        event = "BufReadPre",
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
            vim.keymap.set("n", "<leader>hu", ":SignifyHunkUndo<cr>")
            vim.keymap.set("n", "<leader>hd", ":SignifyHunkDiff<cr>")
        end
    },
    { 'ludovicchabant/vim-lawrencium', event = 'BufReadPre' },

    { 'whiteinge/diffconflicts', event = 'BufReadPre' },
    {
        'gbprod/yanky.nvim',
        event = "BufReadPost",
        config = function()
            require('yanky').setup()
            vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
            vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
            vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
            vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
            -- vim.keymap.set('n', '<leader>y', ':YankyRingHistory<cr>')
       end
    },
    { 'tpope/vim-repeat', event="BufReadPost" },
    {
        'tpope/vim-surround',
        event = "CursorHold",
        config = function()
            vim.g.surround_no_mappings = 1
            vim.keymap.set('n', 'ds', '<Plug>Dsurround')
            vim.keymap.set('n', 'cs', '<Plug>Csurround')
            vim.keymap.set('n', 'cS', '<Plug>CSurround')
            vim.keymap.set('n', 'ys', '<Plug>Ysurround')
            vim.keymap.set('n', 'yS', '<Plug>YSurround')
            vim.keymap.set('n', 'yss', '<Plug>Yssurround')
            vim.keymap.set('n', 'ySs', '<Plug>YSsurround')
            vim.keymap.set('n', 'ySS', '<Plug>YSsurround')
            vim.keymap.set('x', 'gs', '<Plug>VSurround')
            vim.keymap.set('x', 'gS', '<Plug>VgSurround')
        end
    },
    { 'tpope/vim-eunuch', event = "CmdlineEnter" },
    { 'elihunter173/dirbuf.nvim', event = "CmdlineEnter" },
    {
        'ggandor/leap.nvim',
        event="BufReadPost",
        config = function()
            require('leap').set_default_keymaps()
        end
    },
    {
        'ggandor/flit.nvim',
        event="BufReadPost",
        dependencies = { 'ggandor/leap.nvim' },
        config = true
    },
    {
        'ggandor/leap-spooky.nvim',
        event="BufReadPost",
        dependencies = { 'ggandor/leap.nvim' },
        config = true
    },
    fzf_spec(),
    {
        'ibhagwan/fzf-lua',
        event = "BufWinEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons', 'junegunn/fzf' },
        config = function()
            vim.env.FZF_DEFAULT_OPTS = ' --reverse' 
            local f = require('fzf-lua');
            local files = function(txt)
                f.files({ fzf_opts = { ['--query'] = vim.fn.shellescape(txt) } })
            end
            f.setup({
                winopts = { height=0.9, width=0.9 },
                files = { actions = { ["ctrl-x"] = f.actions.file_split } }
            })
            vim.keymap.set('n', '<leader>f', f.files, { silent = true })
            vim.keymap.set('n', '<leader>F', function() files("'"..vim.fn.expand('<cword>')) end, { silent = true });
            vim.keymap.set('v', '<leader>F', function() files("'"..f.utils.get_visual_selection()) end, { silent = true });
            vim.keymap.set('n', '<leader>b', f.buffers, { silent = true })
            vim.keymap.set('n', '<leader>o', f.oldfiles, { silent = true })
            vim.keymap.set('n', '<leader>rg', f.grep_cword, { silent = true })
            vim.keymap.set('v', '<leader>rg', f.grep_visual, { silent = true })
            vim.keymap.set('n', '<leader>z', ':FzfLua ');
            vim.api.nvim_create_user_command("Rg", function(opts) f.grep_project({ search = opts.args }) end, { nargs = '*'})
            vim.keymap.set('n', '<leader>y', function() require('fzf_yanky').fzf_yanky() end, { silent = true })
        end
    },
    { 'nvim-lua/plenary.nvim' },
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = "BufWinEnter",
        dependencies = { 'nvim-lua/plenary.nvim'},
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup {
                debug = true,
                sources = {
                    null_ls.builtins.formatting.prettierd.with({
                        filetypes = { "javascript", "typescript", "vue", "html", "css" },
                        condition = function()
                            return require("null-ls.utils").root_pattern(
                                ".prettierrc",
                                ".prettierrc.json",
                                ".prettierrc.yml",
                                ".prettierrc.yaml",
                                ".prettierrc.json5",
                                ".prettierrc.js",
                                ".prettierrc.cjs",
                                ".prettierrc.toml",
                                "prettier.config.js",
                                "prettier.config.cjs"
                                --"package.json"
                            )(vim.api.nvim_buf_get_name(0)) ~= nil
                        end
                    }),
                    null_ls.builtins.diagnostics.eslint_d.with({
                        filetypes = { "javascript", "typescript", "vue", "html", "css" },
                        condition = function()
                            return require("null-ls.utils").root_pattern(
                                "eslint.config.js",
                                -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
                                ".eslintrc",
                                ".eslintrc.js",
                                ".eslintrc.cjs",
                                ".eslintrc.yaml",
                                ".eslintrc.yml",
                                ".eslintrc.json",
                                "package.json"
                            )(vim.api.nvim_buf_get_name(0)) ~= nil
                        end
                    })
                },
                on_attach = function(client, bufnr)
                    -- if client.resolved_capabilities.document_formatting then
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end
            }

            local null_ls_stop = function()
                local null_ls_client
                for _, client in ipairs(vim.lsp.get_active_clients()) do
                    if client.name == "null-ls" then
                        null_ls_client = client
                    end
                end
                if not null_ls_client then
                    return
                end

                null_ls_client.stop()
                vim.diagnostic.reset()
            end

            vim.api.nvim_create_user_command("NullLsStop", null_ls_stop, {})
        end
    },

    { 'rafamadriz/friendly-snippets', event = "InsertCharPre" },
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        event = "InsertCharPre",
        config = function()
            local luasnip = require('luasnip')
            vim.cmd [[ imap <silent><expr> <C-e> luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '' ]]
            vim.cmd [[ imap <silent><expr> <C-j> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Plug>luasnip-expand-or-jump' ]]
            vim.cmd [[ imap <silent><expr> <C-k> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-k>' ]]

            luasnip.config.set_config {
                history = true,
                -- updateevents = "TextChanged,TextChangedI",
                store_selection_keys = "<Tab>"
            }
            require('luasnip/loaders/from_vscode').lazy_load();
            require('luasnip/loaders/from_vscode').lazy_load({ paths = { "./snippets" } });
            -- require('./snippets/javascript');
            luasnip.filetype_extend("vue", {"html", "javascript", "css"})
            luasnip.filetype_extend("typescript", { "javascript"})
        end
    },


    { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip' }, event = "InsertCharPre" },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
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
                        name = "buffer" ,
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                    },
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" }
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            path = "[Path]",
                            luasnip = "[LuaSnip]",
                        })[entry.source.name]
                        return vim_item
                    end
                }
            })
        end
    },
    { 'williamboman/mason.nvim', config = true, lazy = true },
    { 'williamboman/mason-lspconfig.nvim', config = true, dependencies = { 'williamboman/mason.nvim' } },
    {
        'neovim/nvim-lspconfig',
        lazy = true,
        dependencies = { 'hrsh7th/nvim-cmp', 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local lspconfig = require("lspconfig")

            vim.diagnostic.config({ virtual_text = true, signs = true });

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end

            lspconfig.denols.setup {
                root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
                init_options = { formatting = false },
                capabilities = capabilities,
                on_attach = on_attach
            }
        end
    },

    -- { 'b0o/SchemaStore.nvim', lazy = true },
    { 'nvim-tree/nvim-web-devicons' },

    { 'tpope/vim-dadbod' },
    {
        'kristijanhusak/vim-dadbod-ui',
        cmd = "DBUI",
        dependencies = { 'tpope/vim-dadbod' },
        config = function()
            vim.g.db_ui_debug = 1
            vim.g.db_ui_save_location = '~/.config/db_ui'
        end
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies =  { 'nvim-treesitter/nvim-treesitter', 'tpope/vim-commentary' }
    },
    { 'tpope/vim-commentary', event="BufReadPost" },
    { 'windwp/nvim-autopairs', config = true, event="InsertCharPre" },
    -- { 'Raimondi/delimitMate' },
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end
    },
    { 'arthurxavierx/vim-caser', event = "BufReadPost" },
    { 'christoomey/vim-tmux-navigator' },
    {
        'tmux-plugins/vim-tmux-focus-events',
        config = function()
            vim.g.tmux_navigator_disable_when_zoomed = 1
        end
    },
    {
        'rlue/vim-barbaric',
        config = function()
            vim.g.barbaric_ime = 'fcitx'
            vim.g.barbaric_fcitx_cmd = 'fcitx-remote'
        end
    },
    { 'wellle/targets.vim', event="BufReadPost" },
    -- { 'terryma/vim-expand-region' },
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },

    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                -- context_commentstring = { enable = true, enable_autocmd = false },
                context_commentstring = { enable = true },
                highlight = { enable = true },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" }
                },
                matchup = { enable = true },
                ensure_installed = { 'css', 'html', 'javascript', 'json', 'lua', 'python', 'regex', 'scss', 'vue', 'ruby', 'vim', 'typescript', 'bash'}
            })
        end
        -- " :TSInstall bash css elm html java javascript json lua php python regex scss yaml toml tsx vue ruby rust typescript vim
    },
    {
        'NvChad/nvim-colorizer.lua',
        event = "BufReadPre",
        config = {
            filetypes = { "*", "!lazy" },
            buftype = { "*", "!prompt", "!nofile" },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes: foreground, background
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                virtualtext = "■",
            },
        }
    },
    { 'mattn/emmet-vim' , ft = {'javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' }},
    { 'elmcast/elm-vim', ft = 'elm' }
}

require("lazy").setup({
    spec = spec,
    rtp = { disabled_plugins = {'matchit', 'matchparen'} }
})

EOF
