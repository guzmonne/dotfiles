local M = {}

--- Default executor for lua code
---@param block present.Block
local execute_lua_code = function(block)
  -- Override the default print function, to capture all of the output.
  -- Store the original print function.
  local original_print = print

  local output = {}

  -- Redefine the print function
  print = function(...)
    local args = { ... }
    local message = table.concat(vim.tbl_map(tostring, args), "\t")
    table.insert(output, message)
  end

  -- Call the provided function
  local chunk = loadstring(block.body)
  pcall(function()
    if not chunk then
      table.insert(output, "<<< BROKEN_CODE >>>")
    else
      chunk()
    end

    return output
  end)

  -- Restore the original print function.
  print = original_print

  return output
end

--- Default executor for Rust code
---@param block present.Block
local execute_rust_code = function(block)
  local tempfile = vim.fn.tempname() .. ".rs"
  local outputfile = tempfile:sub(1, -4)
  vim.fn.writefile(vim.split(block.body, "\n"), tempfile)
  local result = vim.system({ "rustc", tempfile, "-o", outputfile }, { text = true }):wait()
  if result.code ~= 0 then
    local output = vim.split(result.stderr, "\n")
    return output
  end
  result = vim.system({ outputfile }, { text = true }):wait()
  return vim.split(result.stdout, "\n")
end

--- Default executor for Bash code
---@param block present.Block
local execute_bash_code = function(block)
  local tempfile = vim.fn.tempname() .. ".sh"
  vim.fn.writefile(vim.split("#!/usr/bin/env bash\n\n" .. block.body, "\n"), tempfile)
  local execute = vim.system({ "/bin/chmod", "+x", tempfile }, { text = true }):wait()
  if execute.code ~= 0 then
    local output = vim.split(execute.stderr, "\n")
    return output
  end
  local result = vim.system({ tempfile }, { text = true }):wait()
  if result.code ~= 0 then
    return vim.split(result.stderr, "\n")
  end
  return vim.split(result.stdout, "\n")
end

M.create_system_executor = function(program)
  return function(block)
    local tempfile = vim.fn.tempname()
    vim.fn.writefile(vim.split(block.body, "\n"), tempfile)
    local result = vim.system({ program, tempfile }, { text = true }):wait()
    return vim.split(result.stdout, "\n")
  end
end

local options = {
  executors = {
    lua = execute_lua_code,
    javascript = M.create_system_executor("node"),
    python = M.create_system_executor("python"),
    rust = execute_rust_code,
    bash = execute_bash_code,
  },
}

M.setup = function(opts)
  opts = opts or {}
  opts.executors = opts.executors or {}

  opts.executors.lua = opts.executors.lua or options.executors.lua
  opts.executors.javascript = opts.executors.javascript or options.executors.javascript
  opts.executors.python = opts.executors.python or options.executors.python
  opts.executors.rust = opts.executors.rust or options.executors.rust
  opts.executors.bash = opts.executors.bash or options.executors.bash

  options = opts

  vim.api.nvim_create_user_command("PresentStart", function()
    M.start_presentation()
  end, {})
end

local function create_floating_window(config, enter)
  if enter == nil then
    enter = false
  end
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local win = vim.api.nvim_open_win(buf, enter, config)

  return { buf = buf, win = win }
end

---@class present.Slides
---@field slides present.Slide[]: The slides of the file

---@class present.Slide
---@field title string: The title of the slide
---@field body string[]: The body of the slide
---@field blocks present.Block[]: A codeblock inside of a slide

---@class present.Block
---@field language string: The language of the block
---@field body string: The body of the block

--- Takes some lines and parses them
---@param lines string[]: The lines in the buffer
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local default_slide = function()
    return { title = "", body = {}, blocks = {} }
  end

  local current_slide = default_slide()

  for _, line in ipairs(lines) do
    if line == "---" then
      table.insert(slides.slides, current_slide)
      current_slide = default_slide()
    else
      if line == "" and #current_slide.body == 0 then
        goto continue
      end

      if current_slide.title == "" then
        current_slide.title = line
        goto continue
      end

      table.insert(current_slide.body, line)
    end
    ::continue::
  end

  -- Always insert the last slide
  table.insert(slides.slides, current_slide)

  for _, slide in ipairs(slides.slides) do
    local block = { language = nil, body = "" }
    local inside_block = false

    for _, line in ipairs(slide.body) do
      if vim.startswith(line, "```") then
        if not inside_block then
          inside_block = true
          block.language = string.sub(line, 4)
        else
          inside_block = false
          block.body = vim.trim(block.body)
          table.insert(slide.blocks, block)
          block = { language = nil, body = "" }
        end
      else
        if inside_block then
          block.body = block.body .. line .. "\n"
        end
      end
    end
  end

  return slides
end

---@class present.Windows
---@field background vim.api.keyset.win_config: The background window.
---@field header vim.api.keyset.win_config: The header window.
---@field body vim.api.keyset.win_config: The body window.
---@field footer vim.api.keyset.win_config: The body window.

--- Creates the windows configuration object.
---@return present.Windows
local create_windows_configurations = function()
  local width = vim.o.columns
  local height = vim.o.lines

  return {
    background = {
      relative = "editor",
      width = width,
      height = height,
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      style = "minimal",
      col = 0,
      row = 0,
      zindex = 1,
    },
    header = {
      relative = "editor",
      width = width,
      height = 1,
      border = "rounded",
      style = "minimal",
      col = 1,
      row = 0,
      zindex = 2,
    },
    body = {
      relative = "editor",
      width = width,
      height = height - 5,
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      style = "minimal",
      col = 1,
      row = 4,
      zindex = 2,
    },
    footer = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      col = 1,
      row = height - 1,
      zindex = 3,
    },
  }
end

local state = {
  title = "",
  parsed = {},
  floats = {},
  current_slide = 1,
}

local present_keymap = function(mode, key, callback)
  vim.keymap.set(mode, key, callback, {
    buffer = state.floats.body.buf,
  })
end

local foreach_float = function(cb)
  for name, float in pairs(state.floats) do
    cb(name, float)
  end
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0

  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  state.parsed = parse_slides(lines)
  state.title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(opts.bufnr), ":t")

  local windows = create_windows_configurations()

  state.floats.background = create_floating_window(windows.background)
  state.floats.header = create_floating_window(windows.header)
  state.floats.body = create_floating_window(windows.body, true)
  state.floats.footer = create_floating_window(windows.footer)

  foreach_float(function(_, float)
    vim.bo[float.buf].filetype = "markdown"
  end)

  local set_slide_content = function(idx)
    local width = vim.o.columns
    local slide = state.parsed.slides[idx]

    local paginator = string.format("%d/%d", state.current_slide, #state.parsed.slides)

    local footer = state.title .. " [" .. paginator .. "]"
    local padding = string.rep(" ", (width - #footer) / 2)
    local padded_footer = padding .. footer

    vim.api.nvim_buf_set_lines(state.floats.header.buf, 0, -1, false, { slide.title })
    vim.api.nvim_buf_set_lines(state.floats.body.buf, 0, -1, false, slide.body)
    vim.api.nvim_buf_set_lines(state.floats.footer.buf, 0, -1, false, { padded_footer })
  end

  present_keymap("n", "n", function()
    state.current_slide = math.min((state.current_slide + 1), #state.parsed.slides)
    set_slide_content(state.current_slide)
  end)

  present_keymap("n", "p", function()
    state.current_slide = math.max((state.current_slide - 1), 1)
    set_slide_content(state.current_slide)
  end)

  present_keymap("n", "q", function()
    vim.api.nvim_win_close(state.floats.body.win, true)
  end)

  present_keymap("n", "X", function()
    local slide = state.parsed.slides[state.current_slide]
    local block = slide.blocks[1]

    if not block then
      print("No blocks on this page")
      return
    end

    local executor = options.executors[block.language]
    if not executor then
      print("No valid executor for this language")
      return
    end

    -- Table to capture print messages
    local output = { "# Code", "", "```" .. block.language }
    vim.list_extend(output, vim.split(block.body, "\n"))
    table.insert(output, "```")

    table.insert(output, "")
    table.insert(output, "# Output")
    table.insert(output, "")
    table.insert(output, "```")
    vim.list_extend(output, executor(block))
    table.insert(output, "```")

    local buf = vim.api.nvim_create_buf(false, true)
    local temp_width = math.floor(vim.o.columns * 0.8)
    local temp_height = math.floor(vim.o.lines * 0.8)
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      style = "minimal",
      width = temp_width,
      height = temp_height,
      row = math.floor((vim.o.lines - temp_height) / 2),
      col = math.floor((vim.o.columns - temp_width) / 2),
      noautocmd = true,
      border = "rounded",
    })

    vim.bo[buf].filetype = "markdown"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  end)

  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0,
    },
  }

  -- Set the options we want during presentation.
  for option, config in pairs(restore) do
    vim.opt[option] = config.present
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = state.floats.body.buf,
    callback = function()
      -- Reset the values when we are done with the presentation.
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end

      foreach_float(function(_, float)
        pcall(vim.api.nvim_win_close, float.win, true)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("present-resized", {}),
    callback = function()
      if not vim.api.nvim_win_is_valid(state.floats.body.win) or state.floats.body.win == nil then
        return
      end

      local updated = create_windows_configurations()
      foreach_float(function(name, float)
        vim.api.nvim_win_set_config(float.win, updated[name])
      end)

      set_slide_content(state.current_slide)
    end,
  })

  set_slide_content(state.current_slide)
end

-- M.start_presentation({
--   bufnr = 339,
-- })

M._parse_slides = parse_slides

return M
