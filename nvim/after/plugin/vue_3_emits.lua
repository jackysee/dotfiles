-- prerequisite: install treesitter and vue syntax
local q = require "vim.treesitter.query"

local function i(value) print(vim.inspect(value)) end

local get_vue_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "vue", {})
    local tree = parser:parse()[1]
    return tree:root()
end

local get_js_root = function(script_txt)
    local parser = vim.treesitter
                       .get_string_parser(script_txt, "javascript", {})
    local tree = parser:parse()[1]
    return tree:root()
end

local vue_query = vim.treesitter.parse_query("vue", [[
    (script_element (raw_text) @script)
]])

local js_query = vim.treesitter.parse_query("javascript", [[
    (call_expression
       (member_expression
           property: (property_identifier) @p (#eq? @p "$emit"))
       (arguments (string (string_fragment) @event))
    )
]])

local template_query = vim.treesitter.parse_query("vue", [[
 ((attribute_value) @attr (#contains? @attr "$emit"))
]])

local template_js_query = vim.treesitter.parse_query("javascript", [[
     (call_expression
       function:(identifier) @f (#eq? @f "$emit")
       (arguments (string (string_fragment) @event)))
]])

local set_event_from_query = function(js_txt, query, events)
    local js_root = get_js_root(js_txt)
    for _id, _node in query:iter_captures(js_root, js_txt, 0, -1) do
        local name = query.captures[_id]
        if (name == "event") then
            local evt = '"' .. vim.treesitter.get_node_text(_node, js_txt) ..
                            '"'
            events[evt] = true
        end
    end
end

local get_emits = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local root = get_vue_root(bufnr)
    local events = {}
    for id, node in template_query:iter_captures(root, bufnr, 0, -1) do
        local attr = vim.treesitter.get_node_text(node, bufnr)
        set_event_from_query(attr, template_js_query, events)
    end
    for id, node in vue_query:iter_captures(root, bufnr, 0, -1) do
        local element_name = vue_query.captures[id]
        if (element_name == "script") then
            local script_txt = vim.treesitter.get_node_text(node, bufnr)
            set_event_from_query(script_txt, js_query, events)
        end
    end
    local event_keys = {}
    for k, v in pairs(events) do event_keys[#event_keys + 1] = k end
    local txt = "emits: [" .. table.concat(event_keys, ", ") .. "]"
    vim.api.nvim_paste(txt, 'CR', 1)
end

vim.api.nvim_create_user_command("VueEmits", function() get_emits() end, {})
