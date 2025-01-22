
local fzf_spec = function()
    if vim.fn.isdirectory(vim.env.HOME .. '/.zplugin/plugins/junegunn---fzf') then
        return {
            name = 'junegunn/fzf',
            dir = '~/.zplugin/plugins/junegunn---fzf',
            event = 'BufWinEnter'
        }
    else
        return { 'junegunn/fzf', event = 'BufWinEnter' }
    end
end

function yanky()
    local f = require('fzf-lua');
    local contents = require('yanky.history').all()

    local function reg_escape(reg, nl)
        if not reg then return end
        local gsub_map = {
            ["\3"]  = "^C", -- <C-c>
            ["\27"] = "^[", -- <Esc>
            ["\18"] = "^R", -- <C-r>
        }
        for k, v in pairs(gsub_map) do
            reg = reg:gsub(k, f.utils.ansi_codes.magenta(v))
        end
        return not nl and reg or
            reg:gsub("\n", f.utils.ansi_codes.magenta("\\n"))
    end

    local function getContent(args)
        local r = string.match(args[1], "^%d+")
        return contents[tonumber(r)]
    end

    local entries = {};
    for k,v in ipairs(contents) do
        table.insert(
            entries, 
            f.utils.ansi_codes.yellow(tostring(k)) .. " " .. 
            reg_escape(v.regcontents, true)
        )
    end

    local opts = {
        fzf_opts = {
            ["--no-multi"] = '',
            ["--preview"] = function(args) 
                return reg_escape(getContent(args).regcontents)
            end
        },
        actions = {
            ["default"] = function(args)
                require('yanky.picker').actions.put('p')(getContent(args))
            end
        },
        prompt = "Yanky❯ "
    }
    f.fzf_exec(entries, opts)
end

function persistence_session()
    local f = require('fzf-lua');
    local p = require('persistence')
    local dir = require('persistence.config').options.dir
    local list = p.list() 
    local entries = {}
    for k,v in ipairs(list) do
        table.insert(entries, (v:gsub(dir, ''):gsub('%%', '/')))
    end

    local opts = {
        fzf_opts = { ["--no-multi"] = "" },
        actions = {
            ["default"] = function(args)
                local sfile = dir .. (args[1]:gsub('/', '%%'))
                if sfile and vim.fn.filereadable(sfile) ~= 0 then
                   vim.cmd("silent! source " .. vim.fn.fnameescape(sfile))
                end
            end
        },
        prompt = "Sessions❯ "
    }
    f.fzf_exec(entries, opts)
end

return {

    fzf_spec(),
    {
        'ibhagwan/fzf-lua',
        event = 'BufWinEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'junegunn/fzf' },
        config = function()
            vim.env.FZF_DEFAULT_OPTS = ' --reverse' 
            local f = require('fzf-lua');
            local files = function(txt)
                -- f.files({ fzf_opts = { ['--query'] = vim.fn.shellescape(txt) } })
                f.files({ fzf_opts = { ['--query'] = txt } })
            end
            f.setup({
                winopts = { height=0.9, width=0.9 },
                files = { actions = { ['ctrl-x'] = f.actions.file_split } },
                defaults = {
                    git_icons = false,
                    file_icons = false
                }
            })
            vim.keymap.set('n', '<leader>ff', f.files, { silent = true, desc = 'fzf files' })
            vim.keymap.set('n', '<leader>F', function() files("'"..vim.fn.expand('<cword>')) end, { silent = true, desc = 'exact file match <cword>'});
            vim.keymap.set('v', '<leader>F', function() files("'"..f.utils.get_visual_selection()) end, { silent = true, desc = 'exact file match selection' });
            vim.keymap.set('n', '<leader>bb', f.buffers, { silent = true, desc = 'buffers' })
            vim.keymap.set('n', '<leader>bl', f.blines, { silent = true, desc = 'blines' })
            vim.keymap.set('n', '<leader>fo', f.oldfiles, { silent = true, desc = 'oldfiles' })
            vim.keymap.set('n', '<leader>fm', 
                function() 
                    f.oldfiles({ 
                        cwd = vim.loop.cmd,
                        cwd_header = true,
                        cwd_only = true
                    }) 
                end, 
                { silent = true, desc = 'oldfiles' })
            vim.keymap.set('n', '<leader>lg', f.live_grep_glob, { silent = true, desc = 'livegrep' })
            vim.keymap.set('n', '<leader>rg', f.grep_cword, { silent = true, desc = 'rg <cword>' })
            vim.keymap.set('v', '<leader>rg', f.grep_visual, { silent = true, desc = 'rg selection' })
            vim.keymap.set('n', '<leader>z', ':FzfLua ', { desc = 'cmd :FzfLua '});
            vim.api.nvim_create_user_command('Rg', function(opts) f.grep_project({ search = opts.args }) end, { nargs = '*'})
            vim.keymap.set('n', '<leader>fy', function() yanky() end, { silent = true, desc = 'yank ring history' })
            vim.keymap.set('n', '<leader>fs', function() persistence_session() end, { silent = true, desc = 'sessions' })
            vim.keymap.set('n', '<leader>fh', f.help_tags, { silent = true, desc = 'help tags' })
            vim.keymap.set('n', '<leader>fr', f.registers, { silent = true, desc = 'registers' })
        end
    }
}
