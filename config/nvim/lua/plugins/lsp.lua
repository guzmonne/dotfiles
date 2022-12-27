local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
    if client.name == "eslint" then
        vim.cmd.LspStop("eslint")
        return
    end

    -- Mappings.
    local nmap = function(keys, func, desc)
        if desc then desc = 'LSP: ' .. desc end

        vim.keymap.set('n', keys, func, {buffer = bufnr, desc = desc, noremap = true, silent = true})
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Create a command `:Format` local to the LSP buffer.
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, {desc = 'Format current buffer with LSP'})
end

-- Setup lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Borders --
local border = {
    {"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"}, {"│", "FloatBorder"},
    {"╯", "FloatBorder"}, {"─", "FloatBorder"}, {"╰", "FloatBorder"}, {"│", "FloatBorder"}
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = border})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    update_in_insert = false,
    signs = true,
    virtual_text = true
})

-- Ansible --
nvim_lsp.ansiblels.setup {
    cmd = {"ansible-language-server", "--stdio"},
    filetypes = {"yaml", "yml", "yaml.ansible", "ansible"},
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- Bash --
nvim_lsp.bashls.setup {
    cmd = {"bash-language-server", "start"},
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- CSS --
nvim_lsp.cssls.setup {
    cmd = {"vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150}
}
-- Docker --
nvim_lsp.dockerls.setup {
    cmd = {"docker-langserver", "--stdio"},
    filetypes = {"Dockerfile", "dockerfile"},
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- Go --
nvim_lsp.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}}
}
-- HTML --
nvim_lsp.html.setup {
    cmd = {"vscode-html-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150}
}

-- Terraform --
require'lspconfig'.terraformls.setup {}

-- Lua --
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
}
-- Typescript --
nvim_lsp.tsserver.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    cmd = {"typescript-language-server", "--stdio"},
    flags = {debounce_text_changes = 150},
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    root_dir = nvim_lsp.util.root_pattern('.git')
}

-- Vim --
nvim_lsp.vimls.setup {
    cmd = {"vim-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = {debounce_text_changes = 150}
}

-- Python --
nvim_lsp.pyright.setup {cmd = {"pyright-langserver", "--stdio"}, capabilities = capabilities}

-- Solidity --
nvim_lsp.solang.setup {}

-- EFM Lang server --
nvim_lsp.efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"lua"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {
                    formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=120 --break-after-table-lb",
                    formatStdin = true
                }
            }
        }
    }
}

-- Terraform --
nvim_lsp.terraformls.setup {cmd = {"terraform-ls", "serve"}}

-- Rust --
nvim_lsp.rust_analyzer.setup({
    on_attach = M.on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {importGranularity = "module", importPrefix = "self"},
            cargo = {loadOutDirsFromCheck = true},
            procMacro = {enable = true}
        }
    }
})

-- Change diagnostics signs
vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInformation", {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

-- global config for diagnostic
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = {source = 'always', header = '', prefix = ''}
})

return M
