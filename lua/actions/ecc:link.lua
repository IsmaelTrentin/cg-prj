-- TODO: move to ecc module so that its not in the codebase

local util = require 'lua/util'
local opt_log = require('lua/options/log').name

local name = 'ecc:link'
local redirect = util.SILENT
if _OPTIONS[opt_log] then
    redirect = ''
end

newaction {
    trigger = name,
    description = "Links compile_commands.json to root dir running the 'ecc' action if not already called",
    execute = function()
        if not os.isdir 'compile_commands' then
            if not os.execute 'premake5 ecc' then
                print 'failed to run ecc action'
                return
            end
        end

        local ok = false
        if os.host() == 'windows' then
            ok = os.execute(
                'New-Item -ItemType SymbolicLink -Path "compile_commands.json" -Target "compile_commandsdebug.json"'
                    .. redirect
            )
        else
            ok = os.execute('ln -s compile_commands/debug.json compile_commands.json' .. redirect)
        end

        if not ok then
            print 'failed to create soft link'
            return
        end
        print 'symlink created: compile_commands.json -> compile_commands/debug.json'
    end,
}
