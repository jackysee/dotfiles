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
        if _ ~= 1 or (_ == 1 and v:gsub("%s+", "") ~= "" ) then
            table.insert(l, '|'..v..string.rep(' ', len - #v)..' |')
        end
    end
    table.insert(l, '*'..string.rep('-',len+1)..'*')
    for _,v in ipairs(cow) do 
        table.insert(l, v) 
    end
    return l
end

M.vtext = function()
    vim.cmd [[ normal! : ]] --to update visual marks using command mode
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    local lines = vim.fn.getline(vstart[2], vend[2])
    if #lines == 0 then return "" end
    local txt = ""
    for k,v in ipairs(lines) do
        local i = k == 1 and vstart[3] or 1
        local j = #lines == k and vend[3] or nil
        if vim.o.selection == "exclusive" and j ~= nil then j = j - 1 end
        txt = txt .. v.sub(v, i, j)
    end
end

return M
