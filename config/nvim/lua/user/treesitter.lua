-- NVIM Treesitter --
require("nvim-treesitter.configs").setup({
    ensure_installed = "maintained",
    highlight = {enable = true, use_languagetree = true},
    context_commentstring = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm'
        }
    },
    autopairs = {enable = true},
    indent = {enabe = true, disable = {"yaml"}},
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner'
            }
        }
    }
});

