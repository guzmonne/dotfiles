---@meta

--# selene: allow(unused_variable)

---@class mods.Options
---@field preset        string         E preset to use.
---@field template      string         E template to use.
---@field vars          string         E dynamic vars to pass to the template.
---@field suffix        string         E suffix to append to the prompt.

---@class mods.PluginOptions
---@field roles           {[1]: string, [2]: mods.Options[]}  Map of `mods` options from which to craft commands.
