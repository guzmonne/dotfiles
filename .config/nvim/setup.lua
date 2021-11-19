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

