local nvim_lsp = require('lspconfig')

local M = {}

function M.show_line_diagnostics()
    local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',  -- show source in diagnostic popup window
        prefix = ' '
    }
    vim.diagnostic.open_float(nil, opts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-L>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    vim.cmd([[
        autocmd CursorHold <buffer> lua require("user.lsp").show_line_diagnostics()
    ]])

    -- Set some key bindings conditional on server capabilities
   if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
      end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("x", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
    end

    -- The blow command will highlight the current variable and its usages in the buffer
   if client.resolved_capabilities.document_highlight then
      vim.cmd([[
          hi! link LspReferenceRead Visual
          hi! link LspReferenceText Visual
          hi! link LspReferenceWrite Visual
          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
      ]])
    end
end

-- Attempt to fix slow rendering of typescript highlights when using tree-sitter.
-- This doesn't solve the problem for all Typescript files. I don't know what the
-- problem is exactly. I've read online that is a problem related to JSDocs, or
-- the cadence at which Treesitter queries the file.
-- ~~Source: https://github.com/nvim-treesitter/nvim-treesitter/issues/1396
local TSPrebuild = {}
local has_prebuilt = false

TSPrebuild.on_attach = function(client, bufnr)
    if has_prebuilt then return end

    local function safe_read(filename, read_quantifier)
        local file, err = io.open(filename, "r")
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
        local treesitter = require("vim.treesitter")
        local query_files = treesitter.get_query_files(lang, query_name)
        local query_string = read_query_files(query_files)

        treesitter.set_query(lang, query_name, query_string)
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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
local sumneko_root_path = "/Users/gmonne/.config/repos/sumneko/lua-language-server"
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

-- Change diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
  underline = false,
  virtual_text = true,
  signs = true,
  severity_sort = true,
})

return M

