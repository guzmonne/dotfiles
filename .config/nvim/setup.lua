-- Harpoon Setup --
require("harpoon").setup({
  global_settings = {
    save_on_toggle = true,
    save_on_change = true,
    enter_on_sendcmd = true,
  },
})

-- GitSigns Setup --
require('gitsigns').setup({
  numhl = true,
  linehl = false,
})

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
})
