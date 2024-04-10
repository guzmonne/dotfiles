local home = os.getenv("HOME")

return {
  {
    dir = "~/.config/nvim/lua/user/freeze",
    opts = {
      dir = home .. "/.config/freeze",
      config = "user",
      output = "freeze-{filename}-{start_line}_{end_line}-{timestamp}.png",
      action = "copy",
    },
  },
}
