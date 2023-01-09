function fzf_yanky()
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
            ["--no-multi"] = "",
            ["--preview"] = f.shell.action(function(args) 
                return reg_escape(getContent(args).regcontents)
            end, nil, false)
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

return { fzf_yanky = fzf_yanky }
