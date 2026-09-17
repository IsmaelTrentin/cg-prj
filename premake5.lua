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
links { 'engine', 'spdlog' }
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++20'
-- CLIENT /macosx --
filter 'system:macosx'
buildoptions {
    '-isysroot ' .. '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk',
}
filter {}
-- MacPorts include
includedirs {
    '/opt/local/include',
    -- Workaround since fmt through MacPorts has a different header path (uses libfmtNN)
    -- and doing /** is too time consuming
    '/opt/local/include/*fmt*',
}
-- MacPorts lib
libdirs {
    '/opt/local/lib',
    '/opt/local/lib/*fmt*',
}
links {
    'OpenGL.framework',
    'GLUT.framework',
    'freeimage',
    'fmt',
}
-- CLIENT /linux --
filter 'system:linux'
links {
    'GL',
    'GLU',
    'glut',
    'freeimage',
}
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
