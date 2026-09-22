if os.isdir '.conan2/deps' then
    include '.conan2/deps/conandeps.premake5.lua'
end

workspace 'cg-prj'
configurations { 'Debug', 'Release' }
architecture(os.hostarch())

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
-- ENGINE /windows --
filter 'system:windows'
defines { '_WINDOWS', 'GRAPHICS_ENGINE_EXPORTS' }
filter {}

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
-- CLIENT /windows --
filter 'system:windows'
defines { '_WINDOWS' }
filter {}
-- CLIENT /linux --
filter 'system:linux'
-- links { 'GL', 'glut' }
filter {}
-- CLIENT /macosx --
filter 'system:macosx'
-- links { 'OpenGL.framework', 'glut' }
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

if os.isdir '.conan2/deps' then
    conan_setup()
end

-- CUSTOM OPTIONS --
include 'lua/options/log.lua'
include 'lua/options/all.lua'

-- CUSTOM ACTIONS --
include 'lua/actions/install.lua'
include 'lua/actions/ecc_link.lua'
include 'lua/actions/clean.lua'
