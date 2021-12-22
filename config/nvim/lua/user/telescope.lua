-- Telescope --
require'telescope'.setup {
    defaults = {
        mappings = {
            i = {["<C-h>"] = require'trouble.providers.telescope'.open_with_trouble},
            n = {['<C-t>'] = require'trouble.providers.telescope'.open_with_trouble}
        }
    },
    pickers = {},
    extensions = {
        fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}
    }
}

-- Telescope Plugins --
require('telescope').load_extension('fzf')
