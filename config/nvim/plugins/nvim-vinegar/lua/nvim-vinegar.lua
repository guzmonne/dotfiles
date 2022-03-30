local M = {}

function M.fnameescape(file)
    if vim.fn.exists('*fnameescape') then
        return vim.fn.fnameescape(file)
    else
        return vim.fn.escape(file, " \t\n*?[{`$\\%#'\"|!<")
    end
end

local dotfiles = let s:dotfiles = '\(^\|\s\s\)\zs\.\S\+'
local escape = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'

return M
