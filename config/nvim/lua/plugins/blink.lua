return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
    table.insert(opts.sources.default, 1, "copilot")
    table.insert(opts.sources.default, #opts.sources.default, "snippets")
    opts.completion.menu.auto_show = false
    opts.signature = vim.tbl_extend("force", opts.signature or {}, { enabled = true })
    opts.sources.providers = vim.tbl_extend("force", opts.sources.providers, {
      snippets = {
        name = "snippets",
        module = "blink.cmp.sources.snippets",
        enabled = true,
        max_items = 8,
        min_keyword_length = 2,
        score_offset = 95,
      },
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        kind = "Copilot",
        score_offset = 100,
        async = true,
      },
    })
    opts.keymap = vim.tbl_extend("force", opts.keymap, {
      ["<CR>"] = {},
      ["<C-n>"] = {
        function(cmp)
          if not cmp.is_visible() then
            cmp.show()
          else
            cmp.select_next()
          end
        end,
      },
    })
  end,
}
