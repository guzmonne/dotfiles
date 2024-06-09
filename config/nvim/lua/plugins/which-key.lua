-- Custom functions
local function pwd()
  local full_path = vim.fn.expand("%:p")
  vim.pretty_print(full_path)
  vim.fn.setreg("+", full_path)
end

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
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
      -- Trouble
      t = {
        t = { require("trouble.sources.telescope").open, "Trouble Toggle" },
        w = { terminal_window, "Open a new Terminal Window in the bottom" },
      },
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
      h = {
        function()
          harpoon:list():add()
        end,
        "Add file to Harpoon",
      },
      n = {
        function()
          harpoon:list():next()
        end,
        "Toggle next buffer stored in Harpoon",
      },
      p = {
        function()
          harpoon:list():prev()
        end,
        "Toggle prev buffer stored in Harpoon",
      },
      [","] = {
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        "Toggle Harpoon's quick menu",
      },
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
    }, { prefix = "<leader>" })

    -- Quit mappings
    wk.register({
      Q = { "<cmd>bd<CR>", "Close the current buffer" },
    })
  end,
}
