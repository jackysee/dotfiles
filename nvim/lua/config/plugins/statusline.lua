local function vcs()
    local status = ''
    if vim.g.loaded_fugitive == 1  then
        status = status .. vim.fn.FugitiveHead()
    end
    if vim.g.loaded_lawrencium == 1 then
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

local function lsp_progress()
    local lsp = vim.lsp.status()[1]
    if lsp then
        local name = lsp.name or ""
        local msg = lsp.message or ""
        local percentage = lsp.percentage or 0
        local title = lsp.title or ""
        return string.format(
            "%s: %s %s (%s%%%%) ",
            name,
            title,
            msg,
            percentage
        )
    end
    return ""
end

local function lsp_error()
    if not vim.tbl_isempty(vim.lsp.get_clients()) then
        local M = { E = "ERROR", W = "WARN", I = "INFO", H = "HINT" }
        local s = ""
        for k,v in pairs(M) do
            local list = vim.diagnostic.get(0,  { severity = vim.diagnostic.severity[v] })
            if #list > 0 then s = s .. k .. #list end
        end
        return s
    end
    return ""
end

local function pos()
    return '%l|%L│%2v|%-2{virtcol("$") - 1}'
end


local function filename()
    local filename = '[No Name]'
    if vim.fn.expand('%:t') ~= '' then
        filename = vim.fn.expand('%:p:.')
        local sep = vim.fn.has('win64') == 1 and '\\' or '/'
        local paths = vim.fn.split(filename, sep)
        if #paths > 4 then
            filename = '.../' .. vim.fn.join({unpack(paths, #paths-2, #paths)}, sep)
        end
    end
    if vim.bo.ft == 'help' then
        return filename
    end
    if vim.bo.readonly then
        filename = '!' .. filename
    end
    if vim.bo.modified then
        filename = filename .. '+'
    elseif not vim.bo.modifiable then
        filename = filename .. '-'
    end
    return filename
end

local function firstLetter(str)
    return str:sub(1,1)
end


return {
    'nvim-lualine/lualine.nvim',
    config = function()

        -- local theme = require('lualine.themes.palenight')
        -- theme.normal.y = { bg = theme.normal.c.bg }
        -- theme.insert.y = { bg = theme.normal.c.bg }
        -- theme.visual.y = { bg = theme.normal.c.bg }
        -- theme.replace.y = { bg = theme.normal.c.bg }
        -- theme.command.y = { bg = theme.normal.c.bg }
        -- theme.inactive.y = { bg = theme.normal.c.bg }

        require('lualine').setup({

            options = {
                -- theme = theme,
                theme  = 'material',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            },
            sections = {
                lualine_a = { { 'mode', fmt = firstLetter }},
                lualine_b = { vcs, },
                lualine_c = { filename },
                lualine_x = { 'MatchupStatusOffscreen' },
                lualine_y = { lsp_progress, lsp_error, 'filetype' },
                lualine_z = { pos },
            },
            inactive_sections = {
                lualine_c = { filename },
                lualine_x = { pos }
            }

        })
    end
}
