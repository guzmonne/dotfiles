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

require("dap")
-- Update the breakpoint symbol
vim.fn.sign_define('DapBreakpoint', {text = '🛑', texthl = '', linehl = '', numhl = ''})
