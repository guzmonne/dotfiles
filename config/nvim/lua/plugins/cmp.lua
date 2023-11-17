local cmp = require("cmp")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  setup = function()
    cmp.register_source("zk", require("user.zk.cmp_source"))
  end,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    opts.preselect = "None"
    opts.completion = vim.tbl_extend("force", opts.completion, {
      completeopt = "menu,menuone,noinsert,noselect",
      autocomplete = false,
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
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<S-CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
    })
  end,
}
