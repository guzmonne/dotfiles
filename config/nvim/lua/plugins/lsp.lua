return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "williamboman/mason-lspconfig.nvim", config = function() end },
  },
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Change a key map
    keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename }
    keys[#keys + 1] = { "<leader>ca", vim.lsp.buf.code_action }
    keys[#keys + 1] = { "E", vim.diagnostic.open_float }
  end,
  opts = {
    setup = {
      rust_analyzer = function()
        return true
      end,
      yamlls = function(_, opts)
        opts.settings = {
          yaml = {
            validate = false,
            keyOrdering = false,
          },
        }
      end,
      lua_ls = function(_, opts)
        opts.settings.Lua.diagnostics = {
          globals = { "vim" },
        }
      end,
    },
  },
}
