local util = require 'lua/util'
local opt_all = require('lua/options/all').name

local name = 'clean'
local redirect = util.SILENT
if _OPTIONS['verbose'] then
    redirect = ''
end

newaction {
    trigger = name,
    description = 'Cleans workspace',
    execute = function()
        local conan_entries
        if _OPTIONS[opt_all] then
            conan_entries = { '.conan2' }
        else
            conan_entries = {
                '.conan2/.conan.db',
                '.conan2/extensions',
                '.conan2/global.conf',
                '.conan2/migrations',
                '.conan2/profiles',
                '.conan2/recipies',
                '.conan2/remotes.json',
                '.conan2/settings.yml',
                '.conan2/version.txt',
            }
        end
        local entries = {
            'build',
            'docs',
            'compile_commands',
            'compile_commands.json',
        }

        for _, v in ipairs(conan_entries) do
            table.insert(entries, v)
        end

        if not os.execute 'make clean' then
            print 'failed to execute make clean'
        end

        for _, entry in ipairs(entries) do
            local full_path = path.join(_MAIN_SCRIPT_DIR, entry)
            if not util.is_path_in_prj(full_path) then
                print('stopping... trying to delete outside project: ' .. entry)
                return
            end

            if os.isdir(full_path) then
                local ok, err = os.rmdir(full_path)
                if ok then
                    print('removed: ' .. entry)
                else
                    print(tostring(err))
                end
            elseif os.isfile(full_path) then
                local ok, err = os.remove(full_path)
                if ok then
                    print('removed: ' .. entry)
                else
                    print(tostring(err))
                end
            end
        end
    end,
}
