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
-- Repeats a node.
-- rep(<position>)
local rep = require("luasnip.extras").rep

-- Exported table

local todo = s("todo", fmt("// {}: {}", {c(1, {t "TODO", t "FIXME", t "WARNING"}), i(2, "Description")}))

---
return {todo}

