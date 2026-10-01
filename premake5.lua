if os.isdir '.conan2/deps' then
    include '.conan2/deps/conandeps.premake5.lua'
end

local arch = string.lower(os.hostarch())

---- WORKSPACE ----
workspace 'cg-prj'
configurations { 'Debug', 'Release' }
architecture(arch)
targetdir 'build/%{cfg.buildcfg}/bin'
objdir 'build/%{cfg.buildcfg}/obj/%{prj.name}'

-- CONFIGS --
filter { 'configurations:Debug' }
defines { '_DEBUG' }
symbols 'On'
if os.isdir '.conan2/deps' then
    conan_setup('debug_' .. arch)
end
filter {}

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
if os.isdir '.conan2/deps' then
    conan_setup('release_' .. arch)
end
filter {}

---- PROJECTS ----
-- ENGINE --
project 'engine'
location './engine'
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
-- ENGINE /linux --
filter 'system:linux'
defines { '_UNIX' }
filter {}
-- ENGINE /macosx --
filter 'system:macosx'
defines { '_APPLE' }
filter {}

-- CLIENT --
project 'client'
location './client'
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
-- CLIENT /windows --
filter 'system:windows'
defines { '_WINDOWS' }
filter {}
-- CLIENT /linux --
filter 'system:linux'
defines { '_UNIX' }
filter {}
-- CLIENT /macosx --
filter 'system:macosx'
defines { '_APPLE' }
filter {}

-- TESTS --
project 'test'
location './test'
files {
    '%{prj.location}/include/**.h',
    '%{prj.location}/src/**.cpp',
}
includedirs {
    'engine/include',
    'client/include',
}
links { 'engine', 'client' }
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++20'
buildoptions { '-std=c++20' }
-- UNIT-TEST /windows --
filter 'system:windows'
defines { '_WINDOWS' }
filter {}
-- UNIT-TEST /linux --
filter 'system:linux'
defines { '_UNIX' }
filter {}
-- UNIT-TEST /macosx --
filter 'system:macosx'
defines { '_APPLE' }
filter {}

-- CUSTOM OPTIONS --
include 'lua/options/all.lua'

-- CUSTOM ACTIONS --
include 'lua/actions/install.lua'
include 'lua/actions/clean.lua'
include 'lua/actions/docs.lua'
include 'lua/actions/test.lua'
