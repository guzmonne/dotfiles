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
    textobjects = {
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer"}
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {["]m"] = "@function.outer", ["]]"] = "@class.outer"},
            goto_next_end = {["]M"] = "@function.outer", ["]["] = "@class.outer"},
            goto_previous_start = {["[m"] = "@function.outer", ["[["] = "@class.outer"},
            goto_previous_end = {["[M"] = "@function.outer", ["[]"] = "@class.outer"}
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

require('treesitter-context').setup({
    enable = true,
    throttle = true,
    max_lines = 0,
    patterns = {default = {'class', 'function', 'method'}}
})
