" copy the following to c:/users/username/AppData/Local/nvim/init.vim
" source /settings/dotfiles/nvim/win_init.vim

" Constants
let g:config_path = expand('<sfile>:p:h')
exe 'set runtimepath^='.g:config_path
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
autocmd! bufwritepost win_init.vim source $MYVIMRC


if exists('g:nvy')
    au GUIEnter * simalt ~x
    set guifont=Source_Code_Pro:h10
    set linespace=1
    set t_ut=
endif

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
execute 'nnoremap <silent> <leader>vv :vsp '.s:path.'/win_init.vim<CR>'

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
    lua vim.api.nvim_create_user_command("VueEmits", function() require("vue_3_emits").get_emits() end, {})
    nnoremap <leader>ve A,<CR><C-O>:VueEmits<cr><esc>==
    vnoremap <leader>vm :s/:value/:modelValue/g<cr>gv:s/@input/@update:modelValue/g<cr>
endfunction
autocmd FileType vue call Vue_Refactoring()

autocmd User VeryLazy execute 'source ' . s:path  . '/statusline.vim'

" window navigation
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l


" plugins managed by lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

local colorscheme = function(repo, scheme, load)
    local event = 'VeryLazy'
    if load == true then event = nil end
    return {
        repo,
        event = event,
        config = function()
            if load then
                vim.cmd("colorscheme "..scheme)
                vim.cmd("set termguicolors")
            end
        end
    }
end

local spec = {
    colorscheme("romainl/Apprentice", "Apprentice"),
    colorscheme("haishanh/night-owl.vim", "night-owl"),
    colorscheme("folke/tokyonight.nvim", "tokyonight", true),
    colorscheme("EdenEast/nightfox.nvim", "nightfox"),
    {
        "mbbill/undotree",
        event = "BufReadPre",
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.keymap.set("n", "<F5>", ":UndotreeToggle<cr>")
        end
    },
    -- vcs
    { "tpope/vim-fugitive", event = "BufReadPre" },
    {
        "mhinz/vim-signify",
        event = "BufReadPre",
        config = function()
            vim.g.signify_realtime = 0
            vim.g.signify_sign_change = "~"
            vim.g.signify_update_on_focusgained = 1
            vim.g.signify_priority = 5
            vim.keymap.set("n", "<leader>hu", ":SignifyHunkUndo<cr>")
            vim.keymap.set("n", "<leader>hd", ":SignifyHunkDiff<cr>")
        end
    },
    { "ludovicchabant/vim-lawrencium", event = "BufReadPre" },

    { "whiteinge/diffconflicts" , event = "BufReadPre" },
    {
        "gbprod/yanky.nvim",
        event = "BufReadPost",
        config = function()
            require("yanky").setup()
            vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
            -- vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
            -- vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
            vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
       end
    },
    { "tpope/vim-repeat", event = "BufReadPost" },
    {
        "tpope/vim-surround",
        event = "CursorHold",
        init = function()
            vim.g.surround_no_mappings = 1
        end,
        config = function()
            vim.keymap.set("n", "ds", "<Plug>Dsurround")
            vim.keymap.set("n", "cs", "<Plug>Csurround")
            vim.keymap.set("n", "cS", "<Plug>CSurround")
            vim.keymap.set("n", "ys", "<Plug>Ysurround")
            vim.keymap.set("n", "yS", "<Plug>YSurround")
            vim.keymap.set("n", "yss", "<Plug>Yssurround")
            vim.keymap.set("n", "ySs", "<Plug>YSsurround")
            vim.keymap.set("n", "ySS", "<Plug>YSsurround")
            vim.keymap.set("x", "gs", "<Plug>VSurround")
            vim.keymap.set("x", "gS", "<Plug>VgSurround")
        end
    },
    { "tpope/vim-eunuch", event = "CmdlineEnter" },
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
    -- {
    --     "nvim-telescope/telescope-fzf-native.nvim",
    --     lazy = true,
    --     build = vim.fn.executable("cmake") == 1 and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" or "make"
    -- },
    -- {
    --     "nvim-telescope/telescope.nvim",
    --     event = "BufWinEnter",
    --     dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim"},
    --     config = function()
    --         local t = require("telescope");
    --         local actions = require('telescope.actions')
    --         local builtin = require('telescope.builtin')
    --         t.setup({
    --             defaults = {
    --                 layout_config = {
    --                     prompt_position = "top",
    --                     width = 0.92,
    --                 },
    --                 layout_strategy = "flex",
    --                 -- border = false,
    --                 path_display = {"truncate"},
    --                 sorting_strategy = "ascending",
    --                 mappings = {
    --                     i =  {
    --                         ["<esc>"] = actions.close,
    --                         ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
    --                     }
    --                 }
    --             },
    --             extensions = {
    --                fzf = {
    --                    fuzzy = true,                    -- false will only do exact matching
    --                    override_generic_sorter = true, -- override the generic sorter
    --                    override_file_sorter = true,     -- override the file sorter
    --                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    --                    -- the default case_mode is "smart_case"
    --                }
    --             }
    --         })
    --         t.load_extension("fzf")
    --         t.load_extension("yank_history")
    --         local findFiles = function(txt)
    --             builtin.find_files({
    --                 find_command = { "rg", "--files" },
    --                 search_file = txt
    --             })
    --         end
    --         local grep = function(txt)
    --             builtin.grep_string({ search = txt, use_regex = true })
    --         end
    --         local vtext = require("util").vtext;
    --         vim.keymap.set("n", "<leader>f", function() findFiles(nil) end)
    --         vim.keymap.set("n", "<leader>F", function() findFiles(vim.fn.expand("<cword>")) end)
    --         vim.keymap.set("n", "<leader>o", function() builtin.oldfiles() end)
    --         vim.keymap.set("n", "<leader>b", function() builtin.buffers() end)
    --         vim.keymap.set("n", "<leader>lg", function() builtin.live_grep({}) end)
    --         vim.keymap.set("n", "<leader>rg", function() grep(vim.fn.expand("<cword>")) end)
    --         vim.keymap.set("v", "<leader>rg", function() grep(vtext()) end)
    --         vim.keymap.set("v", "<leader>F", function() findFiles(vtext()) end)
    --         vim.keymap.set("n", "<leader>y", ":FzfLua yank_history");
    --         vim.api.nvim_create_user_command("Rg", function(opts) grep(opts.args) end, { nargs = "*"})
    --     end
    -- },
    -- { "nvim-lua/plenary.nvim" },
    {
        'ibhagwan/fzf-lua',
        event = 'BufWinEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'junegunn/fzf' },
        config = function()
            vim.env.FZF_DEFAULT_OPTS = ' --reverse' 
            local f = require('fzf-lua');
            local files = function(txt)
                -- f.files({ fzf_opts = { ['--query'] = vim.fn.shellescape(txt) } })
                f.files({ fzf_opts = { ['--query'] = txt } })
            end
            f.setup({
                winopts = { height=0.9, width=0.9 },
                files = { actions = { ['ctrl-x'] = f.actions.file_split } },
                defaults = {
                    git_icons = false,
                    file_icons = false
                }
            })
            vim.keymap.set('n', '<leader>ff', f.files, { silent = true, desc = 'fzf files' })
            vim.keymap.set('n', '<leader>F', function() files("'"..vim.fn.expand('<cword>')) end, { silent = true, desc = 'exact file match <cword>'});
            vim.keymap.set('v', '<leader>F', function() files("'"..f.utils.get_visual_selection()) end, { silent = true, desc = 'exact file match selection' });
            vim.keymap.set('n', '<leader>bb', f.buffers, { silent = true, desc = 'buffers' })
            vim.keymap.set('n', '<leader>bl', f.blines, { silent = true, desc = 'blines' })
            vim.keymap.set('n', '<leader>fo', f.oldfiles, { silent = true, desc = 'oldfiles' })
            vim.keymap.set('n', '<leader>lg', f.live_grep_glob, { silent = true, desc = 'livegrep' })
            vim.keymap.set('n', '<leader>rg', f.grep_cword, { silent = true, desc = 'rg <cword>' })
            vim.keymap.set('v', '<leader>rg', f.grep_visual, { silent = true, desc = 'rg selection' })
            vim.keymap.set('n', '<leader>z', ':FzfLua ', { desc = 'cmd :FzfLua '});
            vim.api.nvim_create_user_command('Rg', function(opts) f.grep_project({ search = opts.args }) end, { nargs = '*'})
            vim.keymap.set('n', '<leader>fy', function() yanky() end, { silent = true, desc = 'yank ring history' })
            vim.keymap.set('n', '<leader>fs', function() persistence_session() end, { silent = true, desc = 'sessions' })
            vim.keymap.set('n', '<leader>fh', f.help_tags, { silent = true, desc = 'help tags' })
            vim.keymap.set('n', '<leader>fr', f.registers, { silent = true, desc = 'registers' })
        end
    },
    require('null_ls_spec'),
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = "InsertCharPre",
        config = function()
            local luasnip = require("luasnip")
            vim.cmd [[ imap <silent><expr> <C-e> luasnip#expandable() ? "<Plug>luasnip-expand-or-jump" : "" ]]
            vim.cmd [[ imap <silent><expr> <C-j> luasnip#jumpable(1) ? "<Plug>luasnip-jump-next" : "<Plug>luasnip-expand-or-jump" ]]
            vim.cmd [[ imap <silent><expr> <C-k> luasnip#jumpable(-1) ? "<Plug>luasnip-jump-prev" : "<C-k>" ]]

            luasnip.config.set_config {
                history = true,
                -- updateevents = "TextChanged,TextChangedI",
                store_selection_keys = "<Tab>"
            }
            require("luasnip/loaders/from_vscode").lazy_load();
            require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./snippets" } });
            -- require("./snippets/javascript");
            luasnip.filetype_extend("vue", {"html", "javascript", "css"})
            luasnip.filetype_extend("typescript", { "javascript"})
        end
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path"
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping(cmp.mapping.disable),
                    ["<C-E>"] = cmp.mapping(cmp.mapping.disable),
                    ["<C-y>"] = cmp.mapping(cmp.mapping.disable),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({
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
    {
        "williamboman/mason.nvim",
        cmd = { "MasonInstall", "MasonUninstall", "Mason", "MasonUninstallAll", "MasonLog" },
        config = true
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        dependencies = { 
            "hrsh7th/nvim-cmp", 
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim" 
        },
        config = function()
            local lspconfig = require("lspconfig")

            vim.diagnostic.config({ virtual_text = true, signs = true });

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end

            lspconfig.denols.setup {
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
                init_options = { formatting = false },
                capabilities = capabilities,
                on_attach = on_attach
            }
        end
    },

    -- { "tpope/vim-commentary", event = "BufReadPost" },
    { 
        'numToStr/Comment.nvim', 
        -- dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        opts = {}
    },
    -- { "Raimondi/delimitMate", event = "BufReadPost" },
    { 'windwp/nvim-autopairs', event='InsertEnter', config = true },
    { "wellle/targets.vim", event = "BufReadPost" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- context_commentstring = { enable = true, enable_autocmd = false },
                -- context_commentstring = { enable = true },
                highlight = { enable = true },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" }
                },
                matchup = { enable = true },
                ensure_installed = { "css", "html", "javascript", "json", "lua", "python", "regex", "scss", "vue", "ruby", "vim", "typescript", "bash"}
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
    { "mattn/emmet-vim" , ft = {"javascript", "javascript.jsx", "vue", "html", "css", "scss", "sass" }},
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
}

require("lazy").setup(spec, {
    performance = {
        rtp = {
            paths = { vim.g.config_path }
        }
    }
})

vim.deprecate = function() end

if vim.g.neovide then
    -- vim.g.neovide_cursor_animation_length = 0
    vim.o.guifont = "Consolas:h11"
end

EOF
