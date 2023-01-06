" copy the following to c:/users/username/AppData/Local/nvim/init.vim
" set runtimepath^=/settings/dotfiles/nvim
" set runtimepath+=/settings/dotfiles/nvim/after
" let &packpath=&runtimepath
" source /settings/dotfiles/nvim/win_init.vim

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

" execute "source " . s:path  . '/statusline.vim'

" plugins managed by lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

local spec = {
    -- 'romainl/Apprentice',
    -- 'gruvbox-community/gruvbox'
    -- 'arcticicestudio/nord-vim'
    -- 'haishanh/night-owl.vim'
    --  'folke/tokyonight.nvim'
    { 'folke/tokyonight.nvim', config = function() vim.cmd([[colorscheme tokyonight ]]) end },
    -- { 'romainl/Apprentice', config = function() vim.cmd([[colorscheme apprentice ]]) end },
    -- { 'EdenEast/nightfox.nvim', config = function() vim.cmd([[colorscheme nightfox]]) end },

    {
        'mhinz/vim-startify',
        event = 'BufWinEnter',
        config = function()
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
            vim.g.startify_lists = {
                {  header = { '   MRU '..vim.fn.getcwd()}, type = 'dir' },
                {  header = { '   MRU'}, type = 'files' },
                {  header = { '   Sessions'}, type = 'sessions' }
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
    { 'tpope/vim-fugitive' event = "BufReadPre" },
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
    { 'ludovicchabant/vim-lawrencium', event = "BufReadPre" },

    { 'whiteinge/diffconflicts' , event = 'BufReadPre' },
    {
        'gbprod/yanky.nvim',
        event = "BufReadPost",
        config = function()
            require('yanky').setup()
            vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
            -- vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
            -- vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
            vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
            vim.keymap.set('n', '<leader>y', ':YankyRingHistory<cr>')
       end 
    },
    { 'tpope/vim-repeat', event = "BufReadPost" },
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
    {
        'nvim-telescope/telescope-fzf-native.nvim', 
        build = vim.fn.executable('cmake') == 1 and 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' or 'make'
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        event = "BufWinEnter",
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup({
                defaults = {
                    layout_config = {
                        prompt_position = 'top',
                        width = 0.92,
                    },
                    layout_strategy = "flex",
                    -- border = false,
                    path_display = {'truncate'}, 
                    sorting_strategy = "ascending",
                    mappings = {
                        i =  {
                            ["<esc>"] = actions.close,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
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
            })
            require('telescope').load_extension('fzf')
            local builtin = require('telescope.builtin');
            local findFiles = function(txt)
                builtin.find_files({
                    find_command = { 'rg', '--files' },
                    search_file = txt
                })
            end
            local grep = function(txt)
                builtin.grep_string({ search = txt, use_regex = true })
            end

            local vtext = function()
                vim.cmd [[ normal! : ]] --to update visual marks using command mode
                local vstart = vim.fn.getpos("'<")
                local vend = vim.fn.getpos("'>")
                print(vstart, vend)
                local lines = vim.fn.getline(vstart[2], vend[2])
                if #lines == 0 then return '' end
                local txt = ''
                for k,v in ipairs(lines) do
                    local i = k == 1 and vstart[3] or 1
                    local j = #lines == k and vend[3] or nil
                    if vim.o.selection == 'exclusive' and j ~= nil then j = j - 1 end
                    txt = txt .. v.sub(v, i, j)
                end
                return txt
            end

            vim.keymap.set('n', '<leader>f', function() findFiles(nil) end)
            vim.keymap.set('n', '<leader>F', function() findFiles(vim.fn.expand('<cword>')) end)
            vim.keymap.set('n', '<leader>r', function() builtin.oldfiles() end)
            vim.keymap.set('n', '<leader>b', function() builtin.buffers() end)
            vim.keymap.set('n', '<leader>lg', function() builtin.live_grep({}) end)
            vim.keymap.set('n', '<leader>rg', function() grep(vim.fn.expand('<cword>')) end)
            vim.keymap.set('v', '<leader>rg', function() grep(vtext()) end)
            vim.keymap.set('v', '<leader>F', function() findFiles(vtext()) end)
            vim.api.nvim_create_user_command("Rg", function(opts) grep(opts.args) end, { nargs = '*'})
        end
    },
    {  
        'nvim-lualine/lualine.nvim', 
        event = "VeryLazy",
        config = function()
            local vcs = function()
                local status = ''
                if vim.g.loaded_fugitive then 
                    status = status .. vim.fn.FugitiveHead()
                end
                if vim.g.loaded_lawrencium then
                    status = status .. vim.fn['lawrencium#statusline']()
                end
                if vim.b.sy.stats then
                    for i,v in ipairs({'+','-','~'}) do
                        if vim.b.sy.stats[i] > 0 then
                            status = status .. v .. vim.b.sy.stats[i]
                        end
                    end
                end
                return status
            end
            require('lualine').setup({
                sections = {
                    lualine_a = { vcs },
                    lualine_b = { { 'filename', path = 1 } },
                    lualine_c = {},
                    lualine_x = {  'diagnostics', 'filetype' },
                },
                options = { section_separators = '', component_separators = '' }
            })
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
    { 'williamboman/mason-lspconfig.nvim', config = true, dependencies = { "williamboman/mason.nvim" } },
    {
        'neovim/nvim-lspconfig',
        lazy = true,
        dependencies = { 'hrsh7th/nvim-cmp' },
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


    -- { 'b0o/SchemaStore.nvim' },
    -- { 'tpope/vim-dadbod' },
    -- {
    --     'kristijanhusak/vim-dadbod-ui',
    --     dependencies = { 'tpope/vim-dadbod' },
    --     config = function()
    --         vim.g.db_ui_debug = 1
    --         vim.g.db_ui_save_location = '~/.config/db_ui'
    --     end
    -- },
    { 
        'JoosepAlviste/nvim-ts-context-commentstring', 
        dependencies =  { 'nvim-treesitter/nvim-treesitter', 'tpope/vim-commentary' } 
    },
    { 'tpope/vim-commentary', event = "BufReadPost" },
    -- { 'windwp/nvim-autopairs', config = true },
    { 'Raimondi/delimitMate', event = "BufReadPost" },
    -- {
    --     "andymass/vim-matchup",
    --     event = "BufReadPost",
    --     config = function()
    --         vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    --     end
    -- },
    -- { 'arthurxavierx/vim-caser' },
    { 'wellle/targets.vim', event = 'BufReadPost' },
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
    { 'mattn/emmet-vim' , ft = {'javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' }}
}

require("lazy").setup({
    spec = spec,
    -- rtp = { disabled_plugins = {'matchit', 'matchparen'} }
})

EOF
