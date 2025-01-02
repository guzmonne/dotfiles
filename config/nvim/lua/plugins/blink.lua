return {
  "saghen/blink.cmp",
  optional = true,
  enabled = true,
  dependencies = { "giuxtaposition/blink-cmp-copilot", "echasnovski/mini.nvim" },
  opts = {
    keymap = {
      ["<C-space>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
      ["<CR>"] = {},
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
    },
    completion = {
      menu = {
        auto_show = true,
        -- border = "single",
        -- Mini.Icons
        -- draw = {
        --   components = {
        --     kind_icon = {
        --       ellipsis = false,
        --       text = function(ctx)
        --         local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
        --         return kind_icon
        --       end,
        --       highlight = function(ctx)
        --         local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
        --         return hl
        --       end,
        --     },
        --   },
        -- },
      },
      -- documentation = { window = { border = "single" } },
    },
    -- signature = { window = { border = "single" } },
    sources = {
      default = { "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          kind = "Copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
