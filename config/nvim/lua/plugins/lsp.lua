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
      ["harper-ls"] = function(_, opts)
        opts.settings = {
          ["harper-ls"] = {
            useDictPath = "~/dict.txt",
            codeActions = {
              forceStable = true,
            },
            linters = {
              spell_check = true,
              spelled_numbers = true,
              sentence_capitalization = true,
              unclosed_quotes = true,
              wrong_quotes = true,
              long_sentences = true,
              repeated_words = true,
              spaces = true,
              matcher = true,
              correct_number_prefix = true,
              number_suffix_capitalization = true,
              multiple_sequential_pronouns = true,
            },
          },
        }
      end,
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
