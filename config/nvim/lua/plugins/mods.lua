return {
  "cloudbridgeuy/mods",
  dev = true,
  opts = {
    aws = {
      model = "gpt-4o",
      api = "openai",
      role = "aws",
      format = true,
      format_as = "code",
    },
  },
}
