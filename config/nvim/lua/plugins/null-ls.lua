-- Null-LS Configuration --
local is_null_ls_installed, null_ls = pcall(require, "null-ls")
if not is_null_ls_installed then return end

local is_prettier_installed, prettier = pcall(require, "null-ls.builtins.formatting.prettier")
if not is_prettier_installed then return end

local is_hadolint_installed, hadolint = pcall(require, "null-ls.builtins.diagnostics.hadolint")
if not is_hadolint_installed then return end

local is_npm_groovy_lint_installed, npm_groovy_lint = pcall(require, "null-ls.builtins.formatting.npm_groovy_lint")
if not is_npm_groovy_lint_installed then return end

null_ls.setup({
    debug = true,
    sources = { prettier, hadolint,
        npm_groovy_lint.with({ timeout = 5000, args = { '--format', '-', '--failon', 'none' } }) }
})
