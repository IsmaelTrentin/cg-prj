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
        if not util.exists './.conan2/profiles/default' then
            if not os.execute('conan profile detect' .. redirect) then
                error('command failed: ' .. 'conan profile detect')
                return
            end
        end

        local setup_commands = {
            'conan config install .conan',
            'conan export .conan/recipies/freeglut-cocoa',
        }
        local install_base_command = 'conan install . -of .conan2/deps -b missing -pr cpp20'
        local install_debug_command = install_base_command .. ' -s build_type=Debug'
        local install_release_command = install_base_command .. ' -s build_type=Release'

        for _, cmd in ipairs(setup_commands) do
            print('running: ' .. cmd)
            if not os.execute(cmd .. redirect) then
                error('command failed: ' .. cmd)
            end
        end
        print 'installing Debug deps...'
        print('running: ' .. install_debug_command)
        if not os.execute(install_debug_command) then
            error('command failed: ' .. install_debug_command)
        end
        print 'installing Release deps...'
        print('running: ' .. install_release_command)
        if not os.execute(install_release_command) then
            error('command failed: ' .. install_release_command)
        end
    end,
}
