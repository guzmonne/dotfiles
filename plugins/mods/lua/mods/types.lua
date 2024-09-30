---@meta

--# selene: allow(unused_variable)

---@class mods.Options
---@field preset        string         LLM-Stream preset to use.
---@field template      string         LLM-Stream template to use.
---@field vars          string         LLM-Stream dynamic vars to pass to the template.
---@field suffix        string         LLM-Stream suffix to append to the prompt.
---@field replace       boolean        Replace the selected text.

---@class mods.PluginOptions
---@field roles           {[1]: string, [2]: mods.Options[]}  Map of `mods` options from which to craft commands.
