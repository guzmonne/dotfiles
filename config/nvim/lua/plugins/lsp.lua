return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Change a keymap
    keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename }
    keys[#keys + 1] = { "<leader>ca", vim.lsp.buf.code_action }
    keys[#keys + 1] = { "E", vim.diagnostic.open_float }
  end,
  opts = {
    inlay_hints = { enabled = true },
    setup = {
      yamlls = function()
        return true
      end,
      markdownlint = function()
        return true
      end,
    },
    servers = {
      tsserver = {
        root_dir = function(...)
          return require("lspconfig.util").root_pattern(".git")(...)
        end,
        single_file_support = false,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      html = {},
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       validate = false,
      --       keyOrdering = false,
      --     },
      --   },
      -- },
      bashls = {
        cmd = { "bash-language-server", "start" },
        flags = { debounce_text_changes = 150 },
      },
    },
  },
}
