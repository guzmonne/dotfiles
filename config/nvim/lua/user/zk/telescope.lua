local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")
local previewers = require("telescope.previewers")

local M = {}

--- Use Telescope to display the notebook notes.
-- @param notes {table} Table with the notebook notes.
-- @param options {table?} Additional options.
-- @param cb {function?} Callback to filter the notes.
function M.note_picker(notes, options, cb)
    options = options or {}
    local telescope_options =
        vim.tbl_extend("force", {prompt_title = options.title or "Notes"}, options.telescope or {})

    pickers.new(telescope_options, {
        finder = finders.new_table({
            results = notes,
            entry_maker = function(note)
                local title = note.title or note.path
                return {value = note, path = note.absPath, display = title, ordinal = title}
            end
        }),
        sorter = conf.file_sorter(options),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry)
                conf.buffer_previewer_maker(entry.value.absPath, self.state.bufnr,
                                            {bufname = entry.value.title or entry.value.path})
            end
        }),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                if options.multi_select then
                    local selection = {}
                    action_utils.map_selections(prompt_bufnr, function(entry, _)
                        table.insert(selection, entry.value)
                    end)
                    if vim.tbl_isempty(selection) then
                        selection = {action_state.get_selected_entry().value}
                    end
                    actions.close(prompt_bufnr)
                    cb(selection)
                else
                    actions.close(prompt_bufnr)
                    cb(action_state.get_selected_entry().value)
                end
            end)
            return true
        end
    }):find()
end

--
return M
