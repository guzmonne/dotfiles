---@meta

--# selene: allow(unused_variable)

---@class mods.Options
---@field model           string          Default model (gpt-3.5-turbo, gpt-4, ggml-gpt4all-j...).
---@field api             string          OpenAI compatible REST API (openai, localai).
---@field role            string          System role to use.
---@field format?         boolean         Ask for the response to be formatted as markdown unless otherwise set.
---@field format_as?      string          Format of the answer. Used in conjunction with format.
---@field continue?       boolean         Continue from the last response or a given save title.
---@field continue_last   boolean         Continue from the last response.
---@field title?          string          Saves the current conversation with the given title.
---@field max_retries?    number          Maximum number of times to retry API calls.
---@field no_limit?       boolean         Turn off the client-side limit on the size of the input into the model.
---@field max_tokens?     number          Maximum number of tokens in response.
---@field word_wrap?      number          Wrap formatted output at specific width (default is 80)
---@field temp?           number          Temperature (randomness) of results, from 0.0 to 2.0.
---@field stop?           string          Up to 4 sequences where the API will stop generating further tokens.
---@field topp?           number          TopP, an alternative to temperature that narrows response, from 0.0 to 1.0.
---@field no_cache?       boolean         Disables caching of the prompt/response.
---@field replace?        boolean         Replace currently selected text.

---@class mods.PluginOptions
---@field roles           {[1]: string, [2]: mods.Options[]}  Map of `mods` options from which to craft commands.
