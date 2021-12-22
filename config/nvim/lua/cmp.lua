-- CMP --
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
local cmp = require'cmp'
local lspkind = require'lspkind'
local source_mapping = {
  cmp_tabnine = '[TN]',
  buffer = "[BUF]",
  nvim_lsp = "[LSP]",
  nvim_lua = "[LUA]",
  path = "[PATH]",
  vsnip = "[SNIP]",
  emoji = "[EMOJI]",
  npm = "[NPM]",
}

cmp.setup{
  snippet = {
    -- REQUIRED: You must specify a snippet engine.
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  documentation = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  completion = {
    keyword_length = 2,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  },
  sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
    { name = 'cmp_tabnine'},
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'npm', keyword_length = 3 },
    { name = 'buffer', default = 5, keyword_length = 5 },
    { name = 'emoji' },
  }),
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = function (entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.with_text = false
      local menu = source_mapping[entry.source.name]
      if entry.source.name == 'cmp_tabnine' then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = entry.completion_item.data.detail .. ' ' .. menu
        end
        vim_item.kind = ''
      end
      vim_item.menu = menu
      return vim_item
    end,
  },
}

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' }}))

