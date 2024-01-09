-- Telescope --
local is_trouble_installed, trouble = pcall(require, "trouble.providers.telescope")
local is_action_layout, action_layout = pcall(require, "telescope.actions.layout")
local is_actions, actions = pcall(require, "telescope.actions")

if not is_trouble_installed then
  return
end
if not is_action_layout then
  return
end
if not is_actions then
  return
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fg",
      require("telescope.builtin").git_files,
      desc = "Find Git files",
    },
    {
      "<leader>fb",
      require("telescope.builtin").buffers,
      desc = "Find open buffers",
    },
    {
      "<leader>fr",
      require("telescope.builtin").lsp_references,
      desc = "Find references",
    },
    {
      "<leader>fs",
      require("telescope.builtin").lsp_document_symbols,
      desc = "Find symbols",
    },
    {
      "<leader>fz",
      require("telescope.builtin").spell_suggest,
      desc = "Spell Sugest",
    },
    {
      "<leader>fl",
      require("telescope.builtin").live_grep,
      "Live grep",
    },
    {
      "<leader>?",
      require("telescope.builtin").current_buffer_fuzzy_find,
      "Current buffer fuzzy find",
    },
    {
      "<leader>;",
      require("telescope.builtin").resume,
      "Resume the previous telescope picker",
    },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          -- ["<C-u>"] = false,
          -- ["<C-d>"] = false,
          ["?"] = action_layout.toggle_preview,
          ["<C-t>"] = trouble.open_with_trouble,
        },
        n = { ["<C-t>"] = trouble.open_with_trouble },
      },
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
        vertical = { mirror = false },
        width = 0.95,
        height = 0.95,
        preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      extensions = {
        fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
      },
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    },
  },
}
