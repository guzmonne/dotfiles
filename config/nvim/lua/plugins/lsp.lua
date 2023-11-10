local codes = {
  -- Lua
  no_matching_function = {
    message = " Can't find a matching function",
    "redundant-parameter",
    "ovl_no_viable_function_in_call",
  },
  empty_block = {
    message = " That shouldn't be empty here",
    "empty-block",
  },
  missing_symbol = {
    message = " Here should be a symbol",
    "miss-symbol",
  },
  expected_semi_colon = {
    message = " Please put the `;` or `,`",
    "expected_semi_declaration",
    "miss-sep-in-table",
    "invalid_token_after_toplevel_declarator",
  },
  redefinition = {
    message = " That variable was defined before",
    icon = " ",
    "redefinition",
    "redefined-local",
    "no-duplicate-imports",
    "@typescript-eslint/no-redeclare",
    "import/no-duplicates",
  },
  no_matching_variable = {
    message = " Can't find that variable",
    "undefined-global",
    "reportUndefinedVariable",
  },
  trailing_whitespace = {
    message = "  Whitespaces are useless",
    "trailing-whitespace",
    "trailing-space",
  },
  unused_variable = {
    message = "  Don't define variables you don't use",
    icon = "  ",
    "unused-local",
    "@typescript-eslint/no-unused-vars",
    "no-unused-vars",
  },
  unused_function = {
    message = "  Don't define functions you don't use",
    "unused-function",
  },
  useless_symbols = {
    message = " Remove that useless symbols",
    "unknown-symbol",
  },
  wrong_type = {
    message = " Try to use the correct types",
    "init_conversion_failed",
  },
  undeclared_variable = {
    message = " Have you delcared that variable somewhere?",
    "undeclared_var_use",
  },
  lowercase_global = {
    message = " Should that be a global? (if so make it uppercase)",
    "lowercase-global",
  },
  -- Typescript
  no_console = {
    icon = "  ",
    "no-console",
  },
  -- Prettier
  prettier = {
    icon = "  ",
    "prettier/prettier",
  },
}

-- Change diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
  float = {
    source = false,
    format = function(diagnostic)
      local user_data = diagnostic.user_data
      local code

      if user_data then
        code = user_data.code
      end

      if not diagnostic.source or not code then
        return string.format("%s", diagnostic.message)
      end

      if diagnostic.source == "eslint" then
        for _, table in pairs(codes) do
          if vim.tabl_contains(table, code) then
            return string.format("%s %s", table.icon .. diagnostic.message, code)
          end
        end

        return string.format("%s %s", diagnostic.message, code)
      end

      for _, table in pairs(codes) do
        if vim.tabl_contains(table, code) then
          return table.message
        end
      end

      return string.format("%s %s", diagnostic.message, diagnostic.source)
    end,
  },
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = require("user.icons").circle,
  },
  setloclist = { open = false },
  setqflist = { open = false },
})

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
    setup = {
      markdownlint = function()
        return true
      end,
    },
    servers = {
      yamlls = {
        settings = {
          yaml = {
            validate = false,
          },
        },
      },
      bashls = {
        cmd = { "bash-language-server", "start" },
        flags = { debounce_text_changes = 150 },
      },
    },
  },
}
