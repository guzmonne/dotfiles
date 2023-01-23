-- Codeium Configuration --
vim.keymap.set('i', '<C-y>', function()
    return vim.fn['codeium#Accept']()
end, { expr = true })

