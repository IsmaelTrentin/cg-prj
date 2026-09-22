# Computer Graphics Course Project

The task is to build a graphics engine using OpenGL 1.x, Freeimage, freeglut and glm that is then used by a client app that must behave like a simple 3D model viewer.

Group members and authors:

- Dennis Donofrio
- Grasso Gianni
- Ismael Trentin

# Building

To build this project, the following tools are needed:

```txt
c/c++ compiler or toolchain
cmake
conan
premake5
```

[Conan](https://conan.io/downloads) is used to manage the project dependencies, while [premake5](https://premake.github.io/download) handles the generation of build/project files.

The intended workflow is to first download and compile all dependencies, then generate build/project files, and finally compile sources. Additionally if you want to use neovim you must generate CDBs for clangd, check the [Neovim chapter](#neovim).

To download and compile the dependencies run:

```bash
premake5 install
```

## Windows

To generate project files for **Microsoft Visual Studio** run:

```bash
premake5 vs2026
```

> check `premake5 --help` to see all supported VS versions

Compilation and execution is then available inside VS.

## UNIX

To generate the make files for **UNIX** run:

```bash
premake5 gmake
```

To compile the sources for `Debug` configuration run:

```bash
make
```

for `Release` configuration instead run:

```bash
make config=release
```

## MacOS

Intel MacOS are supported by compiling `freeglut/3.8.0` with `-DFREEGLUT_COCOA=ON`, check [here](https://github.com/freeglut/freeglut/blob/master/README.macos) for more info. This is conveniently handled by conan while installing the dependencies. For ARM devices testing is yet to be done, thus categorizing them as unsupported.

# Premake5 Custom Actions

To clean all generated files except for dependencies:

```bash
premake5 clean
```

Use `--all` to clear everything including conan dependencies.

To generate the docs for the `engine` project run:

```bash
premake5 docs
```

# Neovim

If you want to use neovim with `clangd` LSP, use this custom premake5 action to [export compile_commands.json](https://github.com/tarruda/premake-export-compile-commands) from the generated premake5 files.
