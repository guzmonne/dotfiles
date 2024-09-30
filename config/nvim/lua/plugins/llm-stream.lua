return {
  "cloudbridgeuy/llm-stream",
  disable = false,
  config = function()
    local llm_stream = require("llm-stream")

    local conf = {}

    llm_stream.setup(conf)

    llm_stream.helpers.create_user_command("LlmStream", function(params)
      llm_stream.Prompt(params)
    end)
  end,
}
