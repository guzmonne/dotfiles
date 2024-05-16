local cmp = require("cmp")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  init = function()
    cmp.register_source("zk", require("user.zk.cmp_source"))
  end,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    opts.preselect = "None"
    opts.completion = vim.tbl_extend("force", opts.completion, {
      completeopt = "menu,menuone,noinsert,noselect",
      autocomplete = false,
    })
    opts.sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,

        -- Below is the default comparator list and order for nvim-cmp.
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    }
    opts.sources = cmp.config.sources({
      -- Copilot Source
      { name = "copilot", group_index = 2 },
      -- Other Sources
      { name = "nvim_lsp", group_index = 2 },
      { name = "path", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      { name = "buffer", grpup_index = 3 },
    })
    opts.mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end, { "i", "c" }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
    })
  end,
}
