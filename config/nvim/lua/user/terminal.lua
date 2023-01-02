local M = {}
--
local is_term_installed, term = pcall(require, "harpoon.term")
if not is_term_installed then return end

local is_functions_installed, functions = pcall(require, "user.functions")
if not is_functions_installed then return end

local get_text = functions.get_text

-- echo something
M.run = function()
    term.sendCommand(1, get_text() .. "\n")
end

-- Exports
return M

