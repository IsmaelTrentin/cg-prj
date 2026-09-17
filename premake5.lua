workspace 'cg-prj'
configurations { 'Debug', 'Release' }
location 'build'
architecture 'x86_64'

-- ENGINE --
project 'engine'
location 'build/engine'
files {
    'engine/include/**.h',
    'engine/src/**.cpp',
}
includedirs { 'engine/include' }
kind 'SharedLib'
language 'C++'
cppdialect 'C++20'
-- ENGINE /windows --
filter 'system:windows'
defines { '_WINDOWS', 'GRAPHICS_ENGINE_EXPORTS' }
filter {}

-- CLIENT --
project 'client'
location 'build/client'
files {
    'client/include/**.h',
    'client/src/**.cpp',
}
includedirs {
    'engine/include',
    'client/include',
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
-- CLIENT /windows --
filter 'system:windows'
defines { '_WINDOWS' }
filter {}

-- CONFIGS --
filter { 'configurations:Debug' }
defines { 'DEBUG' }
symbols 'On'

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
