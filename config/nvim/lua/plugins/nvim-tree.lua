-- Nvim-Tree Configuration --

local git_icons = {
    unstaged = "",
    staged = "",
    unmerged = "",
    renamed = "➜",
    untracked = "",
    deleted = "",
    ignored = "◌",
}

local function toggle_replace()
    local view = require("nvim-tree.view")
    local api = require("nvim-tree.api")

    if view.is_visible() then
        api.tree.close()
    else
        require("nvim-tree").open_replacing_current_buffer({ path = vim.fn.expand('%') })
    end
    -- require("nvim-tree.actions.reloaders.reloaders").reload_git()
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

require("nvim-tree").setup({
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = true,
    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    renderer = {
        highlight_git = true,
        highlight_opened_files = "none",
        root_folder_label = ":~",
        full_name = true,
        group_empty = true,
        indent_markers = {
            enable = true,
            icons = {
                corner = "└ ",
                edge = "│ ",
                none = "  ",
            },
        },
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
            },
            git_placement = "signcolumn",
            glyphs = {
                git = git_icons,
            }
        }
    },
    view = {
        float = {
            enable = true,
            open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2)
                    - vim.opt.cmdheight:get()
                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = center_y,
                    col = center_x,
                    width = window_w_int,
                    height = window_h_int,
                }
            end,
        },
        width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
        mappings = {
            list = {
                { key = "<CR>", action = toggle_replace },
                { key = "%",    action = "create" }
            }
        }
    }
})
