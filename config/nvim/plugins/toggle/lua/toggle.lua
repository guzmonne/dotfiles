Cache = {maximized_window_id = nil, origin_window_id = nil}

local function toggle_window()
    if vim.fn.winnr('$') > 1 then
        -- There is more than one window on this tab.
        if Cache.maximized_window_id ~= nil then
            vim.fn.win_gotoid(Cache.maximized_window_id)
        else
            Cache.origin_window_id = vim.fn.win_getid()
            vim.cmd('tab sp')
            Cache.maximized_window_id = vim.fn.win_getid()
        end
    else
        -- There is only onw window on this tab.
        if Cache.origin_window_id ~= nil then
            vim.cmd('tabclose')
            vim.fn.win_gotoid(Cache.origin_window_id)
            Cache.maximized_window_id = nil
            Cache.origin_window_id = nil
        end
    end
end

return {toggle_window = toggle_window}
