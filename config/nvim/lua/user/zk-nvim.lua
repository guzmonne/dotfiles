local commands = require("zk.commands")
local zk = require("zk")

zk.setup({
    -- can be "telescope", "fzf", or "select" (`vim.ui.select`)
    -- it's recommended to use "telescope" or "fzf"
    picker = "telescope",

    lsp = {
        -- `config` is passed to `vim.lsp.start_client(config)`
        config = {"zk", "lsp"},
        name = "zk"
    },

    -- Automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {enabled = true, filetypes = {"markdown", "markdown.pandoc"}}
})

local function make_edit_fn(defaults, picker_options)
    return function(options)
        options = vim.tbl_extend("force", defaults, options or {})
        zk.edit(options, picker_options)
    end
end

local function new_private_note()
    zk.new({title = vim.fn.input("Title: "), dir = "private", edit = true})
end

local function new_private_note_dir()
    dir = "private" .. "/" .. vim.fn.input("Dir: ")
    os.execute("mkdir -p ~/Notes/" .. dir)
    zk.new({dir = dir, title = vim.fn.input("Title: "), edit = true})
end
local Job = require 'plenary.job'

local function sync()
    cwd = "~/Notes"
    notebook_dir = os.getenv("ZK_NOTEBOOK_DIR")
    local async = require("plenary.async")
    Job:new({command = 'git', args = {'add', '.'}, cwd = cwd}):sync()
    Job:new({command = 'git', args = {'commit', '-m', '[nvim]: push updates'}, cwd = cwd}):sync()
    Job:new({command = 'git', args = {'pull', 'origin', 'main'}, cwd = cwd}):sync()
    Job:new({command = 'git', args = {'push', 'origin', 'main'}, cwd = cwd}):sync()
    Jon:new({command = 'zk', argd = {'index', '--notebook-dir', notebook_dir}, cwd = cwd}):sync()
    print("Your notes have been synced")
end

commands.add("ZkOrphans", make_edit_fn({orphan = true}, {title = "Zk Orphans"}))
commands.add("ZkRecents", make_edit_fn({createdAfter = "2 weeks ago"}, {title = "Zk Recents"}))
commands.add("ZkPrivate", new_private_note)
commands.add("ZkPrivateDir", new_private_note_dir)
commands.add("ZkSync", sync)

-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
    local function map(...)
        vim.api.nvim_buf_set_keymap(0, ...)
    end
    local opts = {noremap = true, silent = false}

    -- Open the link under the caret.
    map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- Create a new note after asking for its title.
    -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
    map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
    -- Create a new note in the same directory as the current buffer, using the current selection for title.
    map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)
    -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
    map("v", "<leader>znc",
        ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)

    -- Open notes linking to the current buffer.
    map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
    -- Alternative for backlinks using pure LSP and showing the source context.
    -- map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- Open notes linked by the current buffer.
    map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

    -- Preview a linked note.
    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- Open the code actions for a visual selection.
    map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end
