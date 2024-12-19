return {
    { 'williamboman/mason.nvim', config = true, cmd = 'Mason' },
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        dependencies = { 
            'hrsh7th/nvim-cmp', 
            -- 'saghen/blink.cmp',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim' 
        },
        config = function(_, opts)
            require("mason-lspconfig").setup()

            vim.diagnostic.config({ virtual_text = true, signs = true });

            local lspconfig = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            -- local capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
            -- local capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            -- for server, config in pairs(opts.servers) do
            --     config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            --     lspconfig[server].setup(config)
            -- end

            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end

            lspconfig.denols.setup ({
                root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
                init_options = { formatting = false },
                capabilities = capabilities,
                on_attach = on_attach
            })

            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                on_attach = on_attach
            })

            local read_exec_path = function(exec_name)
                local handle = io.popen("which " .. exec_name)
                local result = handle:read("*a"):gsub("\n", "")
                handle:close()
                return result
            end

            lspconfig.pyright.setup({
                settings = {
                    python = {
                        pythonPath = read_exec_path("python")
                    }
                }
            })
        end
    },

}
