-- return {
--     {
--         'saghen/blink.cmp',
--         version = 'v0.*',
--         -- !Important! Make sure you're using the latest release of LuaSnip
--         -- `main` does not work at the moment
--         dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
--         opts = {
--             keymap = {
--                 ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
--                 ['<C-e>'] = { 'hide', 'fallback' },
--                 ['<CR>'] = { 'accept', 'fallback' },
--                 ['<Tab>'] = { 'snippet_forward', 'fallback' },
--                 ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
--                 ['<Up>'] = { 'select_prev', 'fallback' },
--                 ['<Down>'] = { 'select_next', 'fallback' },
--                 ['<C-p>'] = { 'select_prev', 'fallback' },
--                 ['<C-n>'] = { 'select_next', 'fallback' },
--                 ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
--                 ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
--             },
--             appearance = {
--                 use_nvim_cmp_as_default = true,
--                 -- nerd_font_variant = 'mono'
--             },
--             snippets = {
--                 expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
--                 active = function(filter)
--                     if filter and filter.direction then
--                         return require('luasnip').jumpable(filter.direction)
--                     end
--                     return require('luasnip').in_snippet()
--                 end,
--                 jump = function(direction) require('luasnip').jump(direction) end,
--             },
--             sources = {
--                 default = { 'lsp', 'path', 'luasnip', 'buffer' }
--             },
--             signature = { enabled = true },
--         }
--     }
-- }


return {
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
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' }
                },
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
