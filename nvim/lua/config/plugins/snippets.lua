

return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    -- build = "make install_jsregexp",
    event = 'InsertCharPre',
    config = function()
        local ls = require('luasnip')
        vim.keymap.set({"i"}, "<C-e>", function() ls.expand() end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-k>", function() ls.jump(-1) end, {silent = true})
        -- vim.cmd [[ imap <silent><expr> <C-e> luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '<C-e>' ]]
        -- vim.cmd [[ imap <silent><expr> <C-j> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Plug>luasnip-expand-or-jump' ]]
        -- vim.cmd [[ imap <silent><expr> <C-k> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-k>' ]]
        --
        ls.config.set_config {
            history = true,
            -- updateevents = 'TextChanged,TextChangedI',
            store_selection_keys = '<Tab>'
        }
        ls.filetype_extend('vue', {'html', 'javascript', 'css'})
        ls.filetype_extend('typescript', { 'javascript'})
        ls.filetype_extend('typescriptreact', { 'javascript'})
        require('luasnip/loaders/from_vscode').lazy_load();
        require('luasnip/loaders/from_vscode').lazy_load({ paths = { './snippets' } });
        require('snippets/javascript');
    end

}
