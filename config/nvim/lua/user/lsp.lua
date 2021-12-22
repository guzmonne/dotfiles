local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-L>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Attempt to fix slow rendering of typescript highlights when using tree-sitter.
-- ~~Source: https://github.com/nvim-treesitter/nvim-treesitter/issues/1396
local TSPrebuild = {}
local has_prebuilt = false

TSPrebuild.on_attach = function(client, bufnr)
    if has_prebuilt then return end

    local query = require('vim.treesitter.query')

    local function safe_read(filename, read_quantifier)
        local file, err = io.open(filename, 'r')
        if not file then error(err) end
        local content = file:read(read_quantifier)
        io.close(file)
        return content
    end

    local function read_query_files(filenames)
        local contents = {}
        for _, filename in ipairs(filenames) do table.insert(contents, safe_read(filename, "*a")) end
        return table.concat(contents, "")
    end

    local function prebuild_query(lang, query_name)
        local query_files = query.get_query_files(lang, query_name)
        local query_string = read_query_files(query_files)
        query.set_query(lang, query_name, query_string)
    end

    local prebuild_languages = {"typescript", "javascript", "tsx"}
    for _, lang in ipairs(prebuild_languages) do
        prebuild_query(lang, "highlights")
        prebuild_query(lang, "injections")
    end

    has_prebuilt = true
    on_attach(client, bufnr)
end

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.documentationFormat = {'markdown', 'plaintext'}
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
capabilities.textDocument.completion.completionItem.relativeSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

-- Borders --
local border = {
    {"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"}, {"│", "FloatBorder"},
    {"╯", "FloatBorder"}, {"─", "FloatBorder"}, {"╰", "FloatBorder"}, {"│", "FloatBorder"}
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = border})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})

-- Ansible --
nvim_lsp.ansiblels.setup {
    cmd = {"ansible-language-server", "--stdio"},
    filetypes = {"yaml", "yml", "yaml.ansible", "ansible"},
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- Bash --
nvim_lsp.bashls.setup {
    cmd = {"bash-language-server", "start"},
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- CSS --
nvim_lsp.cssls.setup {
    cmd = {"vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
}
-- Docker --
nvim_lsp.dockerls.setup {
    cmd = {"docker-langserver", "--stdio"},
    filetypes = {"Dockerfile", "dockerfile"},
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- ESLint --
nvim_lsp.eslint.setup {
    cmd = {"vscode-eslint-language-server", "--stdio"},
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- Go --
nvim_lsp.gopls.setup {
    cmd = {"gopls"},
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
}
-- HTML --
nvim_lsp.html.setup {
    cmd = {"vscode-html-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
}
-- Lua --
local sumneko_root_path = "~/.config/repos/sumneko/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
local runtime_path = vim.split(package.path, ';')

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false}
        }
    },
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
}

-- Typescript --
nvim_lsp.tsserver.setup {
    cmd = {"typescript-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = TSPrebuild.on_attach,
    flags = {debounce_text_changes = 150}
}

-- Vim --
nvim_lsp.vimls.setup {
    cmd = {"vim-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
}

-- Python --
nvim_lsp.pyright.setup {cmd = {"pyright-langserver", "--stdio"}, capabilities = capabilities}

-- Solidity --
nvim_lsp.solang.setup {}

-- EFM Lang server --
require"lspconfig".efm.setup {
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
require"lspconfig".terraformls.setup {cmd = {"terraform-ls", "serve"}}
