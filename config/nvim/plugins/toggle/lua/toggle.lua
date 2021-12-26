Cache = {maximized_window_id = nil, origin_window_id = nil}

-- If there is more than one window we want to maximize the
-- window were we currently are. If there is only one window
-- then:
--   - if the window corresponds to a window we previously
--     maximized, then we close it and go back to the window
--     from which we arrived there.
--   - else, if the window doesn't correspond to a window
--     we previously maximized, then we do nothing.
local Map = {}

local function toggle_window()
    if vim.fn.winnr('$') > 1 then
        -- There is more than one window on this tab.
        local origin_window_id = vim.fn.win_getid()
        vim.cmd('tab sp')
        local maximized_window_id = vim.fn.win_getid()
        Map[maximized_window_id] = origin_window_id
    else
        -- There is only one window
        local maximized_window_id = vim.fn.win_getid()
        local origin_window_id = Map[maximized_window_id]
        if origin_window_id ~= nil then
            vim.cmd('tabclose')
            vim.fn.win_gotoid(origin_window_id)
            Map[maximized_window_id] = nil
        end
    end
end

return {toggle_window = toggle_window}
