from conan import ConanFile
from conan.tools.cmake import CMakeToolchain


class MyProject(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "PremakeDeps"

    default_options = {
        "freeimage/*:with_jpeg2000": False,
        "freeimage/*:with_raw": False,
        "freeimage/*:with_openexr": False,
        "freeimage/*:with_jxr": False,
        "freeimage/*:with_webp": False,
        "freeimage/*:with_tiff": False,
        "freeglut/*:with_wayland": False,
    }

    def requirements(self):
        self.requires("spdlog/1.17.0")
        self.requires("opengl/system")
        self.requires("freeimage/3.18.0")
        self.requires("glm/1.0.3")
        self.requires("gtest/1.18.0")

        if self.settings.os == "Macos":
            self.requires("freeglut/3.8.0-cocoa")
        else:
            self.requires("freeglut/3.8.0")
