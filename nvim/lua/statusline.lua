local function vcs()
    -- local status = ''
    local status = ''
    if vim.g.loaded_fugitive == 1  then
        status = status .. vim.fn.FugitiveHead()
    end
    if vim.g.loaded_lawrencium == 1 then
        status = status .. vim.fn['lawrencium#statusline']()
    end
    return status
end

local function change()
    local status = ''
    if vim.b.sy and vim.b.sy.stats then
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
    return '%l|%L %2v|%-2{virtcol("$") - 1}'
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

local function filetype()
    return vim.bo.ft
end

local function is_empty(str)
    return str == nil or string.len(str) == 0
end
local function fileIcon()
    if is_empty(vim.api.nvim_buf_get_name(0)) or not vim.g.nvim_web_devicons then
        return ""
    end
    return require("nvim-web-devicons").get_icon(vim.fn.expand("%"), nil, { default = true }) .. " "
end

local function matchup()
    if not vim.g.loaded_matchup then return '' end
    return vim.fn.MatchupStatusOffscreen()
end

local function firstLetter(str)
    return str:sub(1,1)
end

local function hl(g, s)
    if s ~= '' then return '%#' .. g .. '#' .. s  end
    return '%#' .. g .. '#'
end

local function bk(s) 
    if s ~= '' then return '[' .. s .. ']' end
    return s
end

local function lp(s) 
    if s ~= '' then return ' ' .. s end
    return s
end

local function sp(s) 
    if s ~= '' then return ' ' .. s .. ' ' end
    return s
end

local function createHl(name, from_name, def)  
    local current_def = vim.api.nvim_get_hl_by_name(from_name, true)
    local new_def = vim.tbl_extend('force', {}, current_def, def or {})
    vim.api.nvim_set_hl(0, name, new_def)
end

local StatusLine = {}

StatusLine.getActive = function()
    return table.concat({
        bk(
            hl('MyStatusLineBold', vcs()) ..
            change()
        ),
        hl('MyStatusLine', fileIcon() .. filename()),
        '%=',
        matchup(),
        hl('MyStatusLine', lsp_progress()),
        lsp_error(),
        filetype(),
        pos()
    }, ' ')
end

StatusLine.getInactive = function()
    return table.concat({
        bk(
            hl('MyStatusLineNcBold', vcs()) ..
            change()
        ),
        hl('MyStatusLineNc', filename())
    }, ' ')
end

StatusLine.update = vim.schedule_wrap(function()
    local id = vim.api.nvim_get_current_win()
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        if win_id == id then
            vim.wo[win_id].statusline = '%{%v:lua.StatusLine.getActive()%}'
        else
            vim.wo[win_id].statusline = '%{%v:lua.StatusLine.getInactive()%}'
        end
    end
end)

StatusLine.setHl = function()
    createHl('MyStatusLine', 'Identifier', { bg = "#2e3c43"})
    createHl('MyStatusLineBold', 'Identifier', { bold = true, bg = "#2e3c43" })
    createHl('MyStatusLineNc', 'Comment', { bg = "#263238"})
    createHl('MyStatusLineNcBold', 'Comment', { bold = true, bg = "#263238" })
end

StatusLine.setup = function()
    _G.StatusLine = StatusLine
    vim.o.laststatus =  2
    vim.cmd [[
        augroup MyStatusLine 
            autocmd!
            autocmd WinEnter,BufWinEnter *  call v:lua.StatusLine.update()
            autocmd ColorScheme * call v:lua.StatusLine.setHl()
        augroup END
    ]]
end

return StatusLine

