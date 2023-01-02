local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local void = require('user.functions').void

local M = {}

--- Opens a prompt where a user can enter data.
-- @param options {table} Prompt options table.
-- @property title {string?} Prompt title.
-- @property width {number?} Prompt input box width.
-- @property on_submit {function?} Function to call once the user submits its data.
function M.prompt(options)
    if type(options) ~= "table" then error("You must provide a table as options") end
    options.title = options.title or "[New]"
    options.width = options.width or 50
    options.on_submit = options.on_submit or void
    local input = Input({
        position = "50%",
        size = {width = options.width},
        border = {
            style = "single",
            text = {top = options.title, top_align = "left"},
            win_options = {winhighlight = "Normal:Normal,FloatBorder:Normal"}
        }
    }, {prompt = " ✏  ", on_submit = options.on_submit})

    -- Mount/Open the component.
    input:mount()

    -- Unmount component when cursor leaves the buffer.
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end

return M
