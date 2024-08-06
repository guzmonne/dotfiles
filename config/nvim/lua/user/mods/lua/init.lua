local M = {
  opts = {},
}

local function get_visual_selection()
  local _, line_start, col_start = unpack(vim.fn.getpos("'<"))
  local _, line_end, col_end = unpack(vim.fn.getpos("'>"))

  -- Get lines in range from buffer
  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

  -- If it's a single line selection, just slice the line text
  if #lines == 1 then
    lines[1] = lines[1]:sub(col_start, col_end)
  else
    -- For multiline selection; handle start and end lines separately
    lines[1] = lines[1]:sub(col_start)
    lines[#lines] = lines[#lines]:sub(1, col_end)
  end

  return table.concat(lines, "\n")
end

local function call_external_process(selection)
  local file = io.popen("mods", "w")

  if not file then
    print("Failed to open file")
    return
  end

  file:write(selection)
  file:close()

  local handle = io.popen("some_command", "r")

  if not handle then
    print("Failed to open file")
    return
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

local function replace_visual_with_output(output)
  vim.cmd("normal! gv") -- Re-select the visual selection
  vim.fn.setreg('"', output)
  vim.cmd('normal! gvd"')
end

function M:complete()
  local selection = get_visual_selection()
  local result = call_external_process(selection)
  replace_visual_with_output(result)
end

function M.setup(plugin_opts)
  for k, v in pairs(plugin_opts) do
    M.opts[k] = v
  end

  -- Create custom user command "ProcessSelection"
  vim.api.nvim_create_user_command("ProcessSelection", function()
    M:complete()
  end, { range = true, desc = "Process visual selection and replace with command output" })
end

return M
