-- Luasnip Configuration --
local is_luasnip_installed, ls = pcall(require, "luasnip")

if not is_luasnip_installed then return end

local types = require "luasnip.util.types"

ls.config.set_config {
    -- This tells luasnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection.
    history = true,

    -- If you have dynamic snippets, it updates as you type.
    update_events = "TextChanged,TextChangedI",

    -- Autosnippets:
    enable_autosnippets = true,

    -- Highlights
    ext_opts = {[types.choiceNode] = {active = {virt_text = {{" ", "Error"}}}}}
}

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes.
vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then ls.change_choice(1) end
end)

-- Source snippets file
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets"})
