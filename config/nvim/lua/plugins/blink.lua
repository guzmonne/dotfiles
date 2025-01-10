return {
  "saghen/blink.cmp",
  event = "VeryLazy",
  enabled = true,
  dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot", "echasnovski/mini.nvim" },
  version = "*",
  opts = {
    keymap = {
      ["<C-space>"] = {
        function(cmp)
          cmp.show()
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
        auto_show = false,
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
      default = { "copilot", "lsp", "path", "snippets", "buffer", "markdown" },
      providers = {
        markdown = {
          name = "RenderMarkdown",
          module = "render-markdown.integ.blink",
          fallbacks = { "lsp" },
        },
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
