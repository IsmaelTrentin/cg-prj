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
-- CLIENT /macosx --
filter {}
-- CLIENT /windows --
filter 'system:windows'
defines { '_WINDOWS' }
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
    conan_setup 'release_x86_64'
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

