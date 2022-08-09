local M = {}
--

function catch(what)
    return what[1]
end

function try(what)
    status, result = pcall(what[1])
    if not status then what[2](result) end
    return result
end

function get_range_text()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
    return table.concat(lines, '\n')
end

function get_lines_text()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)
    return table.concat(lines, '\n')
end

function get_text()
    local result = ""
    try {
        function()
            result = get_range_text()
            return
        end, catch {
            function(error)
                result = get_lines_text()
            end
        }
    }
    return result
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function reload()
    print("Reloading:")
    for k in pairs(package.loaded) do
        if k:match("^user") then
            print("  - " .. k)
            package.loaded[k] = nil
            require(k)
        end
    end
end

-- Opens Neotree on the current's file directory or the current working directory if the active
-- buffer is not a file.
--
function neotree_open_current()
    args = {}

    args.dir = vim.fn.expand("%:p:h")

    file = vim.fn.expand("%:p")

    if file ~= "" then
        args.reveal_file = file
        args.reveal_force_cwd = true
    end

    require("neo-tree.command").execute(args)
end

-- Exports
M["catch"] = catch
M["try"] = try
M["get_range_text"] = get_range_text
M["get_lines_text"] = get_lines_text
M["get_text"] = get_text
M["dump"] = dump
M["reload"] = reload
M["neotree_open_current"] = neotree_open_current

return M

