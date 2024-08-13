-- Dependencies
local tasker = require("tasker")
local helpers = require("helpers")

-- Module definition
local Mods = {}
local H = {}

--- Module setup
---
---@param config table|nil Module config table.
---
---@usage >lua
---    require('mods').setup() -- Use default config
---    -- OR
---    require('mods').setup({}) -- Replace {} with your config table.
--- <
Mods.setup = function(config)
  -- Export module
  _G.Mods = Mods

  -- Setup config
  config = H.setup_config(config)
end

Mods.run = function(prompt)
  local buf = 0
  local mods_params = { prompt }

  local qid = helpers.uuid()
  tasker.set_query(qid, {
    timestamp = os.time(),
    buf = buf,
    handler = handler,
    on_exit = on_exit,
    raw_response = "",
    response = "",
    first_line = -1,
    last_line = -1,
    ns_id = nil,
    ex_id = nil,
  })

  local out_reader = function()
    local buffer = ""

    -- Closure for uv.read_start(stdout, fn)
    return function(err, chunk) end
  end

  tasker.run(buf, "mods", mods_params, nil, out_reader(), nil)
end

--- Module config
Mods.config = {
  default_api = "openai",
  default_model = "gpt4o",
}

-- Helper targets
H.Target = {
  rewrite = 0, -- for replacing the selection, range or the current line
  append = 1, -- for appending after the selection, range or the current line
  prepend = 2, -- for prepending before the selection, range or the current line
  popup = 3, -- for writing into the popup window

  -- for writing into a new buffer
  ---@param filetype nil | string # nil = same as the original buffer
  ---@return table # a table with type=4 and filetype=filetype
  enew = function(filetype)
    return { type = 4, filetype = filetype }
  end,

  --- for creating a new horizontal split
  ---@param filetype nil | string # nil = same as the original buffer
  ---@return table # a table with type=5 and filetype=filetype
  new = function(filetype)
    return { type = 5, filetype = filetype }
  end,

  --- for creating a new vertical split
  ---@param filetype nil | string # nil = same as the original buffer
  ---@return table # a table with type=6 and filetype=filetype
  vnew = function(filetype)
    return { type = 6, filetype = filetype }
  end,

  --- for creating a new tab
  ---@param filetype nil | string # nil = same as the original buffer
  ---@return table # a table with type=7 and filetype=filetype
  tabnew = function(filetype)
    return { type = 7, filetype = filetype }
  end,
}

-- Helper data
-- Module default config.
H.default_config = vim.deepcopy(Mods.config)

-- Cache for various operations.
H.cache = {}

-- Helper functionality
-- Settings
H.setup_config = function(config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config.
  vim.validate({ config = { config, "table", true } })

  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  return config
end

H.apply_config = function(config)
  Mods.config = config
end

--- Deeply merges `Mods.config` with the provided configuration tables.
--- It gives priority to values in `vim.b.mods_config` and the `config` parameter over `Mods.config`.
---@param config table The user configuration that will override default settings.
---@return table The resulting merged configuration.
H.get_config = function(config)
  return vim.tbl_deep_extend("force", Mods.config, vim.b.mods_config or {}, config or {})
end

--- Utilities
H.echo = function(msg, is_important)
  if H.get_config().silent then
    return
  end

  -- Construct message chunks
  msg = type(msg) == "string" and { { msg } } or msg
  table.insert(msg, 1, { "(mods) ", "WarningMsg" })

  -- Avoid hit-enter-prompt
  local max_width = vim.o.columns * math.max(vim.o.cmdheight - 1, 0) + vim.v.echospace
  local chunks, tot_width = {}, 0
  for _, ch in ipairs(msg) do
    local new_ch = { vim.fn.strcharpart(ch[1], 0, max_width - tot_width), ch[2] }
    table.insert(chunks, new_ch)
    tot_width = tot_width + vim.fn.strdisplaywidth(new_ch[1])
    if tot_width >= max_width then
      break
    end
  end

  -- Echo. Force redraw to ensure that it is effective (`:h echo-redraw`)
  vim.cmd([[echo '' | redraw]])
  vim.api.nvim_echo(chunks, is_important, {})
end

H.unecho = function()
  if H.cache.msg_shown then
    vim.cmd([[echo '' | redraw]])
  end
end

H.message = function(msg)
  H.echo(msg, true)
end

H.error = function(msg)
  error(string.format("(mini.ai) %s", msg), 0)
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then
    return
  end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

H.string_find = function(s, pattern, init)
  init = init or 1

  -- Match only start of full string if pattern says so.
  -- This is needed because `string.find()` doesn't do this.
  -- Example: `string.find('(aaa)', '^.*$', 4)` returns `4, 5`
  if pattern:sub(1, 1) == "^" then
    if init > 1 then
      return nil
    end
    return string.find(s, pattern)
  end

  -- Handle patterns `x.-y` differently: make match as small as possible. This
  -- doesn't allow `x` be present inside `.-` match, just as with `yyy`. Which
  -- also leads to a behavior similar to punctuation id (like with `va_`): no
  -- covering is possible, only next, previous, or nearest.
  local check_left, _, prev = string.find(pattern, "(.)%.%-")
  local is_pattern_special = check_left ~= nil and prev ~= "%"
  if not is_pattern_special then
    return string.find(s, pattern, init)
  end

  -- Make match as small as possible
  local from, to = string.find(s, pattern, init)
  if from == nil then
    return
  end

  local cur_from, cur_to = nil, nil
  cur_from, cur_to = from, to

  while cur_to == to do
    from, to = cur_from, cur_to
    cur_from, cur_to = string.find(s, pattern, cur_from + 1)
  end

  return from, to
end

return Mods
