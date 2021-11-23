-- CMP --
local has_words_before = function ()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function (key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'

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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function (fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback option sends a already mapped keys.
      end
    end, {"i", "s"}),
    ['<S-Tab>'] = cmp.mapping(function ()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, {"i", "s"}),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
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
    format = require'lspkind'.cmp_format({
      with_text = false,
      maxwidth = 50,
      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[PATH]",
        vsnip = "[SNIP]",
        emoji = "[EMOJI]",
        npm = "[NPM]",
      },
    }),
  },
}

-- Harpoon Setup --
require("harpoon").setup({
  global_settings = {
    save_on_toggle = true,
    save_on_change = true,
    enter_on_sendcmd = true,
  },
})

-- GitSigns Setup --
require('gitsigns').setup({
  numhl = true,
  linehl = false,
})

-- NVIM Treesitter --
require("nvim-treesitter.configs").setup({
  ensure_installed = { "typescript", "javascript", "vim", "yaml", "tsx", "rust", "python", "lua", "json", "jsdoc", "http", "html", "go", "dockerfile", "css", "bash" },
  highlight = {
    enable = true,
    disable = {"typescript"},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@functions.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
});

-- Configure NVim Web Devicons --
require("nvim-web-devicons").setup({
  -- Your personal icons can go here.
  override = {};
  -- Globally enable default icons.
  default = true;
})

-- Configure lualine --
require'lualine'.setup {
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_x = {'filetype'},
    lualine_y = { },
  },
}

-- Configure indent-blankline --
require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
  show_char_blankline = " ",
}

-- Configure tokyonight --
--vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_keywords = true
vim.g.tokyonight_italic_functions = false
vim.g.tokyonight_transparent = true
vim.cmd [[colorscheme tokyonight ]]
