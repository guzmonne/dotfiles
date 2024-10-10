local cmp = require("cmp")

local WIDE_HEIGHT = 40

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "luckasRanarison/tailwind-tools.nvim",
    "onsails/lspkind-nvim",
    "hrsh7th/cmp-nvim-lsp-signature-help",
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
    opts.formatting = vim.tbl_extend("force", opts.formatting, {
      format = require("lspkind").cmp_format({
        before = require("tailwind-tools.cmp").lspkind_format,
      }),
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
      { name = "nvim_lsp", group_index = 1 },
      { name = "nvim_lsp_signature_help", group_index = 1 },
      -- Copilot Source
      { name = "copilot", group_index = 2 },
      -- Other Sources
      { name = "path", group_index = 3 },
      { name = "luasnip", group_index = 3 },
      { name = "buffer", grpup_index = 4 },
    })
    opts.window = {
      completion = {
        border = { " ", "", " ", " ", " ", "", " ", " " },
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        winblend = vim.o.pumblend,
        scrolloff = 0,
        col_offset = 0,
        side_padding = 0,
        scrollbar = false,
      },
      documentation = {
        max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
        max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
        border = { " ", "", " ", " ", " ", "", " ", " " },
        winhighlight = "FloatBorder:NormalFloat",
        winblend = vim.o.pumblend,
      },
    }
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
