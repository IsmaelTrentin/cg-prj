import os
from conan import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain, cmake_layout
from conan.tools.files import get, copy, rmdir


class FreeglutCocoaConan(ConanFile):
    name = "freeglut"
    version = "3.8.0-cocoa"
    settings = "os", "arch", "compiler", "build_type"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}

    def validate(self):
        if self.settings.os != "Macos":
            raise ConanInvalidConfiguration(
                "This recipe is only for the macOS Cocoa backend. "
                "Use freeglut/3.8.0 from ConanCenter on other platforms.")

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def layout(self):
        cmake_layout(self, src_folder="src")

    def source(self):
        get(self, "https://github.com/freeglut/freeglut/archive/refs/tags/v3.8.0.tar.gz",
            strip_root=True)

    def generate(self):
        tc = CMakeToolchain(self)
        tc.variables["FREEGLUT_BUILD_DEMOS"] = False
        tc.variables["FREEGLUT_BUILD_SHARED_LIBS"] = bool(self.options.shared)
        tc.variables["FREEGLUT_BUILD_STATIC_LIBS"] = not self.options.shared
        # compile experimental using native MacOS cocoa backend
        tc.variables["FREEGLUT_COCOA"] = True

        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        copy(self, "COPYING*", self.source_folder,
             os.path.join(self.package_folder, "licenses"))
        CMake(self).install()
        rmdir(self, os.path.join(self.package_folder, "lib", "cmake"))
        rmdir(self, os.path.join(self.package_folder, "lib", "pkgconfig"))

    def package_info(self):
        self.cpp_info.libs = ["glut"]
        self.cpp_info.frameworks = ["Cocoa", "OpenGL", "CoreVideo"]
        if not self.options.shared:
            self.cpp_info.defines.append("FREEGLUT_STATIC")
