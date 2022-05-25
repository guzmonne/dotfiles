-- CMP --
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp = require 'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local lspkind = require 'lspkind'
local source_mapping = {
    cmp_tabnine = '[TN]',
    buffer = "[BUF]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[LUA]",
    path = "[PATH]",
    vsnip = "[SNIP]"
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

require("cmp_nvim_ultisnips").setup {
    filetype_source = "treesitter",
    show_snippets = "expandable",
    documentation = function(snippet)
        return snippet.description
    end
}

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end
    },
    documentation = {border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}},
    completion = {keyword_length = 4, autocomplete = false},
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping.confirm {behavior = cmp.ConfirmBehavior.Insert, select = true},
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end, {"i", "s" --[[ "c" (to enable the mapping in command mode) ]] }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
        end, {"i", "s" --[[ "c" (to enable the mapping in command mode) ]] })
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'cmp_tabnine'}, {name = 'nvim_lua'}, {name = 'path'}, {name = 'ultisnips'},
        {name = 'buffer', default = 5, keyword_length = 5}
    }),
    experimental = {native_menu = false, ghost_text = true},
    formatting = {
        format = function(entry, vim_item)
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
        end
    }
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- User cmdline & path source for `:`
cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})

-- Configure autopairs
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = {tex = ''}}))

-- Use cmp as a flexible omnifunc manager
_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.lsp = function()
    cmp.complete({config = {sources = {{name = 'nvim_lsp'}}}})
end
_G.vimrc.cmp.snippet = function()
    cmp.complete({config = {sources = {{name = 'vsnip'}}}})
end

vim.cmd([[
  inoremap <C-x><C-o> <cmd>lua vimrc.cmp.lsp()<CR>
  inoremap <C-x><C-s> <cmd>lua vimrc.cmp.snippet()<CR>
]])

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
