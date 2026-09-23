if os.isdir '.conan2/deps' then
    include '.conan2/deps/conandeps.premake5.lua'
end

---- WORKSPACE ----
workspace 'cg-prj'
configurations { 'Debug', 'Release' }
architecture(os.hostarch())
targetdir 'build/%{cfg.buildcfg}/bin' -- add this at workspace level
objdir 'build/%{cfg.buildcfg}/obj/%{prj.name}'

-- CONFIGS --
filter { 'configurations:Debug' }
defines { '_DEBUG' }
symbols 'On'
conan_setup('debug_' .. string.lower(os.hostarch()))
filter {}

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
conan_setup('release_' .. string.lower(os.hostarch()))
filter {}

-- DEFINITIONS --
filter 'system:windows'
defines { '_WINDOWS' }
filter {}

filter 'system:linux'
defines { '_UNIX' }
filter {}

filter 'system:macosx'
defines { '_APPLE' }
filter {}

---- PROJECTS ----
-- ENGINE --
project 'engine'
location './engine'
-- targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
-- objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
files {
    '%{prj.location}/include/**.h',
    '%{prj.location}/src/**.cpp',
}
includedirs { '%{prj.location}/include' }
kind 'SharedLib'
language 'C++'
cppdialect 'C++20'
buildoptions { '-std=c++20' }
-- ENGINE /windows --
filter 'system:windows'
defines { '_WINDOWS', 'GRAPHICS_ENGINE_EXPORTS' }
filter {}

-- CLIENT --
project 'client'
location './client'
-- targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
-- objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
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
buildoptions { '-std=c++20' }

-- TESTS --
project 'test'
location './test'
-- targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
-- objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
files { '%{prj.location}/src/**.cpp' }
includedirs {
    'engine/include',
    'client/include',
}
links { 'engine', 'client' }
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++20'
buildoptions { '-std=c++20' }

-- CUSTOM OPTIONS --
include 'lua/options/all.lua'

-- CUSTOM ACTIONS --
include 'lua/actions/install.lua'
include 'lua/actions/clean.lua'
include 'lua/actions/docs.lua'
include 'lua/actions/test.lua'
