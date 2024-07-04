return {
  "szw/vim-maximizer",
  -- lazy load on a command
  cmd = "MaximizerToggle",
  keys = {
    { "M", "<cmd>MaximizerToggle!<cr>", desc = "Maximizes and restores the current window" },
  },
  init = function()
    vim.g.maximizer_set_default_mapping = 0
    vim.g.maximizer_set_mapping_with_bang = 0
  end,
}
