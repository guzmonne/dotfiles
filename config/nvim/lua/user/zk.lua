local functions = require('user.functions')
local api = require('user.zk.api')
local prompt = require('user.zk.input').prompt
local telescope = require('user.zk.telescope')

local M = {}

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
                    vim.cmd("edit " .. res.path)
                end
            end)
        end
    })
end

--- Creates and opens a buffer with a new private note.
-- @param options {table?} Additional options.
function M.private(options)
    options = options or {}
    prompt({
        title = "[Private Note Directory (@default `/`)]",
        on_submit = function(value)
            options.dir = "private" .. "/" .. value
            os.execute("mkdir -p ~/Notes/" .. options.dir)
            M.new(options)
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
    options = vim.tbl_extend("force", { title = "Zk Notes", multi_select = true }, options or {})
    M.list(options, function(notes)
        telescope.note_picker(notes, options, function(res)
            vim.cmd("edit " .. res[1].absPath)
        end)
    end)
end

--
return M
