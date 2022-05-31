-- Bufferline Configuration --
require("bufferline").setup {
    options = {
        mode = "buffers",
        numbers = "none",
        diagnostic = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_default_icon = true,
        show_tab_indicator = true,
        persist_buffer_sort = true
    }
}

