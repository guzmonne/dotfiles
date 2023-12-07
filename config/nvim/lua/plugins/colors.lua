return {
  "brenoprata10/nvim-highlight-colors",
  opts = {
    render = "background", -- or 'foreground' or 'first_column'
    enable_named_colors = true,
    enable_tailwind = false,
    custom_colors = {
      -- label property will be used as a pattern initially(string.gmatch),
      -- therefore you need to escape the special characters by yourself with %
      -- { label = "%-%-theme%-font%-color", color = "#fff" },
      -- { label = "%-%-theme%-background%-color", color = "#23222f" },
      -- { label = "%-%-theme%-primary%-color", color = "#0f1219" },
      -- { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
      -- { label = "%-%-theme%-contrast%-color", color = "#fff" },
      -- { label = "%-%-theme%-accent%-color", color = "#55678e" },
    },
  },
}
