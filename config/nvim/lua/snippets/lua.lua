local ls = require("luasnip")
-- Snippet creator
-- s(<trigger>, <nodes>)
local s = ls.s
-- Format nodes.
-- Takes a format string, and a list of nodes.
-- fmt(<fmt_string>, {...nodes})
local fmt = require("luasnip.extras.fmt").fmt

-- Insert nodes
-- Takes a position (like $1) and some optional default text.
-- i(<position>, [default_text])
local i = ls.insert_node
-- Takes a position and a list of possible options
-- c(<position>, {list, of, options)
local c = ls.choice_node
-- Takes a string to be used inside another node
-- t(<text>)
local t = ls.text_node
-- Takes a function that returns a string, and a list of arguments we want to pass to the function.
-- The arguments will be passed as a table.
-- f(<function>)
local f = ls.function_node
-- Takes a position, a function, and the list or arguments we want to pass to the function, and
-- returns a new snippet.
local d = ls.dynamic_node
-- Snippet Node returned by the Dynamic Node
local sn = ls.sn
-- Repeats a node
-- rep(<position>)
local rep = require("luasnip.extras").rep

--
local function split_input_node(input)
    if (input == nil) then input = 1 end
    return f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts] or ""
    end, {input})
end

local req = s("req", fmt([[
    local is_{}_installed, {} = pcall(require, "{}")
    if not is_{}_installed then return end
]], {split_input_node(1), split_input_node(1), i(1), split_input_node(1)}))

---
return {req}
