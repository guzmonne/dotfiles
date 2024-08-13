return {
  "jpalardy/vim-slime",
  init = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{right}",
    }
  end,
}
