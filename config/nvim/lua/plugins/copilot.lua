return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    build = ":Copilot auth",
    opts = {
      -- suggestion = { enabled = true, auto_trigger = true },
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        markdown = true,
        help = true,
        rust = true,
      },
      -- copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v18.15.0/bin/node",
    },
  },
  { "giuxtaposition/blink-cmp-copilot" },
}
