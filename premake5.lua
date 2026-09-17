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
    'libs/spdlog/include',
}
links { 'engine', 'spdlog' }
kind 'ConsoleApp'
language 'C++'
cppdialect 'C++20'

filter 'system:macosx'
buildoptions {
    '-isysroot ' .. '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk',
}
-- MacPorts include
includedirs { '/opt/local/include' }
-- MacPorts lib
libdirs { '/opt/local/lib' }
links {
    'OpenGL.framework',
    'GLUT.framework',
    'freeimage',
}

filter 'system:linux'
links {
    'GL',
    'GLU',
    'glut',
    'freeimage',
}

filter 'system:windows'
defines { '_WINDOWS' }
filter {}

filter { 'configurations:Debug' }
defines { 'DEBUG' }
symbols 'On'

filter { 'configurations:Release' }
defines { 'NDEBUG' }
optimize 'On'
