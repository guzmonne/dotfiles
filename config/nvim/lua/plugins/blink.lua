return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
    table.insert(opts.sources.default, 1, "copilot")
    opts.completion.menu.auto_show = false
    opts.signature = vim.tbl_extend("force", opts.signature or {}, { enabled = true })
    opts.sources.providers = vim.tbl_extend("force", opts.sources.providers, {
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
