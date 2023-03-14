-- CMP --
local luasnip = require 'luasnip'
local cmp = require 'cmp'
local lspkind = require 'lspkind'
local source_mapping = {
    buffer = "[BUF]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[LUA]",
    path = "[PATH]",
    zk = "[ZK]",
    luasnip = "[SNIP]"
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.register_source('zk', require('user.zk.cmp_source'))

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    completion = { keyword_length = 4, autocomplete = false },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end, { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, { name = 'nvim_lsp_signature_help' }, { name = 'nvim_lua' }, { name = "luasnip" },
        { name = 'path' }, { name = 'zk' }, { name = 'buffer', default = 5, keyword_length = 5 }
    }),
    experimental = { native_menu = false, ghost_text = true },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            vim_item.with_text = false
            local menu = source_mapping[entry.source.name]
            vim_item.menu = menu
            return vim_item
        end
    }
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd [[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#a9b1d6
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#7aa2f7
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#2ac3de
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#7dcfff
  highlight! CmpItemKindInterface guibg=NONE guifg=#7dcfff
  highlight! CmpItemKindText guibg=NONE guifg=#7dcfff
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#bb9af7
  highlight! CmpItemKindMethod guibg=NONE guifg=#bb9af7
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#e0af68
  highlight! CmpItemKindProperty guibg=NONE guifg=#e0af68
  highlight! CmpItemKindUnit guibg=NONE guifg=#e0af68
]]
