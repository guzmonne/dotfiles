-- Telekasten --
local home = vim.fn.expand("~/.notes")

require("telekasten").setup({
    home = home,
    take_over_my_home = true,
    auto_set_filetype = true,
    dailies = home .. '/' .. 'daily',
    weeklies = home .. '/' .. 'weekly',
    templates = home .. '/' .. 'templates',
    extension = '.md',
    follow_creates_nonexistant = true,
    dailies_create_nonexistant = true,
    weeklies_create_nonexistant = true,
    template_new_daily = home .. '/' .. 'templates/daily.md',
    plug_into_calendar = true,
    calendar_opts = {
        -- calendar weekly display mode:
        -- 1 'WK01'
        -- 2 'WK 1'
        -- 3 'KW01'
        -- 4 'KW 1'
        -- 5 `1`
        weeknm = 1,
        calendar_monday = 1,
        calendar_mark = 'left_fit'
    },
    -- Telescope actions behavior
    close_after_yanking = false,
    insert_after_inserting = true,

    -- Tag notation
    tag_notation = '#tag',

    -- Options: dropdown or ivy
    command_palette_theme = 'ivy',
    show_tags_theme = 'ivy',
    subdirs_in_links = true,

    -- Options: prefer_new_note, smart, always_ask
    template_handling = 'smart',

    -- Options: smart, prefer_home, same_as_current
    new_note_location = "smart",

    rename_update_links = true
})

