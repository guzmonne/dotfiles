Cache = {maximized_window_id = nil, origin_window_id = nil}

-- Hold the original window if for all maximized windows.
local Map = {}

-- When run on a tab with multiple windows, maximize the active one
-- on a new `tab`. We hold the `id` of the original window on a table
-- so we can return to the original window by running `toggle_window`
-- on the `maximized` window.
--
-- It supports multiple maximized windows on multiple tabs. You can
-- also mazimize additional windows from a maximized tab and return
-- to the origin by running `toggle_window` multiple times.
--
-- TODO: Currently, if you run `togglw_window` on a maximized tab on
--       where multiple windows are opened, we don't close the tab
--       and move back to the original tab, we mazimize the window
--       were we currently are. Might want to reconsider this
--       behavior on future versions.
-- TODO: I don't have any guards set up to handle going back to a
--       window that is no longer opened. I don't know of an easy
--       way to check if a window is still available.
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
