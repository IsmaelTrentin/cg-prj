/**
 * @file        main.cpp
 * @brief   Client application (that uses the graphics engine)
 *
 * @author  Achille Peternier (C) SUPSI [achille.peternier@supsi.ch] <<
 * change this to your group members
 */

//////////////
// #INCLUDE //
//////////////

// Library header:
#include "engine.h"

// C/C++:
#include <iostream>

//////////
// MAIN //
//////////

/**
 * Application entry point.
 * @param argc number of command-line arguments passed
 * @param argv array containing up to argc passed arguments
 * @return error code (0 on success, error code otherwise)
 */
/*
int main(int argc, char *argv[]) {
  // Credits:
  std::cout << "Client application example, A. Peternier (C) SUPSI"
            << std::endl;
  std::cout << std::endl;

  // Init engine:
  Eng::Base &eng = Eng::Base::getInstance();
  eng.init();

  eng.test();

  // Release engine:
  eng.free();

  // Done:
  std::cout << "\n[application terminated]" << std::endl;
  return 0;
}
*/

// Minimal OpenGL + freeglut + FreeImage test: draws a FreeImage-made texture.
#ifndef GL_BGRA // Windows gl.h is GL 1.1 only
#define GL_BGRA 0x80E1
#endif

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif

#define GL_SILENCE_DEPRECATION // macOS: hide OpenGL deprecation warnings
#include <GL/freeglut.h>
#ifdef __APPLE__
#include <OpenGL/gl.h>
#else
#include <GL/gl.h>
#endif
#include <FreeImage.h>

#include <cstdio>
#include <spdlog/spdlog.h>

static void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0);
    glVertex2f(-0.8f, -0.8f);
    glTexCoord2f(1, 0);
    glVertex2f(0.8f, -0.8f);
    glTexCoord2f(1, 1);
    glVertex2f(0.8f, 0.8f);
    glTexCoord2f(0, 1);
    glVertex2f(-0.8f, 0.8f);
    glEnd();
    glutSwapBuffers();
}

int main(int argc, char** argv) {
    spdlog::info("hello spdlog");
    spdlog::error("Some error message with arg: {}", 1);
    spdlog::warn("Easy padding in numbers like {:08d}", 12);
    spdlog::critical("Support for int: {0:d};  hex: {0:x};  oct: {0:o}; bin: {0:b}", 42);
    spdlog::info("Support for floats {:03.2f}", 1.23456);

    // Credits:
    std::cout << "Client application example, A. Peternier (C) SUPSI" << std::endl;
    std::cout << std::endl;

    // Init engine:
    Eng::Base& eng = Eng::Base::getInstance();
    eng.init();

    eng.test();
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    glutCreateWindow("freeglut + FreeImage");
    std::printf("GL: %s | FreeImage: %s\n", (const char*)glGetString(GL_VERSION),
                FreeImage_GetVersion());

    // FreeImage: build a 64x64 checkerboard (32-bit, stored as BGRA)
    FIBITMAP* img = FreeImage_Allocate(64, 64, 32);
    for (unsigned y = 0; y < 64; ++y)
        for (unsigned x = 0; x < 64; ++x) {
            BYTE v = ((x / 8 + y / 8) % 2) ? 255 : 40;
            RGBQUAD c = {v, 0, (BYTE)(255 - v), 255}; // B, G, R, A
            FreeImage_SetPixelColor(img, x, y, &c);
        }

    // OpenGL: upload it as a texture
    GLuint tex;
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 64, 64, 0, GL_BGRA, GL_UNSIGNED_BYTE,
                 FreeImage_GetBits(img));
    FreeImage_Unload(img);
    glEnable(GL_TEXTURE_2D);

    glutDisplayFunc(display);
    glutMainLoop();

    // Release engine:
    eng.free();

    // Done:
    std::cout << "\n[application terminated]" << std::endl;
    return 0;
}
