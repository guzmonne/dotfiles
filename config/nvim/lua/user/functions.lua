local M = {}
--

M.reload = function()
    print("Reloading:")
    for k in pairs(package.loaded) do
        if k:match("^user") then
            print("  - " .. k)
            package.loaded[k] = nil
            require(k)
        end
    end
end

-- Opens Neotree on the current's file directory or the current working directory if the active
-- buffer is not a file.
--
M.neotree_open_current = function()
    args = {}

    args.dir = vim.fn.expand("%:p:h")

    file = vim.fn.expand("%:p")

    if file ~= "" then
        args.reveal_file = file
        args.reveal_force_cwd = true
    end

    require("neo-tree.command").execute(args)
end

-- Exports
return M
