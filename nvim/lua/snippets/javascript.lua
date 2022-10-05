local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda

local javascript = {
    s({trig = "set", name = "set", dscr = "vuex setter"}, {
        t("set"), l(l._1:gsub("^%l", string.upper), 1), t("(state, val) { "),
        t({"", ""}), t("    state."), i(1), t(" = val;"), t({"", ""}), t("}")
    })
}

ls.snippets = {javascript = javascript}
