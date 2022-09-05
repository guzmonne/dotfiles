-- Null-ls Configuration --
local is_null_ls_installed, null_ls = pcall(require, "null-ls")
if not is_null_ls_installed then return end

local is_shfmt_installed, shfmt = pcall(require, "null-ls.builtins.formatting.shfmt")
if not is_shfmt_installed then return end

local is_prettier_installed, prettier = pcall(require, "null-ls.builtins.formatting.prettier")
if not is_prettier_installed then return end

local is_shellcheck_installed, shellcheck = pcall(require, "null-ls.builtins.diagnostics.shellcheck")
if not is_shellcheck_installed then return end

local is_hadolint_installed, hadolint = pcall(require, "null-ls.builtins.diagnostics.hadolint")
if not is_hadolint_installed then return end

null_ls.setup({sources = {shfmt, prettier, shellcheck, hadolint}})
