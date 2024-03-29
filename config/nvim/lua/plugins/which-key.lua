-- Custom functions
local function pwd()
  local full_path = vim.fn.expand("%:p")
  vim.pretty_print(full_path)
  vim.fn.setreg("+", full_path)
end

local function reload_lua_plugins()
  require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
end

local function format()
  vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
end

local function create_go_to_file(index)
  return function()
    require("harpoon.ui").nav_file(index)
  end
end

local function find_files()
  require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
end

local function live_grep()
  require("telescope.builtin").live_grep()
end

return {
  "folke/which-key.nvim",
  opts = {
    plugins = { spelling = true },
    defaults = {},
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
    wk.register({
      -- Git
      g = {
        name = "Git",
        s = { "<cmd>Git<CR>", "Open Git Fugitive" },
        p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
        t = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle current line blame" },
      },
      -- Handle file permissions
      c = {
        name = "Commands",
        p = { "<cmd>Copilot enable<CR>", "Enable GitHub Copilot for current buffer" },
        x = { "<cmd>!chmod +x %<CR>", "Add execute permission to current file" },
      },
      -- Quit buffers
      q = {
        name = "Quit",
        q = { "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", "Close buffer but keep split" },
        a = { "<cmd>qa!<CR>", "Close NeoVim without saving" },
        w = { "<cmd>xa<CR>", "Close NeoVim after saving all current open buffers" },
      },
      -- Rest NVIM
      r = {
        name = "Rest NVIM",
        r = { require("rest-nvim").run, "Run the query under the current cursor" },
        l = { require("rest-nvim").run_last, "Run the last query" },
        p = { require("rest-nvim").preview, "Preview the query under the current cursor" },
      },
      -- Trouble
      t = { "<cmd>TroubleToggle<CR>", "Trouble Toggle" },
      -- ZK
      z = {
        name = "ZK",
        n = { require("user.zk").new, "Create a new note" },
        z = { require("user.zk").telescope_list, "Find notes" },
        p = { require("user.zk").private, "Create a new private note" },
      },
      -- Misc
      x = {
        name = "Misc",
        x = { "<cmd>ToggleComplete()<CR>", "Add an `x` to a complete task" },
      },
      -- Lua / Lsp
      l = {
        name = "lua/lsp",
        f = { format, "Format current buffer using LSP" },
        l = { reload_lua_plugins, "Reload Lua plugins" },
        e = { vim.diagnostic.open_float, "Open diagnostic float" },
        r = { require("user.functions").reload, "Reload user lua modules" },
        p = { pwd, "Print and copy the buffer full path" },
      },
      -- Harpoon
      h = { require("harpoon.mark").add_file, "Add file to Harpoon" },
      [","] = { require("harpoon.ui").toggle_quick_menu, "Toggle Harpoon's quick menu" },
      ["1"] = { create_go_to_file(1), "Go to file " .. "1" },
      ["2"] = { create_go_to_file(2), "Go to file " .. "2" },
      ["3"] = { create_go_to_file(3), "Go to file " .. "3" },
      ["4"] = { create_go_to_file(4), "Go to file " .. "4" },
      -- Moving text
      k = { "<cmd>m .-2<CR>==", "Move text up" },
      j = { "<cmd>m .+1<CR>==", "Move text down" },
      -- Telescope
      f = {
        name = "Telescope",
        f = { find_files, "Find files" },
        g = { "<cmd>Telescope git_files<CR>", "Find git files" },
        b = { "<cmd>Telescope buffers<CR>", "Find open buffers" },
        r = { "<cmd>Telescope lsp_references<CR>", "Find registers" },
        s = { "<cmd>Telescope lsp_document_symbols<CR>", "Find symbols" },
        z = { "<cmd>Telescope spell_suggest<CR>", "Spell suggest" },
        l = { live_grep, "Live grep" },
      },
      ["-"] = { require("oil").open, "Open oil" },
      ["?"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find inside current file" },
    }, { prefix = "<leader>" })

    -- Quit mappings
    wk.register({
      Q = { "<cmd>bd<CR>", "Close the current buffer" },
    })
  end,
}
