---@class mods
local M = {}
local Job = require("plenary.job")

-- Table that will hold the functions for the users to consume.
M.fn = {}

-- Gets all the buffer line until the current cursor position.
function M.get_lines_until_cursor()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_window = vim.api.nvim_get_current_win()
  local cursor_position = vim.api.nvim_win_get_cursor(current_window)

  local row = cursor_position[1]

  local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, row, true)

  return table.concat(lines, "\n")
end

-- Gets the current visual selection.
function M.get_visual_selection()
  local _, srow, scol = unpack(vim.fn.getpos("v"))
  local _, erow, ecol = unpack(vim.fn.getpos("."))

  if vim.fn.mode() == "V" then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  if vim.fn.mode() == "v" then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  if vim.fn.mode() == "\22" then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
    return lines
  end
end

-- Makes the `mods` arguments tablr
---@param opts mods.Options `mods` options configuration.
---@param prompt string The prompt to use.
function M.make_mods_spec_args(opts, prompt)
  assert(opts.api, "Mods API option can't be undefined")
  assert(opts.model, "Mods Model option can't be undefined")
  assert(opts.role, "Mods Role option can't be undefined")

  local args = { "--api", opts.api, "--model", opts.model, "--role", opts.role, "--tty" }

  if opts.format and opts.format_as ~= nil then
    table.insert(args, "--format")
    table.insert(args, "--format-as")
    table.insert(args, opts.format_as)
  end
  if opts.continue then
    table.insert(args, "--continue")
  end
  if opts.continue_last then
    table.insert(args, "--continue_last")
  end
  if opts.title then
    table.insert(args, "--title")
    table.insert(args, opts.title)
  end
  if opts.max_retries then
    table.insert(args, "--max-retries")
    table.insert(args, opts.max_retries)
  end
  if opts.no_limit then
    table.insert(args, "--no-limit")
  end
  if opts.max_tokens then
    table.insert(args, "--max-tokens")
    table.insert(args, opts.max_tokens)
  end
  if opts.word_wrap then
    table.insert(args, "--word-wrap")
    table.insert(args, opts.word_wrap)
  end
  if opts.temp then
    table.insert(args, "--temp")
    table.insert(args, opts.temp)
  end
  if opts.stop then
    table.insert(args, "--stop")
    table.insert(args, opts.stop)
  end
  if opts.topp then
    table.insert(args, "--topp")
    table.insert(args, opts.topp)
  end
  if opts.no_cache then
    table.insert(args, "--no-cache")
  end

  table.insert(args, prompt)

  return args
end

-- Writes a string where the current cursor lies.
---@param str string The string to write.
function M.write_string_at_cursor(str)
  if str == nil then
    vim.print("str is nil")
    return
  end

  vim.schedule(function()
    local current_window = vim.api.nvim_get_current_win()
    if current_window == nil then
      vim.print("Current window is nil")
      return
    end

    local cursor_position = vim.api.nvim_win_get_cursor(current_window)
    local row, col = cursor_position[1], cursor_position[2]

    vim.print({ row, col })

    local lines = vim.split(str, "\n")

    vim.cmd("undojoin")
    vim.api.nvim_put(lines, "c", true, true)

    local num_lines = #lines
    local last_line_length = #lines[num_lines]

    vim.api.nvim_win_set_cursor(current_window, { row + num_lines - 1, col + last_line_length })
  end)
end

-- Gets the prompt.
---@param opts mods.Options `mods` options configuration.
local function get_prompt(opts)
  local replace = opts.replace
  local visual_lines = M.get_visual_selection()
  local prompt = ""

  if visual_lines then
    prompt = table.concat(visual_lines, "\n")
    if replace then
      vim.api.nvim_command("normal! d")
      vim.api.nvim_command("normal! k")
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
    end
  else
    prompt = M.get_lines_until_cursor()
  end

  return prompt
end

local group = vim.api.nvim_create_augroup("ModsLLMAutoGroup", { clear = true })
local active_job = nil

-- Invokes `mods` and streams its output to the editor.
function M.invoke_mods_and_stream_into_editor(opts)
  vim.api.nvim_clear_autocmds({ group = group })

  local prompt = get_prompt(opts)
  local args = M.make_mods_spec_args(opts, prompt)

  vim.print(prompt)
  vim.print(active_job)

  if active_job then
    active_job:shutdown()
    active_job = nil
  end

  local function parse_and_call(chunk)
    vim.print(chunk)
    M.write_string_at_cursor(chunk)
  end

  vim.print(args)

  active_job = Job:new({
    command = "mods",
    args = args,
    on_stdout = function(_, chunk)
      parse_and_call(chunk)
    end,
    on_exit = function()
      active_job = nil
    end,
  })

  active_job:start()

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "ModsLLMEscape",
    callback = function()
      if active_job then
        active_job:shutdown()
        print("Mods streaming cancelled")
        active_job = nil
      end
    end,
  })

  vim.api.nvim_set_keymap("n", "<Esc>", ":doautocmd User ModsLLMEscape<CR>", { noremap = true, silent = true })

  return active_job
end

M.version = "0.1.0" -- x-release-please-version

---@class mods.Opts
local defaults = {}

---@type mods.Opts
M.options = nil

M.loaded = false

---@param opts? mods.Opts
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  local function load()
    if M.loaded then
      return
    end

    vim.print("Mods")

    for key, nestedTable in pairs(M.options) do
      vim.print(key)
      M.fn[key] = function()
        M.invoke_mods_and_stream_into_editor(nestedTable)
      end
    end

    M.loaded = true

    vim.print(M)
  end

  load = vim.schedule_wrap(load)

  if vim.v.vim_did_enter == 1 then
    load()
  else
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = load })
  end

  vim.api.nvim_create_user_command("Mods", function(cmd)
    M.fn[cmd.args]()
  end, { nargs = "*" })
end

return M
