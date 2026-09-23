local name = 'test'

newaction {
    trigger = name,
    description = 'Run tests',
    execute = function()
        if os.host() == 'windows' then
            print 'not supported on windows'
            return
        end

        os.execute 'make test'
        local fpath = path.join('.', 'build', 'Debug', 'bin', 'test')
        os.execute(fpath)
    end,
}
