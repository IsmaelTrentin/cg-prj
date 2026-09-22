if os.isdir '.conan2/deps' then
    include '.conan2/deps/conandeps.premake5.lua'
end

---- WORKSPACE ----
workspace 'cg-prj'
configurations { 'Debug', 'Release' }
architecture(os.hostarch())

-- CONFIGS --
filter { 'configurations:Debug' }
defines { 'DEBUG' }
symbols 'On'
filter {}

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
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
targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
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
if os.isdir '.conan2/deps' then
    conan_setup()
end

-- CLIENT --
project 'client'
location './client'
targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
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
if os.isdir '.conan2/deps' then
    conan_setup()
end

-- TESTS --
project 'test'
location './test'
targetdir 'build/%{cfg.buildcfg}/%{prj.name}/bin'
objdir 'build/%{cfg.buildcfg}/%{prj.name}/obj'
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
if os.isdir '.conan2/deps' then
    conan_setup()
end

-- CUSTOM OPTIONS --
include 'lua/options/all.lua'

-- CUSTOM ACTIONS --
include 'lua/actions/install.lua'
include 'lua/actions/clean.lua'
include 'lua/actions/docs.lua'
include 'lua/actions/test.lua'
