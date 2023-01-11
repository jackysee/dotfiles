local M = {}

local cow = {
    [[       o                     ]],
    [[        o   ^__^             ]],
    [[         o  (oo)\_______     ]],
    [[            (__)\       )\/\ ]],
    [[                 ||----w |   ]],
    [[                 ||     ||   ]]
}

M.cowsay = function(lines) 
    local len = 0
    for _,v in ipairs(lines) do
        len = math.max(#v, len)
    end
    local l = {}
    table.insert(l, '*'..string.rep('-',len+1)..'*')
    for _,v in ipairs(lines) do
        if _ ~= 1 then
            table.insert(l, '|'..v..string.rep(' ', len - #v)..' |')
        end
    end
    table.insert(l, '*'..string.rep('-',len+1)..'*')
    for _,v in ipairs(cow) do 
        table.insert(l, v) 
    end
    return l
end

return M
