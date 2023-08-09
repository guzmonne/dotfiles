local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')
local util = require('lspconfig/util')
local add_bun_prefix = require('plugins.bun').add_bun_prefix

util.on_setup = util.add_hook_before(util.on_setup, add_bun_prefix)

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(_, bufnr)
    -- Mappings.
    local nmap = function(keys, func, desc)
        if desc then desc = 'LSP: ' .. desc end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
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
    nmap('E', vim.diagnostic.open_float, 'Show line diagnostics')

    -- Create a command `:Format` local to the LSP buffer.
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })
end

-- Setup CMP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
}

-- Borders --
local border = {
    { "╭", "FloatBorder" }, { "─", "FloatBorder" }, { "╮", "FloatBorder" }, { "│", "FloatBorder" },
    { "╯", "FloatBorder" }, { "─", "FloatBorder" }, { "╰", "FloatBorder" }, { "│", "FloatBorder" }
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    update_in_insert = false,
    signs = true,
    virtual_text = true
})

-- Bash --
nvim_lsp.bashls.setup {
    cmd = { "bash-language-server", "start" },
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
}
-- CSS --
nvim_lsp.cssls.setup {
    cmd = { "vscode-css-language-server", "--stdio" },
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 }
}
-- Docker --
nvim_lsp.dockerls.setup {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "Dockerfile", "dockerfile" },
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities
}
-- Go --
nvim_lsp.gopls.setup {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } }
}
-- HTML --
nvim_lsp.html.setup {
    cmd = { "vscode-html-language-server", "--stdio" },
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 }
}

-- Terraform --
nvim_lsp.terraformls.setup {}

-- Lua --
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
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
                globals = { 'vim' }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false }
        }
    }
}
-- Typescript --
nvim_lsp.tsserver.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    cmd = { "typescript-language-server", "--stdio" },
    flags = { debounce_text_changes = 150 },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = nvim_lsp.util.root_pattern('.git'),
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = true,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = true,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
            },
        },
    }
}

-- Vim --
nvim_lsp.vimls.setup {
    cmd = { "vim-language-server", "--stdio" },
    capabilities = capabilities,
    on_attach = M.on_attach,
    flags = { debounce_text_changes = 150 }
}

-- Python --
nvim_lsp.pyright.setup { cmd = { "pyright-langserver", "--stdio" }, capabilities = capabilities }

-- Terraform --
nvim_lsp.terraformls.setup { cmd = { "terraform-ls", "serve" } }

-- Rust
local rt = require('rust-tools')
rt.setup({
    server = {
        on_attach = function(client, bufnr)
            M.on_attach(client, bufnr)
            require("which-key").register({
                r = {
                    name = 'Rust Tools',
                    h = { rt.hover_actions.hover_actions, 'Hover actions' },
                    c = { rt.code_action_group.code_action_group, 'Code action group' },
                }
            }, { prefix = "<leader>" })
        end,
        settings = {
            ["rust-analyzer"] = {
                diagnostics = {
                    enable = true,
                    disabled = { "unresolved-proc-macro" },
                    enableExperimental = true
                },
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    },
})

-- ZK --
configs.zk = {
    default_config = {
        cmd = { 'zk', 'lsp' },
        filetypes = { 'markdown' },
        root_dir = function()
            return vim.loop.cwd()
        end,
        settings = {}
    }
}

nvim_lsp.zk.setup({ on_attach = M.on_attach })

-- Groovy --
nvim_lsp.groovyls.setup({
    cmd = { 'java', '-jar', 'groovy-language-server-all.jar' },
    filetypes = { 'Jenkinsfile', 'groovy' },
    on_attach = M.on_attach
})

local codes = {
    -- Lua
    no_matching_function = {
        message = " Can't find a matching function",
        "redundant-parameter",
        "ovl_no_viable_function_in_call",
    },
    empty_block = {
        message = " That shouldn't be empty here",
        "empty-block",
    },
    missing_symbol = {
        message = " Here should be a symbol",
        "miss-symbol",
    },
    expected_semi_colon = {
        message = " Please put the `;` or `,`",
        "expected_semi_declaration",
        "miss-sep-in-table",
        "invalid_token_after_toplevel_declarator",
    },
    redefinition = {
        message = " That variable was defined before",
        icon = " ",
        "redefinition",
        "redefined-local",
        "no-duplicate-imports",
        "@typescript-eslint/no-redeclare",
        "import/no-duplicates"
    },
    no_matching_variable = {
        message = " Can't find that variable",
        "undefined-global",
        "reportUndefinedVariable",
    },
    trailing_whitespace = {
        message = "  Whitespaces are useless",
        "trailing-whitespace",
        "trailing-space",
    },
    unused_variable = {
        message = "  Don't define variables you don't use",
        icon = "  ",
        "unused-local",
        "@typescript-eslint/no-unused-vars",
        "no-unused-vars"
    },
    unused_function = {
        message = "  Don't define functions you don't use",
        "unused-function",
    },
    useless_symbols = {
        message = " Remove that useless symbols",
        "unknown-symbol",
    },
    wrong_type = {
        message = " Try to use the correct types",
        "init_conversion_failed",
    },
    undeclared_variable = {
        message = " Have you delcared that variable somewhere?",
        "undeclared_var_use",
    },
    lowercase_global = {
        message = " Should that be a global? (if so make it uppercase)",
        "lowercase-global",
    },
    -- Typescript
    no_console = {
        icon = "  ",
        "no-console",
    },
    -- Prettier
    prettier = {
        icon = "  ",
        "prettier/prettier"
    }
}

-- global config for diagnostic
vim.diagnostic.config({
    float = {
        source = false,
        format = function(diagnostic)
            local user_data = diagnostic.user_data
            local code

            if user_data then
                code = user_data.code
            end

            if not diagnostic.source or not code then
                return string.format('%s', diagnostic.message)
            end

            if diagnostic.source == 'eslint' then
                for _, table in pairs(codes) do
                    if vim.tabl_contains(table, code) then
                        return string.format('%s %s', table.icon .. diagnostic.message, code)
                    end
                end

                return string.format('%s %s', diagnostic.message, code)
            end

            for _, table in pairs(codes) do
                if vim.tabl_contains(table, code) then
                    return table.message
                end
            end

            return string.format('%s %s', diagnostic.message, diagnostic.source)
        end
    },
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
        prefix = require("plugins.icons").circle,
    },
    setloclist = { open = false },
    setqflist = { open = false },
})

-- Change diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

return M
