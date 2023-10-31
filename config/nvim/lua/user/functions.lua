local M = {}

--- Gets, at most, the next `n` remaining words from the current cursor position in the current line.
-- @param n {number} Number of words to get.
-- @return {table} The next `n` words if they exist.
local function get_current_line_remaining_words(n)
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local words = {}
  for w in line:sub(col):gmatch("%S+") do
    table.insert(words, w)
    if #words >= n then break end
  end

  return words
end

--- Gets the, at most, previous `n` remaining words from the current cursor position in the current
--- line.
-- @param n {number} Number of words to get.
-- @return {table} The previous `n` words if they exist.
local function get_current_line_previous_words(n)
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  if col > 1 then
    col = col - 1
  end

  local words = {}
  for w in line:sub(1, col):gmatch("%S+") do
    table.insert(words, w)
    if #words >= n then break end
  end

  return words
end

--- Slices a table.
-- @param t {table} Table to slice.
-- @param start {number} Start index.
-- @param end {number} End index.
-- @return {table} The sliced table.
function M.slice_table(t, from, to)
  local r = {}
  if from == nil then from = 1 end
  if to == nil then to = #t end
  for i = from, to do
    r[#r + 1] = t[i]
  end
  return r
end

--- Reverse a table.
-- @param t {table} Table to reverse.
-- @return {table} The reversed table.
function M.reverse_table(t)
  local r = {}
  for i = #t, 1, -1 do
    table.insert(r, t[i])
  end
  return r
end

--- Reverse a string
-- @param s {string} String to reverse.
-- @return {string} The reversed string.
function M.reverse(s)
  local r = ""
  for i = #s, 1, -1 do
    r = r .. s:sub(i, i)
  end
  return r
end

--- Gets up to the last n words if they exist.
--@param from_line {number} Line to start searching from.
--@param n {number} Number of words to get.
--@return {table} The last n words if they exist.
local function get_prev_n_words(from_line, n)
  -- Get previous n words from the current line, starting from the cursor position
  local words = get_current_line_previous_words(n)

  -- Revert words order
  words = M.reverse_table(words)

  -- If the number of words is less than `n`, we need to look for the remaining words in the next
  -- non empty line.
  while #words < n do
    -- Get the previous non empty line
    from_line = vim.fn.prevnonblank(from_line - 1)

    if from_line == 0 then return words end

    -- Insert new line
    table.insert(words, "\n")

    local line = vim.api.nvim_buf_get_lines(0, from_line - 1, from_line, false)[1]
    local line_table = M.split(line, " ")
    line_table = M.reverse_table(line_table)
    line = table.concat(line_table, " ")
    for w in line:sub(1):gmatch("%S+") do
      table.insert(words, w)
      if #words >= n then break end
    end
  end

  words = M.reverse_table(words)

  return words
end

--- Gets up to the next n words if they exist.
-- @param from_line {number} Line to start searching from.
-- @param n {number} Number of words to get.
-- @return {table} The next n words if they exist.
local function get_next_n_words(from_line, n)
  -- Get next n words from the current line, starting from the cursor position
  local words = get_current_line_remaining_words(n)

  -- If the number of words is less than `n`, we need to look for the remaining words in the next
  -- non empty line.
  while #words < n do
    -- Get the next non empty line
    from_line = vim.fn.nextnonblank(from_line + 1)

    if from_line == 0 then return words end

    -- Insert new line
    table.insert(words, "\n")

    local line = vim.api.nvim_buf_get_lines(0, from_line - 1, from_line, false)[1]
    for w in line:sub(1):gmatch("%S+") do
      table.insert(words, w)
      if #words >= n then break end
    end
  end

  return words
end

--- Gets the words around the cursor.
-- @param max_previous_words {number?} Maximum number of words to get before the cursor.
-- @param max_next_words {number?} Maximum number of words to get after the cursor.
local function get_words_around_cursor(max_previous_words, max_next_words)
  -- Get cursor coordinates
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- Get prev words
  local prev_words = get_prev_n_words(line, max_previous_words)

  -- Get next words
  local next_words = get_next_n_words(line, max_next_words)

  return prev_words, next_words
end

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


-- @param what {table} Table that holds the `catch` logic.
local function catch(what)
  return what[1]
end

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

--- Splits a string into a table of strings separated by a newline including individual newlines.
-- @param input {string} Input string
-- @return {table} The input string split into multiple strings.
function M.split_newline(input)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(input, "\n", from)
  while delim_from do
    table.insert(result, string.sub(input, from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = string.find(input, "\n", from)
  end
  table.insert(result, string.sub(input, from))
  return result
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
M["get_words_around_cursor"] = get_words_around_cursor

--
return M
