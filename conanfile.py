from conan import ConanFile


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
    }

    def requirements(self):
        self.requires("spdlog/1.17.0")
        self.requires("opengl/system")
        self.requires("freeimage/3.18.0")

        if self.settings.os == "Macos":
            self.requires("freeglut/3.8.0-cocoa")
        else:
            self.requires("freeglut/3.8.0")
