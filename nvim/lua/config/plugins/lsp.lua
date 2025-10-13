return {
    { 'williamboman/mason.nvim', config = true, cmd = 'Mason' },
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        dependencies = { 
            -- 'hrsh7th/nvim-cmp', 
            'saghen/blink.cmp',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim' 
        },
        config = function(_, opts)
            require("mason-lspconfig").setup()

            vim.diagnostic.config({ virtual_text = true, signs = true });

            local capabilities = vim.lsp.protocol.make_client_capabilities()

            if pcall(require, 'blink.cmp') then
                capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
                -- for server, config in pairs(opts.servers) do
                --     config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                --     lspconfig[server].setup(config)
                -- end
            elseif pcall(require, 'cmp_nvim_lsp') then
                capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
                capabilities.textDocument.completion.completionItem.snippetSupport = true
            end


            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end

            vim.lsp.config('denols', {
                root_dir = function(bufnr, on_dir) 
                    if vim.fs.root(bufnr, {'deno.json', 'deno.jsonc'}) then 
                        on_dir(vim.fn.getcwd()) 
                    end
                end,
                init_options = { formatting = false },
                capabilities = capabilities,
                -- on_attach = on_attach
            })
            -- vim.api.nvim_create_autocmd('LspAttach', {
            --     callback = function(ev)
            --         local client = vim.lsp.get_client_by_id(ev.data.client_id)
            --         if client.name == 'denols' then
            --             client.server_capabilities.documentFormattingProvider = false
            --         end
            --     end
            -- })
            vim.lsp.enable('denols');

            -- lspconfig.denols.setup ({
            --     init_options = { formatting = false },
            --     capabilities = capabilities,
            --     on_attach = on_attach
            -- })

            -- lspconfig.tailwindcss.setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach
            -- })

            -- lspconfig.emmet_language_server.setup({
            --     filetypes = {'javascript', 'javascript.jsx', 'vue', 'html', 'css', 'scss', 'sass' },
            --     capabilities = capabilities,
            --     on_attach = on_attach
            -- })

            local read_exec_path = function(exec_name)
                local handle = io.popen("which " .. exec_name)
                local result = handle:read("*a"):gsub("\n", "")
                handle:close()
                return result
            end

            vim.lsp.config('pyright', {
                settings = {
                    python = {
                        pythonPath = read_exec_path("python")
                    }
                }
            })
            vim.lsp.enable('pyright')
            -- lspconfig.pyright.setup({
            --     settings = {
            --         python = {
            --             pythonPath = read_exec_path("python")
            --         }
            --     }
            -- })
        end
    },
    {
        "mhanberg/output-panel.nvim",
        event = "VeryLazy",
        config = function()
            require("output_panel").setup({})
        end
    }

}
