-- Telescope --
local is_telescope_installed, telescope = pcall(require, "telescope")
local is_telescope_actions_installed, telescope_actions = pcall(require, "telescope.actions")
local is_trouble_installed, trouble = pcall(require, "trouble.providers.telescope")
local is_action_layout, action_layout = pcall(require, "telescope.actions.layout")

if not is_telescope_installed then return end
if not is_trouble_installed then return end
if not is_telescope_actions_installed then return end
if not is_action_layout then return end

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case"
        },
        mappings = {i = {
            ["?"] = action_layout.toggle_preview,
            ["<C-t>"] = trouble.open_with_trouble}, n = {["<C-t>"] = trouble.open_with_trouble}},
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {prompt_position = "top", preview_width = 0.55, results_width = 0.8},
            vertical = {mirror = false},
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {"node_modules"},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = {"truncate"},
        winblend = 0,
        -- border = {},
        -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        extensions = {
            fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}
        },
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker
    }
})

telescope.load_extension('fzf')
