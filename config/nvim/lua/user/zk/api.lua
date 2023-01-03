local lsp = require('user.zk.lsp')
local functions = require('user.functions')

local M = {}

--- Executes the given command via LSP.
-- @param cmd {string} Command to execute.
-- @param path {string?} Path to explicitly specify the notebook (ZK_NOTEBOOK_DIR is used by default).
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
local function execute_command(cmd, path, options, cb)
    if options and vim.tbl_isempty(options) then
        -- An empty table would be send as an empty list, which causes an error on the server.
        options = nil
    end

    local bufnr = 0

    lsp.start()
    functions.dump({command = 'zk.' .. cmd})
    lsp.client().request("workspace/executeCommand",
                         {command = "zk." .. cmd, arguments = {path or os.getenv("ZK_NOTEBOOK_DIR"), options}}, cb,
                         bufnr)
end

--- Runs `zk.new` to index existing notes.
-- @param path {string?} Path to explicitly specify the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zkindex
function M.index(path, options, cb)
    execute_command("index", path, options, cb)
end

--- Runs `zk.new` to create a new note.
-- @param path {string?} Path to explicitly specify the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
function M.new(path, options, cb)
    execute_command("new", path, options, cb)
end

--- Runs `zk.private` to create a new private note.
-- @param path {string?} Path to explicitly specify the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
function M.private(path, options, cb)
    execute_command("new", path, options, cb)
end

--- Runs `zk.list` to list notes.
-- @param path {string?} Path to explicitly specify the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zklist
function M.list(path, options, cb)
    options.select = options.select
                         or {"filename", "absPath", "path", "body", "lead", "title", "tags", "created", "modified"}
    execute_command("list", path, options, function(err, notes)
        assert(not err, tostring(err))
        table.sort(notes, function(a, b)
            return a.modified > b.modified
        end)
        cb(err, notes)
    end)
end

--- Runs `zk.tag.list` to list tags
-- @param path {string?} Path to explicitly specify the notebook.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to execute after the command is run.
-- @see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zktaglist
function M.tags(path, options, cb)
    execute_command("tag.list", path, options, function(err, tags)
        assert(not err, tostring(err))
        table.sort(tags, function(a, b)
            return a.note_count > b.note_count
        end)
        cb(err, tags)
    end)
end

--
return M
