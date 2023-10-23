-- Configure nvim-lint
local is_nvim_lint_installed, nvim_lint = pcall(require, "nvim-lint")
if not is_nvim_lint_installed then return end
