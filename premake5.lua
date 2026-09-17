workspace("workspace")
configurations({ "Debug", "Release" })
location("build")

project("engine")
location("build/engine")
files({ "engine/include/**.h", "engine/src/**.cpp" })
includedirs({ "engine/include" })
kind("SharedLib")
language("C++")
cppdialect("C++20")

if os.host() == "macosx" then
	filter({ "system:macosx" })
	buildoptions({ "-isysroot " .. "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" })
end

filter("system:macosx")
includedirs({ "/usr/local/opt/freeimage/include", "/usr/local/opt/glm/include" })
libdirs({ "/usr/local/opt/freeimage/lib" })
links({ "OpenGL.framework", "GLUT.framework", "freeimage" })

filter("system:linux")
links({ "GL", "GLU", "glut", "freeimage" })

project("client")
location("build/client")
files({ "client/include/**.h", "client/src/**.cpp" })
includedirs({ "engine/include", "client/include" })
links("engine")
kind("ConsoleApp")
language("C++")
cppdialect("C++20")

if os.host() == "macosx" then
	filter({ "system:macosx" })
	buildoptions({ "-isysroot " .. "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" })
end

filter("system:macosx")
includedirs({ "/usr/local/opt/freeimage/include", "/usr/local/opt/glm/include" })
libdirs({ "/usr/local/opt/freeimage/lib" })
links({ "OpenGL.framework", "GLUT.framework", "freeimage" })

filter("system:linux")
links({ "GL", "GLU", "glut", "freeimage" })

filter({ "configurations:Debug" })
defines({ "DEBUG" })
symbols("On")

filter({ "configurations:Release" })
defines({ "NDEBUG" })
optimize("On")
