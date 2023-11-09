local highlight = {
  "Whitespace",
}

return {
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    indent = { highlight = highlight, char = "│", tab_char = "│" },
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = false,
    },
    scope = { enabled = false },
  },
}
