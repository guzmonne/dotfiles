-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Switch to normal mode inside terminal mode
vim.keymap.set("t", "jk", "<C-\\><C-n>", { silent = true })

-- Shortcut to save the current buffer
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })

-- Select and copy the current line.
vim.keymap.set("n", "y", "y$")

-- Keep search centered
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Undo break points
vim.keymap.set("i", ",", ",<C-g>u")
vim.keymap.set("i", ".", ".<C-g>u")
vim.keymap.set("i", "!", "!<C-g>u")
vim.keymap.set("i", "(", "(<C-g>u")
vim.keymap.set("i", ")", ")<C-g>u")
vim.keymap.set("i", "[", "[<C-g>u")
vim.keymap.set("i", "]", "]<C-g>u")
vim.keymap.set("i", "{", "{<C-g>u")
vim.keymap.set("i", "}", "}<C-g>u")

-- Moving text
vim.keymap.set("v", "J", [[:m '>+1<CR>gv=gv]])
vim.keymap.set("v", "K", [[:m '<-2<CR>gv=gv]])

-- Better block tabbing
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

-- Disable arrow keys
vim.keymap.set("", "<up>", "<nop>")
vim.keymap.set("", "<right>", "<nop>")
vim.keymap.set("", "<down>", "<nop>")
vim.keymap.set("", "<left>", "<nop>")

-- Center C-u and C-d
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Replace u in visual mode to be the same as y
vim.keymap.set("v", "u", "y")

-- Remap go to end of the line
vim.keymap.set({ "n", "v" }, "$", "g_")

-- g; but with zt
vim.keymap.set("n", "g;", "g;zt")

-- Undotree keymap
vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>", { silent = true })

-- Remap J to maintain the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Remap paste
vim.keymap.set("x", "p", '"_dP')
vim.keymap.set("n", "y", '"+y')
vim.keymap.set("v", "y", '"+y')
vim.keymap.set("n", "Y", '"+Y')
vim.keymap.set("n", "d", '"+d')
vim.keymap.set("v", "d", '"+d')

-- Remap Ctrl-C to Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Copy everything inside a markdown code fence
vim.keymap.set("n", "<leader>m", ":?```<CR>jVNky")

-- Codepilot mappings (requires corresponding Lua function or command)
-- Not converted because specific implementation not provided.

-- Remap Ctrl-w-h to Alt-h (Note: Neovim doesn't support direct alt mappings in terminal, use <M-h> for alt)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Experiment
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

-- Show the diagnostic view floating
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

-- Save and close file
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

local ls = require("luasnip")

-- Move to the next snippet completion
vim.keymap.set({ "i", "s" }, "<tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Move to the prev snippet completion
vim.keymap.set({ "i", "s" }, "<s-tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
