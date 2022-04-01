-- NVIM Treesitter --
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "css", "dockerfile", "go", "gomod", "gowork", "graphql", "html", "http", "javascript", "jsdoc", "json",
        "json5", "jsonc", "lua", "make", "markdown", "norg", "python", "regex", "rust", "ruby", "solidity", "toml",
        "tsx", "typescript", "vim", "yaml"
    },
    highlight = {enable = true, use_languagetree = true, additional_vim_regex_highlighting = {"markdown"}},
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

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

-- These two are optional and provide syntax highlighting
-- for Neorg tables and the @document.meta tag
parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = {"src/parser.c"},
        branch = "main"
    }
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = {"src/parser.c"},
        branch = "main"
    }
}
