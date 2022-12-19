-- Mason Configuration
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers.
local servers = {'tsserver', 'sumneko_lua', 'gopls'}
require("mason-lspconfig").setup({ensure_installed = servers})

