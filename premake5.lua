if os.isdir './deps' then
    include 'deps/conandeps.premake5.lua'
end

workspace 'cg-prj'
configurations { 'Debug', 'Release' }
architecture 'x86_64'

-- ENGINE --
project 'engine'
location './engine'
targetdir 'build/bin/%{cfg.buildcfg}'
objdir 'build/obj'
files {
    '%{prj.location}/include/**.h',
    '%{prj.location}/src/**.cpp',
}
includedirs { '%{prj.location}/include' }
kind 'SharedLib'
language 'C++'
cppdialect 'C++20'
-- ENGINE /windows --
filter 'system:windows'
defines { '_WINDOWS', 'GRAPHICS_ENGINE_EXPORTS' }
filter {}

-- CLIENT --
project 'client'
location './client'
targetdir 'build/bin/%{cfg.buildcfg}'
objdir 'build/obj'
files {
    '%{prj.location}/include/**.h',
    '%{prj.location}/src/**.cpp',
}
includedirs {
    'engine/include',
    '%{prj.location}/include',
}
links { 'engine' }
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++20'
-- CLIENT /windows --
filter 'system:windows'
defines { '_WINDOWS' }
links { 'opengl32' }
filter {}
-- CLIENT /linux --
filter 'system:linux'
links { 'GL' }
filter {}
-- CLIENT /macosx --
filter 'system:macosx'
links { 'OpenGL.framework' }
filter {}

-- CONFIGS --
filter { 'configurations:Debug' }
defines { 'DEBUG' }
symbols 'On'
filter {}

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
filter {}

if os.isdir './deps' then
    conan_setup()
end

-- CUSTOM ACTIONS --
newaction {
    trigger = 'install',
    description = 'Install deps using conan',
    execute = function()
        if not os.execute 'conan' then
            print 'conan missing. download at https://conan.io/downloads'
            return
        end

        local commands = {
            'conan profile detect',
            'conan config install .conan',
            'conan install . -of deps -b missing -pr cpp20',
        }

        for _, cmd in ipairs(commands) do
            print('running: ' .. cmd)
            if not os.execute(cmd) then
                error('Command failed: ' .. cmd)
            end
        end
    end,
}

newaction {
    trigger = 'ecc:link',
    description = 'Links compile_commands.json to root dir',
    execute = function()
        if not os.isdir 'compile_commands' then
            if not os.execute 'premake5 ecc' then
                print 'failed to run ecc action'
                return
            end
        end

        local ok = false
        if os.host() == 'windows' then
            ok =
                os.execute 'New-Item -ItemType SymbolicLink -Path "compile_commands.json" -Target "compile_commandsdebug.json"'
        else
            ok = os.execute 'ln -s compile_commands/debug.json compile_commands.json'
        end

        if not ok then
            print 'failed to create soft link'
            return
        end
        print 'symlink created: compile_commands.json -> compile_commands/debug.json'
    end,
}

local function exists(path)
    local ok, err, code = os.rename(path, path)
    if ok then
        return true
    end
    -- code 13 = EACCES (permission denied), meaning it exists but you can't rename it
    if code == 13 then
        return true
    end
    return false
end
newaction {
    trigger = 'clean',
    description = 'Cleans workspace',
    execute = function()
        local entries = {
            '.conan2',
            'build',
            'compile_commands',
            'compile_commands.json',
        }
        for _, entry in ipairs(entries) do
            if exists(entry) then
                os.execute('rm -r ' .. entry)
                print('removed ' .. entry)
            end
        end
    end,
}

newoption {
    trigger = 'clean',
    description = 'Choose a particular 3D API for rendering',
    category = 'Build Options',
}
