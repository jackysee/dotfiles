
-- local use_colorscheme = 'nightfox'
-- local use_colorscheme = 'flexoki'
-- local use_colorscheme = 'catppuccin-macchiato'
local use_colorscheme = 'rosebones'
local cs = function(repo, scheme, cb, dependencies)
    local load = use_colorscheme == scheme
    local event = 'VeryLazy'
    if load == true then event = nil end
    return {
        repo,
        dependencies = dependencies,
        event = event,
        config = function()
            if load then
                if cb then cb() end
                vim.cmd('colorscheme '..scheme)
                vim.cmd('set termguicolors')
            end
        end
    }
end


return {
    cs('romainl/Apprentice', 'Apprentice'),
    cs('haishanh/night-owl.vim', 'night-owl'),
    cs('folke/tokyonight.nvim', 'tokyonight'),
    cs('EdenEast/nightfox.nvim', 'nightfox'),
    cs('whatyouhide/vim-gotham', 'gotham'),
    cs('JoosepAlviste/palenightfall.nvim', 'palenightfall'),
    cs('sainnhe/gruvbox-material', 'gruvbox-material', function()
        vim.g.gruvbox_material_background = 'hard'
        vim.g.gruvbox_material_better_performance = 1
    end),
    cs('sainnhe/edge', 'edge'),
    cs('stevedylandev/flexoki-nvim', 'flexoki'),
    cs('catppuccin/nvim', 'catppuccin-macchiato'),
    cs('mcchrish/zenbones.nvim', 'rosebones', nil, 'rktjmp/lush.nvim')
}
