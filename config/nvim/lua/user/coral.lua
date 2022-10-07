local M = {}
--

local Job = require('plenary.job')

dump = require('user.functions').dump
get_text = require('user.functions').get_text

M.psql = function()
    local sql = get_text()
    local dir = ""
    Job:new({
        command = 'git',
        args = {'rev-parse', '--show-toplevel'},
        on_exit = function(j)
            dir = j:result()[1]
        end
    }):sync()
    Job:new({
        command = dir .. '/dev/coral.sh',
        args = {'psql', '-c', sql},
        on_exit = function(j)
            print('---')
            print('QUERY:')
            print(sql)
            print('...')
            for k, v in pairs(j:result()) do print('  ' .. v) end
            print('---')
        end
    }):sync()
end

-- Exports
return M
