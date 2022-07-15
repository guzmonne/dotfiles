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
-- Takes a function that returns a string
-- f(<function>)
local f = ls.function_node
-- Repeats a node.
-- rep(<position>)
local rep = require("luasnip.extras").rep

-- Exported table

local curtime = s("curtime", f(function()
    return os.date "%Y-%m-%d %H:%M"
end))

---
return {curtime}
