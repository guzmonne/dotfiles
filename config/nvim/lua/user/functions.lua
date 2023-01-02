local M = {}

--- Dumps the content of a table as a string.
-- @param o {table} Table to dump.
local function dump(o)
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

--- Function that can be used in tandem with the `try` function to emulate `try-catch` mechanics
-- in lua. It's ment to be used inside a call to `try`.
--
-- @example
-- ```lua
-- try {
--    function()
--        -- Do something that can fail.
--    end, catch {
--        function()
--            -- Recover from the error.
--        end
--    }
-- }
-- ```
-- @param what {table} Table that holds the `catch` logic.
local function catch(what)
    return what[1]
end

--- Function that can be used in tandem with the `catch` function to emulate `try-catch` mechanics
-- in lua. It's ment to be used by calling the `catch` function as the second value of a table.
--
-- @example
-- ```lua
-- try {
--    function()
--        -- Do something that can fail.
--    end, catch {
--        function()
--            -- Recover from the error.
--        end
--    }
-- }
-- ```
-- @param what {table} Table that holds the `try-catch` logic. The first element should be a function with
--             the logic that we want to execute. The second one should be a function with the
--             recover logic, wrapped around the `catch` function.
local function try(what)
    local status, result = pcall(what[1])
    if not status then what[2](result) end
    return result
end

--- Returns the value of the text currently highlighted in visual mode.
local function get_range_text()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
    return table.concat(lines, '\n')
end

--- Returns the value of the text currently highlighted in visual mode under multiple lines.
local function get_lines_text()
    local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)
    return table.concat(lines, '\n')
end

--- Returns the value of the text currently highlighted in visual mode.
function M.get_text()
    local result = ""
    try {
        function()
            result = get_range_text()
        end, catch {
            function()
                result = get_lines_text()
            end
        }
    }
    return result
end

--- Function to reload all Lua functions inside the `lua/user` directory.
function M.reload()
    print("Reloading:")
    for k in pairs(package.loaded) do
        if k:match("^user") then
            print("  - " .. k)
            package.loaded[k] = nil
            require(k)
        end
    end
end

--- Opens Neotree on the current's file directory or the current working directory if the active
-- buffer is not a file.
function M.neotree_open_current()
    local args = {}

    args.dir = vim.fn.expand("%:p:h")

    local file = vim.fn.expand("%:p")

    if file ~= "" then
        args.reveal_file = file
        args.reveal_force_cwd = true
    end

    require("neo-tree.command").execute(args)
end

--- Opens a floating window in the middle of the current window.
-- @param width {number?} Width of the floating window.
-- @param height {number?} Height of the floating window.
function M.open_window(width, height)
    -- Set default varres
    width = width or 50
    height = height or 10

    -- Get the current window
    local current_window = vim.api.nvim_get_current_win()

    -- Get the dimensions of the current window
    local current_window_width = vim.api.nvim_win_get_width(current_window)
    local current_window_height = vim.api.nvim_win_get_height(current_window)

    -- Calculate the position of the floating window
    local floating_window_row = math.floor((current_window_height - height) / 2)
    local floating_window_col = math.floor((current_window_width - width) / 2)

    -- Create the floating window
    local window = vim.api.nvim_open_win(0, false, {
        relative = 'win',
        width = width,
        height = height,
        row = floating_window_row,
        col = floating_window_col
    })

    return window
end

--- Runs `vim.inspect` over the provided value.
-- @param stats {any} Value to inspect.
function M.inspect(stats)
    vim.notify(vim.inspect(stats))
end

--- Splits a string into a table of strings separated by a `separator` string.
-- @param input {string} Input string
-- @param separator {string?} Separator string
-- @return {table} The input string split into multiple strings.
function M.split(input, separator)
    input = input or ""
    separator = separator or "%s"
    local result = {}
    for field, _ in string.gmatch(input, "[^" .. separator .. "]+") do table.insert(result, field) end
    return result
end

--- Void function to use as placeholder on other functions
function M.void()
end

-- Export additional local functions
M["catch"] = catch
M["try"] = try
M["dump"] = dump

--
return M
