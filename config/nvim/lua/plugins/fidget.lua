return {
  "j-hui/fidget.nvim",
  tag = "v1.4.0", -- Make sure to update this to something recent!
  opts = {
    -- Options related to LSP Progress subsystem.
    progress = {
      poll_rate = 1,
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 3, -- How long a message should persist after completion
        done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
        done_style = "Constant", -- Highlight group for completed LSP tasks
        progress_ttl = math.huge, -- How long a message should persist when in progress
        -- Icon shown when LSP progress tasks are in progress
        progress_icon = { pattern = "dots", period = 1 },
        -- Highlight group for in-progress LSP tasks
        progress_style = "WarningMsg",
        group_style = "Title", -- Highlight group for group name (LSP server name)
        icon_style = "Question", -- Highlight group for group icons
        priority = 30, -- Ordering priority for LSP notification group
        skip_history = true, -- Whether progress notifications should be omitted from history
        -- How to format a progress notification group's name
        format_group_name = function(group)
          return tostring(group)
        end,
      },

      -- Options related to Neovim's built-in LSP client
      lsp = {
        progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
        log_handler = false, -- Log `$/progress` handler invocations (for debugging)
      },
    },
  },
}
