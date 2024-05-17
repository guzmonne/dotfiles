-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.cc = "100,120"
vim.opt.list = false
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.opt.inccommand = "split"

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.11/libexec/bin/python"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Other options
vim.opt.title = true

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- Fold settings
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 0

local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
  end,
})

-- Easily hit escape in terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Warnings
vim.g.skip_ts_context_commentstring_module = true
