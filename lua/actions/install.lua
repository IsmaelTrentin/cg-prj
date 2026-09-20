local util = require 'lua/util'
local opt_log = require('lua/options/log').name

local name = 'install'
local redirect = util.SILENT
if _OPTIONS[opt_log] then
    redirect = ''
end

newaction {
    trigger = name,
    description = 'Install deps using conan',
    execute = function()
        if not os.execute('conan' .. util.SILENT) then
            print 'conan missing or not found. download at https://conan.io/downloads or add to PATH'
            return
        end

        local setup_commands = {
            'conan profile detect',
            'conan config install .conan',
            'conan export .conan/recipies/freeglut-cocoa',
        }
        local install_commands = {
            'conan install . -of .conan2/deps -b missing -pr cpp20',
        }
        -- Windows has problems if deps get compiled as Release and we try to run Debug configuration.
        -- We must therefore also have Debug compiled deps.
        if os.host() == 'windows' then
            if _OPTIONS[opt_log] then
                print 'windows detected: getting also Debug deps'
            end
            table.insert(install_commands, install_commands[1] .. ' -s build_type=Debug')
        end

        for _, cmd in ipairs(setup_commands) do
            print('running: ' .. cmd)
            if not os.execute(cmd .. redirect) then
                error('command failed: ' .. cmd)
            end
        end
        for _, cmd in ipairs(install_commands) do
            print('running: ' .. cmd)
            if not os.execute(cmd) then
                error('command failed: ' .. cmd)
            end
        end
    end,
}
