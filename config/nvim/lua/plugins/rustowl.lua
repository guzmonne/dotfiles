return {
  {
    "cordx56/rustowl",
    dependencies = { "neovim/nvim-lspconfig" },
    enabled = false,
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.rustowlsp.setup({})
    end,
  },
}
