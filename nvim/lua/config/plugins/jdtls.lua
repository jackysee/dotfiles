return {
    "mfussenegger/nvim-jdtls",
    ft = {"java"},
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        local root_directory = vim.fs.root(0, {"build.gradle"})
        local project_dir = vim.fs.basename(root_directory)
        local on_attach = function(client, bufnr)
          -- local function buf_set_keymap(...)
          --   vim.api.nvim_buf_set_keymap(bufnr, ...)
          -- end
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          local opts = { buffer, bufnr, noremap=true, silent= true }
          vim.keymap.set('n', '<leader>oi', function() require('jdtls').organize_imports() end, { buffer = bufnr, silent = true, noremap = true, desc = 'organize imports'});
          vim.keymap.set('n', '<leader>ca', require('fzf-lua').lsp_code_actions, { buffer = bufnr, silent = true, noremap = true, desc = 'organize imports'})
          -- buf_set_keymap("n", "gd", "Telescope lsp_definitions", opts)
          -- buf_set_keymap("n", "gr", "Telescope lsp_references", opts)
        end

        local home = os.getenv('HOME')
        local java_path = "/usr/lib/jvm/java-17-openjdk/bin/java"
        local install_path = home .. "/.local/share/nvim/mason/packages/jdtls"
        local jar_path = vim.fs.find(function(name, path)
            return name:match('org%.eclipse%.equinox%.launcher_.*%.jar')
        end, { type = 'file', path = install_path })[1]
        local workspace = home .. '/jdtls-ws/' .. project_dir


        vim.api.nvim_create_user_command('JdtStart', function()

            if vim.fn.isdirectory(workspace) == 0  then
                vim.fn.mkdir(workspace, "p")
            end


            require('jdtls').start_or_attach({
                cmd = {
                    java_path,
                    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                    '-Dosgi.bundles.defaultStartLevel=4',
                    '-Xmx8g',
                    -- '-Xms100m',
                    -- '-XX:+UseParallelGC',
                    -- '-XX:GCTimeRatio=4',
                    -- '-XX:AdaptiveSizePolicyWeight=90',
                    '-Dsun.zip.disableMemoryMapping=true',
                    '-Declipse.product=org.eclipse.jdt.ls.core.product',
                    '-Dlog.protocol=true',
                    '-Dlog.level=ALL',
                    '--add-modules=ALL-SYSTEM',
                    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                    '-jar', jar_path,
                    '-configuration', install_path  .. '/config_linux',
                    '-data', workspace
                },
                root_dir = root_directory,
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        completion = {},
                        sources = {},
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                        },
                    },
                },
            })
        end, { desc = "Start JDTLS" })
    end,
}
