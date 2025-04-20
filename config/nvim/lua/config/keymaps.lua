-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use M instead of ' to use the marks
vim.keymap.set("n", "M", "`", { silent = true })

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
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Move to the prev snippet completion
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end

-- Execute Lua File
vim.keymap.set("n", "<C-x><C-x>", ":luafile %<CR>", { noremap = true, silent = true })

-- Chat commands
vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

-- Prompt commands
vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

-- TmuxRepl
vim.keymap.set(
  { "n" },
  "<leader>tr",
  "<cmd>TmuxRepl run<CR>",
  { noremap = true, silent = true, nowait = true, desc = "Run commands under the selected lines" }
)
vim.keymap.set(
  { "v" },
  "<leader>tr",
  ":<C-u>'<,'>TmuxRepl run<CR>",
  { noremap = true, silent = true, nowait = true, desc = "Run commands under the selected lines" }
)
vim.keymap.set(
  { "n" },
  "<leader>tm",
  ":?```<CR>jVNk:<C-u>'<,'>TmuxRepl run<CR>",
  { noremap = true, silent = true, nowait = true, desc = "Run commands under the selected lines" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>tc",
  "<cmd>TmuxRepl comment_run<CR>",
  { noremap = true, silent = true, nowait = true, desc = "Run commands under the commented selected lines" }
)
vim.keymap.set(
  { "v" },
  "<leader>tc",
  ":<C-u>'<,'>TmuxRepl comment_run<CR>",
  { noremap = true, silent = true, nowait = true, desc = "Run commands under the selected lines" }
)
