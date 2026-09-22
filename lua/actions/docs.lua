local util = require 'lua/util'

local name = 'docs'
local redirect = util.SILENT
if _OPTIONS['verbose'] then
    redirect = ''
end

newaction {
    trigger = name,
    description = 'Generate docs',
    execute = function()
        local ok, err, code = os.execute('doxygen ./engine/Doxyfile' .. redirect)
        if not ok then
            print(err)
            return
        end

        print 'generated docs in ./docs'
    end,
}
