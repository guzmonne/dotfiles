local home = os.getenv("HOME")

return {
  "cloudbridgeuy/freeze",
  dev = true,
  opts = {
    dir = home .. "/.config/freeze",
    config = "user",
    output = "freeze-{filename}-{start_line}_{end_line}-{timestamp}.png",
    action = "copy",
  },
}
