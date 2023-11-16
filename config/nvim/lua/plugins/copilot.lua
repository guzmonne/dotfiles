return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  keys = {
    -- Accept suggestion
    { "<C-y>", mode = { "i" }, require("copilot.suggestion").accept },
    -- Next suggestion
    { "<C-J>", mode = { "i" }, require("copilot.suggestion").next },
    -- Prev suggestion
    { "<C-K>", mode = { "i" }, require("copilot.suggestion").prev },
  },
  opts = {
    suggestion = { enabled = true, auto_trigger = true },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
    copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v18.15.0/bin/node",
  },
}
