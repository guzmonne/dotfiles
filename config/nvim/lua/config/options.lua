-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.cc = "100,120"
vim.opt.list = false
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.swapfile = false

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.11/libexec/bin/python"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Other options
vim.opt.title = true

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- Fold settings
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 1
