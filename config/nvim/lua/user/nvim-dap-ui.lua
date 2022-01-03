require"dapui".setup({
    icons = {expanded = "", collapsed = ""},
    mappings = {
        expand = {"<CR>", "<C-y>"}, -- Toggle showing any childen of variable.
        open = "o", -- Jump to a place within the stack frame.
        remove = "d", -- Removed the watched expression.
        edit = "e", -- Edit the value of a variable.
        repl = "r" -- Send variable to REPL.
    },
    sidebar = {
        elements = {
            {id = "scopes", size = 0.50}, {id = "breakpoints", size = 0.15}, {id = "stacks", size = 0.20},
            {id = "watches", size = 0.15}
        },
        size = 70,
        position = "right"
    },
    tray = {elements = {"repl"}, size = 10, position = "bottom"},
    floating = {max_height = nil, max_width = nil, border = "rounded", mappings = {close = {"q", "<Esc>"}}},
    windows = {indent = 1}
})

local dap = require "dap"
local dapui = require "dapui"

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
