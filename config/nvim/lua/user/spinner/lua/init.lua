local M = {
  opts = {
    spinner_type = "dots",
  },
}

M.__index = M

--- Creates a new spinner instance.
--- @param spinner_type string - The type of spinner to use. Valid options are "dots", "line", "star", "bouncing_bar", and "bouncing_ball".
--- @return table - A new spinner object with the specified type, initialized with default values.
function M:new(spinner_type)
  self.spinner_type = spinner_type
  self.pattern = {
    ["dots"] = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    ["line"] = { "-", "\\", "|", "/" },
    ["star"] = { "✶", "✸", "✹", "✺", "✹", "✷" },
    ["bouncing_bar"] = {
      "[    ]",
      "[=   ]",
      "[==  ]",
      "[=== ]",
      "[ ===]",
      "[  ==]",
      "[   =]",
      "[    ]",
      "[   =]",
      "[  ==]",
      "[ ===]",
      "[====]",
      "[=== ]",
      "[==  ]",
      "[=   ]",
    },
    ["bouncing_ball"] = {
      "( ●    )",
      "(  ●   )",
      "(   ●  )",
      "(    ● )",
      "(     ●)",
      "(    ● )",
      "(   ●  )",
      "(  ●   )",
      "( ●    )",
      "(●     )",
    },
  }
  self.interval = 80
  self.current_frame = 1
  self.timer = nil
  self.message = ""

  return self
end

--- Starts the spinner animation with an optional message.
--- @param message string|nil An optional message to display alongside the spinner.
--- @return nil
function M:start(message)
  if self.timer then
    return
  end

  self.message = message or ""
  self.timer = vim.loop.new_timer()
  self.timer:start(
    0,
    self.interval,
    vim.schedule_wrap(function()
      self.current_frame = (self.current_frame % #self.pattern[self.spinner_type]) + 1
      self:draw()
    end)
  )
end

--- Stops the spinner animation and clears the display.
--- @return nil
function M:stop()
  if not self.timer then
    return
  end

  self.timer:stop()
  self.timer:close()
  self.timer = nil
  self:clear()
end

--- Draws the current frame of the spinner animation.
--- @return nil
function M:draw()
  vim.api.nvim_echo(
    { { string.format("\r%s %s", self.pattern[self.spinner_type][self.current_frame], self.message), "None" } },
    false,
    {}
  )
  vim.cmd("redraw")
end

--- Clears the spinner display.
--- @return nil
function M:clear()
  vim.cmd('echon ""') -- Clears the current line
end

function M.setup(plugin_opts)
  for k, v in pairs(plugin_opts) do
    M.opts[k] = v
  end
end

return M
