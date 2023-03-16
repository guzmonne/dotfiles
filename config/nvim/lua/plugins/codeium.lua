-- Codeium Configuration --
vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true })
vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
vim.keymap.set('i', '<c-z>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })

-- Disable default bindings.
-- NOTE: We do this to avoid it overriding the <Tab> key behavior.
vim.g.codeium_disable_bindings = 1
-- Disable automatic completitions
-- vim.g.codeium_manual = 1
