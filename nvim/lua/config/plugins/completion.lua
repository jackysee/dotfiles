local blinkConfig = {
    {
        'saghen/blink.cmp',
        version = 'v0.*',
        -- !Important! Make sure you're using the latest release of LuaSnip
        -- `main` does not work at the moment
        dependencies = {
            { 'L3MON4D3/LuaSnip', version = 'v2.*' },
            "mikavilpas/blink-ripgrep.nvim"
        },
        opts = {
            keymap = {
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                -- ['<C-e>'] = { 'hide', 'fallback' },
                ['<C-e>'] = { 'fallback' },
                ['<C-y>'] = { 'select_and_accept', 'fallback' },
                -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
                -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
                ['<Tab>'] = {},
                ['<S-Tab>'] = {},
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-g>'] = {
                    function()
                        require('blink-cmp').show({ providers = { "ripgrep" } })
                    end
                }
            },
            appearance = {
                -- use_nvim_cmp_as_default = true,
                -- nerd_font_variant = 'mono'
            },
            completion = {
                menu = {
                    auto_show = function(ctx)
                        return ctx.mode ~= "cmdline" or 
                            not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                    end,
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                        }
                    }
                },
                list = { selection = { preselect = false, auto_insert = true } },
                documentation = { 
                    auto_show = true, 
                    auto_show_delay_ms = 250
                },
                -- ghost_text = { enabled = true },
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod'--[[ , 'ripgrep' ]] },
                cmdline = function()
                    local type = vim.fn.getcmdtype()
                    if type == ':' or type == '@' then return { 'cmdline' } end
                    return {}
                end,
                providers = {
                    lsp = {
                        min_keyword_length = 0, -- Number of characters to trigger porvider
                        score_offset = 0, -- Boost/penalize the score of the items
                    },
                    path = { min_keyword_length = 1, },
                    buffer = { 
                        min_keyword_length = 3,
                        max_items = 8,
                        opts = {
                            get_bufnrs = function()
                                return vim
                                  .iter(vim.api.nvim_list_bufs())
                                  :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                                  :totable()
                            end
                        }
                    },
                    snippets = { min_keyword_length = 2 },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        opts = { project_root_maker = { ".git", ".hg" } },
                        transform_items = function(_, items) 
                            for _, item in ipairs(items) do
                                item.labelDetails = {
                                    description = "[rg]"
                                }
                            end
                            return items
                        end
                    },
                    dadbod = {
                        name = "dadbod",
                        module = "vim_dadbod_completion.blink"
                    }
                },
                -- min_keyword_length = function() return 0 end
            },
            signature = { enabled = true },
        }
    }
}


local cmpConfig = {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp-signature-help'
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
                    -- ['<C-y>'] = cmp.mapping(cmp.mapping.disable),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-y>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                },
                completion = {
                    keyword_length = 2
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' }
                }, {
                    -- {
                    --     name = 'buffer' ,
                    --     option = {
                    --         get_bufnrs = function()
                    --             return vim.api.nvim_list_bufs()
                    --         end
                    --     }
                    -- },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            buffer = '[Buffer]',
                            nvim_lsp = '[LSP]',
                            path = '[Path]',
                            luasnip = '[LuaSnip]',
                            ["vim-dadbod-completion"] = '[DB]',
                        })[entry.source.name]
                        return vim_item
                    end
                }
            })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'sql', 'mysql', 'plsql' },
                callback = function()
                    cmp.setup.buffer({ 
                        sources = {
                            { name = 'vim-dadbod-completion' },
                            { name = 'buffer' }
                        }
                    })
                end
            })
        end
    } 
}

return blinkConfig
-- return cmpConfig
