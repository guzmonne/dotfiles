---@meta

--# selene: allow(unused_variable)

---@class llm_stream.Options
---@field preset        string         LLM-Stream preset to use.
---@field template      string         LLM-Stream template to use.
---@field vars          string         LLM-Stream dynamic vars to pass to the template.
---@field suffix        string         LLM-Stream suffix to append to the prompt.
---@field replace       boolean        Replace the selected text.

---@class llm_stream.PluginOptions
---@field roles           {[1]: string, [2]: llm_stream.Options[]}  Map of `llm_stream` options from which to craft commands.

---@class llm_stream.Opts
---@field log_file      string | nil   The log file to write to.

---@class llm_stream.PopupOpts
---@field gid           number | nil
---@field on_leave      function | boolean
---@field persist       boolean
---@field escape        boolean

---@class llm_stream.PopupStyle
---@field border        string | nil
---@field zindex        number | nil
---@field relative      string | nil
---@field style         string | nil
