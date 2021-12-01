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
    -- ['<Tab>'] = cmp.mapping(function (fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif vim.fn["vsnip#available"](1) == 1 then
    --     feedkey("<Plug>(vsnip-expand-or-jump)", "")
    --   elseif has_words_before() then
    --     cmp.complete()
    --   else
    --     fallback() -- The fallback option sends a already mapped keys.
    --   end
    -- end, {"i", "s"}),
    -- ['<S-Tab>'] = cmp.mapping(function ()
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif vim.fn["vsnip#jumpable"](-1) == 1 then
    --     feedkey("<Plug>(vsnip-jump-prev)", "")
    --   end
    -- end, {"i", "s"}),
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
    enable = false,
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
  show_current_context = false,
  show_current_context_start = true,
  show_char_blankline = " ",
}

-- Configure tokyonight --
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_comments = true
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_italic_functions = false
vim.g.tokyonight_transparent = true
vim.cmd [[colorscheme tokyonight ]]

-- Configure Telescope --
require'telescope'.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = require'trouble.providers.telescope'.open_with_trouble,
      },
      n = {
        ['<C-t>'] = require'trouble.providers.telescope'.open_with_trouble,
      }
    },
  },
  pickers = {
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}

-- Configure Telescope Plugins --
require('telescope').load_extension('fzf')

-- Configure tabnine --
require'cmp_tabnine.config':setup{
  max_lines = 1000,
  max_num_results = 3,
  sort = true,
  run_on_every_keystroke = false,
  snippet_placeholder = "..",
}

-- Configure autopairs --
require'nvim-autopairs'.setup{}

-- Configure nvim-colorizer --
require'colorizer'.setup()

-- Configure tabout --
require'tabout'.setup{
  tabkey = '<Tab>',
  backwards_tabkey = '<S-Tab>',
  act_as_tab = true,
  act_as_shift_tab = true,
  completion = true,
  tabouts = {
    {open = "'", close = "'"},
    {open = '"', close = '"'},
    {open = '`', close = '`'},
    {open = '(', close = ')'},
    {open = '[', close = ']'},
    {open = '{', close = '}'}
  },
  ignore_beginning = true,
  exclude = {},
}
