local M = {}

local bun_servers = { "tsserver", "eslint" }

local function is_bun_server(name)
    print("Looking to se if " .. name .. " is a bun server")
    for _, server in ipairs(bun_servers) do
        if name == server then
            print("Yes!")
            return true
        end
    end
    print("No!")
    return false
end

local function is_bun_available()
    print("Looking to see if bunx is available")
    local bunx = vim.fn.executable "bunx"
    if bunx == 0 then
        print("No!")
        return false
    end
    print("Yes!")
    return true
end

M.add_bun_prefix = function(config, _)
    print("Adding bun prefix to " .. config.name .. " if bun is available and its a valid server")
    if config.cmd and is_bun_available() and is_bun_server(config.name) then
        print("Yes!")
        config.cmd = vim.list_extend({ "bunx" }, config.cmd)
        return
    end
    print("No!")
end

return M
