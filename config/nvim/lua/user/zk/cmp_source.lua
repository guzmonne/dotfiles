local api = require('user.zk.api')

local source = {}

--- Return whether this source is available in the current context or not.
-- @return { boolean }
function source:is_available()
    -- Make sure that we have configure the notebook directory correctly.
    local notebook_dir = os.getenv("ZK_NOTEBOOK_DIR") or ""
    if notebook_dir == false then return false end

    -- Make sure that we are working on a file inside the notebook directory.
    local buffer_path = vim.api.nvim_buf_get_name(0)
    local start, _ = string.find(buffer_path, notebook_dir)
    return start == 1
end

--- Return the debug name of this source.
-- @return { string }
function source:get_debug_name()
    return "zk"
end

--- Get notes
-- @param callback {function}
local function get_notes(callback)
    local completions = {}
    api.list("", {}, function(err, notes)
        assert(not err, tostring(err))
        for _, note in pairs(notes) do
            table.insert(completions, {
                insertText = note.filename,
                label = note.title or note.path,
                documentation = note.body or "",
                data = note
            })
        end
        callback(completions)
    end)
end

-- Get tags
-- @param callback {function}
local function get_tags(callback)
    local completions = {}
    api.tags("", {}, function(err, tags)
        assert(not err, tostring(err))
        for _, tag in pairs(tags) do
            table.insert(completions, {
                insertText = tag.name,
                label = tag.name .. " (" .. tag.note_count .. ")",
                documentation = "",
                data = tag.name
            })
        end
        callback(completions)
    end)
end

--- Invoke completion.
-- @param params {cmp.SourceCompletionApiParams}
-- @param callback {function(response: lsp.CompletionResponse|nil): nil}
function source:complete(params, callback)
    local cursor_before_line = params.context.cursor_before_line
    local trimmed = cursor_before_line:gsub("%s+$", "")
    local prefix = string.sub(trimmed, -1)

    if prefix == "[" then prefix = string.sub(trimmed, -2) end

    if prefix == "#" then return get_tags(callback) end

    if prefix == "[[" then return get_notes(callback) end

    return callback({})
end

---Resolve completion item (optional). This is called right before the completion is about to be displayed.
-- Useful for setting the text shown in the documentation window (`completion_item.documentation`).
-- @param completion_item { lsp.CompletionItem }
-- @param callback {function(completion_item: lsp.CompletionItem|nil):nil}
function source:resolve(completion_item, callback)
    callback(completion_item)
end

---Executed after the item was selected.
-- @param completion_item { lsp.CompletionItem }
-- @param callback {function(completion_item: lsp.CompletionItem|nil):nil}
function source:execute(completion_item, callback)
    callback(completion_item)
end

--
return source
