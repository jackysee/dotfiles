return {
    -- "jose-elias-alvarez/null-ls.nvim",
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup {
            debug = true,
            sources = {
                null_ls.builtins.formatting.prettier.with({
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
                require('none-ls.diagnostics.eslint_d').with({
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
                        ".eslintrc.json"
                        -- "package.json"
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
}
