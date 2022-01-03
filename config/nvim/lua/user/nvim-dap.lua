local dap = require("dap")

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/.config/repos/microsoft/vscode-node-debug2/out/src/nodeDebug.js"}
}

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/.config/repos/microsoft/vscode-chrome-debug/out/src/chromeDebug.js"}
}

dap.configurations.typescript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal'
    }, {
        -- For this to work you need to make sure the node process is started with the
        -- `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require"dap.utils".pick_process
    }
}

dap.configurations.javascriptreact = {
    {
        type = "chrome",
        request = "attach",
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = '9222',
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.typescriptreact = {
    {
        type = "chrome",
        request = "attach",
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = '9222',
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal'
    }, {
        -- For this to work you need to make sure the node process is started with the
        -- `--inspect` flag.
        node = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require"dap.utils".pick_process
    }
}

-- echo "hi<" . synidattr(synid(line("."),col("."),1),"name") . '> trans<' . synidattr(synid(line("."),col("."),0),"name") . "> lo<" . synidattr(synidtrans(synid(line("."),col("."),1)),"name") . ">"

-- Update the breakpoint symbol
vim.fn.sign_define('DapBreakpoint', {text = '', texthl = 'ErrorMsg', linehl = '', numhl = ''})
vim.fn.sign_define('DapStopped', {text = '', texthl = 'ErrorMsg', linehl = '', numhl = ''})

-- Map K to hover while session is active
local api = vim.api
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
    for _, buf in pairs(api.nvim_list_bufs()) do
        local keymaps = api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
        end
    end
    api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.variables").hover()<CR>', {silent = true})
end

dap.listeners.after['event_terminated']['me'] = function()
    for _, keymap in pairs(keymap_restore) do
        api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, {silent = keymap.silent == 1})
    end
    keymap_restore = {}
end
