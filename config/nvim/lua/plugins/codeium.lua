-- Codeium Configuration --
vim.keymap.set('i', '<C-y>', function()
    return vim.fn['codeium#Accept']()
end, { expr = true })

-- Disable default bindings.
-- NOTE: We do this to avoid it overriding the <Tab> key behavior.
vim.g.codeium_disable_bindings = 1
