require"better_escape".setup {
    mapping = {"jk", "kj"}, -- A table with mapping to use
    timeout = vim.o.timeoutlen, -- The time in which the keys must be hit in ms.
    clear_empty_lines = false, -- Clear line after escaping if there is only whitespace.
    keys = "<eSC>" -- Keys user for escaping.
}

