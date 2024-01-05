-- prerequisite: install treesitter and vue syntax
-- local q = require "vim.treesitter.query"
local M = {}

M.i = function(value) print(vim.inspect(value)) end

M.get_vue_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "vue", {})
    local tree = parser:parse()[1]
    return tree:root()
end

M.get_js_root = function(script_txt)
    local parser = vim.treesitter
                       .get_string_parser(script_txt, "javascript", {})
    local tree = parser:parse()[1]
    return tree:root()
end

M.vue_query = vim.treesitter.query.parse("vue", [[
    (script_element (raw_text) @script)
]])

M.js_query = vim.treesitter.query.parse("javascript", [[
    (call_expression
       (member_expression
           property: (property_identifier) @p (#eq? @p "$emit"))
       (arguments (string (string_fragment) @event))
    )
]])

M.template_query = vim.treesitter.query.parse("vue", [[
 ((attribute_value) @attr (#contains? @attr "$emit"))
]])

M.template_js_query = vim.treesitter.query.parse("javascript", [[
     (call_expression
       function:(identifier) @f (#eq? @f "$emit")
       (arguments (string (string_fragment) @event)))
]])

M.set_event_from_query = function(js_txt, query, events)
    local js_root = M.get_js_root(js_txt)
    for _id, _node in query:iter_captures(js_root, js_txt, 0, -1) do
        local name = query.captures[_id]
        if (name == "event") then
            local evt = '"' .. vim.treesitter.get_node_text(_node, js_txt) ..
                            '"'
            events[evt] = true
        end
    end
end

M.get_emits = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local root = M.get_vue_root(bufnr)
    local events = {}
    for id, node in M.template_query:iter_captures(root, bufnr, 0, -1) do
        local attr = vim.treesitter.get_node_text(node, bufnr)
        M.set_event_from_query(attr, M.template_js_query, events)
    end
    for id, node in M.vue_query:iter_captures(root, bufnr, 0, -1) do
        local element_name = M.vue_query.captures[id]
        if (element_name == "script") then
            local script_txt = vim.treesitter.get_node_text(node, bufnr)
            M.set_event_from_query(script_txt, M.js_query, events)
        end
    end
    local event_keys = {}
    for k, v in pairs(events) do event_keys[#event_keys + 1] = k end
    local txt = "emits: [" .. table.concat(event_keys, ", ") .. "]"
    vim.api.nvim_paste(txt, 'CR', 1)
end

local t = function(s)
    return vim.api.nvim_replace_termcodes(s, true, true, true)
end

local keymap = function(mode, name, seq)
    vim.keymap.set(mode, '<Plug>'..name, function()
        if type(seq) == 'function' then
            seq()
        else
            seq = ':<c-u>let b:old_search=@/<cr>' .. seq  .. ':let @/=b:old_search<cr>'
            vim.fn.execute('norm! '..t(seq))
        end
        vim.fn['repeat#set'](t('<Plug>'..name), -1)
    end)
end

M.setup = function()
    keymap('n', 'VueEmit', M.get_emits)
    keymap('n', 'VueDotValue', 'df.ea.value<esc>')
    keymap('v', 'VueModelValue', 'gv:s/:value/:modelValue/g<cr>gv:s/@input/@update:modelValue/g<cr>')
    keymap('n', 'VueComputed', '^:silent! s/:\\s\\+.*{/(){<cr>iconst <esc>f(i = <esc>f(vf{%<Plug>VSurround)f(icomputed<esc>f{i=> <esc>f{%:silent! s/,\\?$/;/<cr>')
    keymap('n', 'VueMethod', '^:silent! s/:\\s\\+.*{/(){<cr>iconst <esc>f(i = <esc>f{i=> <esc>f{%:silent! s/,\\?$/;/<cr>')
    keymap('n', 'VueProps', '^iconst <esc>f:xi =<esc>f{<Plug>Ysurrounda})f(idefineProps<esc>f{%:s/,$/;<cr>')
    keymap('n', 'VueRef', '^:silent! s/,\\?$/;/<cr>iconst <esc>f:xi = <esc>w<Plug>Ysurroundt;)iref<esc>^')
    keymap('n', 'VueVModel', 'iv-model<esc>f.dt=<esc>')
    keymap('n', 'VueDeep', 'ctd:<esc>f v/.\\(,$\\|{$\\)\\@=<cr><Plug>VSurround)')
    keymap('n', 'VueDeep2', 'dw<esc>v/.\\(,$\\|{$\\)\\@=<cr><Plug>VSurround)i:deep<esc>')
    keymap('n', 'VueSlot', 'df=<Plug>Dsurround"dwvatV<Plug>VSurround<template v-slot:<c-r>-<cr>')
    keymap('n', 'VueSlot2', 'df=<Plug>Dsurround"dwva<V<Plug>VSurround<template v-slot:<c-r>-<cr>')
end

return M
