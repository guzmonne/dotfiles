-- Which Key Configuration --
require("which-key").setup({
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
    },
})

-- To document and/or setup your own mappings, you need to call the `register` method.
local wk = require('which-key')

-- Custom functions
local function pwd()
    local full_path = vim.fn.expand('%:p')
    vim.pretty_print(full_path)
    vim.fn.setreg('+', full_path)
end

local function reload_lua_plugins()
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
end

local function format()
    vim.lsp.buf.format { async = true, timeout_ms = 2000 }
end

local function create_go_to_file(index)
    return function()
        require('harpoon.ui').nav_file(index)
    end
end

local function find_files()
    require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
end

local function live_grep()
    require('telescope.builtin').live_grep()
end

-- Main key mappings
wk.register({
    -- Git
    g = {
        name = 'Git',
        s = { '<cmd>Git<CR>', 'Open Git Fugitive' },
        p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview Hunk' },
        t = { '<cmd>Gitsigns toggle_current_line_blame<CR>', 'Toggle current line blame' },
    },
    -- Edit NeoVim configurations
    e = {
        name = 'Edit NeoVim',
        i = { '<cmd>e ~/.config/nvim/init.vim<CR>', 'Edit init.vim' },
        c = { '<cmd>e ~/.config/nvim/main.vim<CR>', 'Edit main.vim' },
        p = { '<cmd>e ~/.config/nvim/plugins.vim<CR>', 'Edit pluggins.vim' },
        f = { '<cmd>e ~/.config/nvim/functions.vim<CR>', 'Edit functions.vim' },
        m = { '<cmd>e ~/.config/nvim/mappings.vim<CR>', 'Edit mappings.nvim' },
        s = { '<cmd>source ~/.config/nvim/init.vim<CR>', 'Source nvim configuration' },
    },
    -- Write buffer
    w = {
        name = 'Write buffer',
        w = { '<cmd>w<CR>', 'Write current buffer', },
        q = { '<cmd>q<CR>', 'Write current buffer and quit', },
    },
    -- Handle file permissions
    c = {
        name = 'Commands',
        x = { '<cmd>!chmod +x %<CR>', 'Add execute permission to current file' },
        c = { '<cmd>ChatGPT<CR>', 'ChatGPT' },
        a = { '<cmd>ChatGPTActAs<CR>', 'ChatGPT Act as' },
    },
    -- Quit buffers
    q = {
        name = 'Quit',
        q = { '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', 'Close buffer but keep split' },
        a = { '<cmd>qa!<CR>', 'Close NeoVim without saving' },
        w = { '<cmd>xa<CR>', 'Close NeoVim after saving all current open buffers' },
    },
    -- Trouble
    t = { '<cmd>TroubleToggle<CR>', 'Trouble Toggle' },
    -- ZK
    z = {
        name = 'ZK',
        n = { require('user.zk').new, 'Create a new note' },
        z = { require('user.zk').telescope_list, 'Find notes' },
        p = { require('user.zk').private, 'Create a new private note' },
    },
    -- X
    x = {
        x = { '<cmd>ToggleComplete()<CR>', 'Add an `x` to a complete task' }
    },
    -- Lua
    l = {
        name = 'lua',
        f = { format, 'Format current buffer using LSP' },
        l = { reload_lua_plugins, 'Reload Lua plugins' },
        r = { require('user.functions').reload, 'Reload user lua modules' },
        p = { pwd, 'Print and copy the buffer full path' },
    },
    -- Harpoon
    h = { require('harpoon.mark').add_file, 'Add file to Harpoon' },
    [','] = { require('harpoon.ui').toggle_quick_menu, 'Toggle Harpoon\'s quick menu' },
    ['1'] = { create_go_to_file(1), 'Go to file ' .. '1' },
    ['2'] = { create_go_to_file(2), 'Go to file ' .. '2' },
    ['3'] = { create_go_to_file(3), 'Go to file ' .. '3' },
    ['4'] = { create_go_to_file(4), 'Go to file ' .. '4' },
    -- Moving text
    k = { '<cmd>m .-2<CR>==', 'Move text up' },
    j = { '<cmd>m .+1<CR>==', 'Move text down' },
    -- Telescope
    f = {
        name = 'Telescope',
        f = { find_files, 'Find files' },
        g = { '<cmd>Telescope git_files<CR>', 'Find git files' },
        b = { '<cmd>Telescope buffers<CR>', 'Find open buffers' },
        r = { '<cmd>Telescope lsp_references<CR>', 'Find registers' },
        s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Find symbols' },
        z = { '<cmd>Telescope spell_suggest<CR>', 'Spell suggest' },
        l = { live_grep, 'Live grep' },
    },
    ['?'] = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Fuzzy find inside current file' },
    ['-'] = { require('user.functions').neotree_open_current, 'Open NeoTree from the current buffer' },
    ['='] = { '<cmd>Neotree source=buffers<CR>', 'Open current buffers in NeoTree' },
}, { prefix = "<leader>" })
