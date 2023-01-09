function setup()
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
            lualine_x = { 'MatchupStatusOffscreen', 'diagnostics', 'filetype' },
            lualine_y = { 'location' },
            lualine_z = { 'progress' }
        },
        options = { section_separators = '', component_separators = '' }
    })
end

return { setup = setup }
