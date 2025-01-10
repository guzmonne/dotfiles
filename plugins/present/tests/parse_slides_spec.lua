---@diagnostic disable: undefined-field

local parse = require("plugins.present.lua.present")._parse_slides

local eq = assert.are.same

describe("present.parse_slides", function()
  it("should parse an empty file", function()
    eq({
      slides = { { title = "", body = {}, blocks = {} } },
    }, parse({}))
  end)

  it("should parse a file with one slide", function()
    eq({
      slides = { { title = "# This is the first slide", body = { "This is the body" }, blocks = {} } },
    }, parse({ "# This is the first slide", "This is the body" }))
  end)

  it("should parse a block within a slide", function()
    local results = parse({
      "# This is the title",
      "This is the body",
      "",
      "```bash",
      "# List all files in human",
      "ls -alh --color=auto",
      "# Current working directory",
      "pwd",
      "```",
    })

    -- Should only have one slide
    eq(1, #results.slides)

    local slide = results.slides[1]

    -- Should have the right title
    eq("# This is the title", slide.title)

    -- Should have the right body
    eq({
      "This is the body",
      "",
      "```bash",
      "# List all files in human",
      "ls -alh --color=auto",
      "# Current working directory",
      "pwd",
      "```",
    }, slide.body)

    -- Should have the block lines
    eq({
      {
        language = "bash",
        body = [[# List all files in human
ls -alh --color=auto
# Current working directory
pwd]],
      },
    }, slide.blocks)
  end)
end)
