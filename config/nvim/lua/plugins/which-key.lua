-- Custom functions
local function pwd()
  local full_path = vim.fn.expand("%:p")
  vim.pretty_print(full_path)
  vim.fn.setreg("+", full_path)
end

local is_harpoon_installed, harpoon = pcall(require, "harpoon")
if not is_harpoon_installed then
  return
end

local function reload_lua_plugins()
  require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets" } })
end

local function format()
  vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
end

local function create_go_to_file(index)
  return function()
    harpoon:list():select(index)
  end
end

local function find_files()
  require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
end

local function live_grep()
  require("telescope.builtin").live_grep()
end

local function terminal_window()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end

local function harpoon_toggle_quick_menu()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end
local function harpoon_add_file()
  harpoon:list():add()
end
local function harpoon_next()
  harpoon:list():next()
end
local function harpoon_prev()
  harpoon:list():next()
end

return {
  "folke/which-key.nvim",
  opts = {
    plugins = { spelling = true },
    defaults = {},
  },
  keys = {
    { "<leader>,", harpoon_toggle_quick_menu, desc = "Toggle Harpoon's quick menu" },
    { "<leader>-", require("oil").open, desc = "Open oil" },
    { "<leader>1", create_go_to_file(1), desc = "Go to file 1" },
    { "<leader>2", create_go_to_file(2), desc = "Go to file 2" },
    { "<leader>3", create_go_to_file(3), desc = "Go to file 3" },
    { "<leader>4", create_go_to_file(4), desc = "Go to file 4" },
    { "<leader>c", group = "Commands" },
    { "<leader>cp", "<cmd>Copilot enable<CR>", desc = "Enable GitHub Copilot for current buffer" },
    { "<leader>cx", "<cmd>!chmod +x %<CR>", desc = "Add execute permission to current file" },
    { "<leader>f", group = "Telescope" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find open buffers" },
    { "<leader>ff", find_files, desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope git_files<CR>", desc = "Find git files" },
    { "<leader>fl", live_grep, desc = "Live grep" },
    { "<leader>fr", "<cmd>Telescope lsp_references<CR>", desc = "Find registers" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find symbols" },
    { "<leader>fz", "<cmd>Telescope spell_suggest<CR>", desc = "Spell suggest" },
    { "<leader>?", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Current buffer fuzzy find" },
    { "<leader>g", group = "Git" },
    { "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
    { "<leader>gs", "<cmd>Git<CR>", desc = "Open Git Fugitive" },
    { "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle current line blame" },
    { "<leader>h", harpoon_add_file, desc = "Add file to Harpoon" },
    { "<leader>j", "<cmd>m .+1<CR>==", desc = "Move text down" },
    { "<leader>k", "<cmd>m .-2<CR>==", desc = "Move text up" },
    { "<leader>l", group = "lua/lsp" },
    { "<leader>le", vim.diagnostic.open_float, desc = "Open diagnostic float" },
    { "<leader>lf", format, desc = "Format current buffer using LSP" },
    { "<leader>ll", reload_lua_plugins, desc = "Reload Lua plugins" },
    { "<leader>lp", pwd, desc = "Print and copy the buffer full path" },
    { "<leader>lr", require("user.functions").reload, desc = "Reload user lua modules" },
    { "<leader>n", harpoon_next, desc = "Toggle next buffer stored in Harpoon" },
    { "<leader>p", harpoon_prev, desc = "Toggle prev buffer stored in Harpoon" },
    { "<leader>q", group = "Quit" },
    { "<leader>qa", "<cmd>qa!<CR>", desc = "Close NeoVim without saving" },
    { "<leader>qq", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", desc = "Close buffer but keep split" },
    { "<leader>qw", "<cmd>xa<CR>", desc = "Close NeoVim after saving all current open buffers" },
    {
      "<leader>rm",
      "<cmd>lua require('mdeval').eval_code_block()<CR>",
      desc = "Evaluate Markdown code block",
      { silent = true },
    },
    { "<leader>tw", terminal_window, desc = "Open a new Terminal Window in the bottom" },
    { "<leader>z", group = "ZK" },
    { "<leader>zn", require("user.zk").new, desc = "Create a new note" },
    { "<leader>zp", require("user.zk").private, desc = "Create a new private note" },
    { "<leader>zz", require("user.zk").telescope_list, desc = "Find notes" },
    { "Q", "<cmd>bd<CR>", desc = "Close the current buffer" },
    { "<leader>bn", "<cmd>BaconLoad<CR>:w<CR>:BaconNext<CR>", "Navigate to the next Bacon location" },
    { "<leader>bl", "<cmd>BaconList<CR>", "Open the Bacon list" },
    { "<Tab>", "<space><space>", "1 Tab == 2 spaces" },
  },
}
