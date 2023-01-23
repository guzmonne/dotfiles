-- NVIM Treesitter --
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "rust", "bash", "css", "dockerfile", "go", "gomod", "gowork", "html", "http", "javascript", "jsdoc", "json",
        "json5", "jsonc", "lua", "make", "markdown", "python", "regex", "rust", "toml", "tsx", "typescript", "vim",
        "yaml"
    },
    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on `syntax` being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages.
        additional_vim_regex_highlighting = false
    },
    rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
    context_commentstring = { enable = true, enable_autocmd = false,},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<C-s>',
            node_decremental = '<C-backspace>'
        }
    },
    autopairs = { enable = true },
    autotag = {
        enable = true
    },
    indent = { enabe = true, disable = { "yaml" } },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner'
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
            goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
            goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
            goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' }
        },
        swap = {
            enable = true,
            swap_next = { ['<leader>a'] = '@parameter.inner' },
            swap_previous = { ['<leader>A'] = '@parameter.inner' }
        }
    }
});

require('nvim-treesitter.parsers').get_parser_configs()

require('treesitter-context').setup({
    enable = true,
    throttle = true,
    max_lines = 0,
    patterns = { default = { 'class', 'function', 'method' } }
})
