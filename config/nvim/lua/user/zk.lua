local functions = require('user.functions')
local api = require('user.zk.api')
local lsp = require('user.zk.lsp')
local prompt = require('user.zk.input').prompt
local telescope = require('user.zk.telescope')

local M = {}

--- Adds an `autocmd` to attach the `zk lsp` server only when we are editing a note inside the notebook.
local function setup_lsp_auto_attach()
    --- NOTE: modified version of code in nvim-lspconfig
    local filetypes = {"markdown", "markdown.pandoc"}
    local trigger = "FileType " .. table.concat(filetypes, ",")

    vim.api.nvim_command(string.format("autocmd %s lua require'user.zk'._lsp_buf_auto_add(0)", trigger))
end

--- Automatically called function through an `autocmd` set by the `setup` function of this module.
--
-- @param bufnr {number} Number of the buffer where the LSP will be attached.
function M._lsp_buf_auto_add(bufnr)
    -- Make sure we are working with a file.
    if vim.api.nvim_buf_get_option(bufnr, "buftype") == "nofile" then return end

    -- Make sure that we have configure the notebook directory correctly.
    local notebook_dir = os.getenv("ZK_NOTEBOOK_DIR") or ""
    assert(notebook_dir ~= "", "The ZK_NOTEBOOK_DIR environment variable is undefined")

    -- Make sure that we are working on a file inside the notebook directory.
    local buffer_path = vim.api.nvim_buf_get_name(bufnr)
    local start, _ = string.find(buffer_path, notebook_dir)
    if start ~= 1 then return end

    lsp.buf_add(bufnr)
end

--- The entry point of the plugin
function M.setup()
    setup_lsp_auto_attach()
end

--- Creates and opens a buffer with a new note.
-- @param options {table?} Additional options.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
function M.new(options)
    options = options or {}
    prompt({
        title = "[Note Title]",
        on_submit = function(value)
            options.title = value
            api.new(options.notebook_path, options, function(err, res)
                assert(not err, tostring(err))
                if options and options.dryRun ~= true and options.edit ~= false then
                    -- NeoVim does not yet support window/showDocument, therefore we handle
                    -- options.edit locally.
                    vim.cmd("edit " .. res.path)
                end
            end)
        end
    })
end

--- Indexes the notebook
-- @param options {table} Additional options.
-- @param cb {function?} Function for processing stats.
function M.index(options, cb)
    options = options or {}
    cb = cb or functions.inspect
    api.index(options.notebook_path, options, function(err, stats)
        assert(not err, tostring(err))
        cb(stats)
    end)
end

--- Lists the notes inside the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Function to execute once the list of notes is returned.
function M.list(options, cb)
    options = options or {}
    cb = cb or functions.void
    api.list(options.notebook_path, options, function(err, notes)
        assert(not err, tostring(err))
        cb(notes)
    end)
end

--- List the notes inside the notebook using Telescope.
-- @param options {table?} Additional options.
function M.telescope_list(options)
    options = vim.tbl_extend("force", {title = "Zk Notes", multi_select = true}, options or {})
    M.list(options, function(notes)
        telescope.note_picker(notes, options, function(res)
            vim.cmd("edit " .. res[1].absPath)
        end)
    end)
end
--
return M
