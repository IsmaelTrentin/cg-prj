// Minimal freeglut + OpenGL + FreeImage test.
// Draws the classic RGB gradient triangle, plus a small checkerboard quad
// whose texture is generated in memory with FreeImage (no files needed).
//
#define GLM_ENABLE_EXPERIMENTAL
#ifndef GL_BGRA // Windows gl.h is GL 1.1 only
#define GL_BGRA 0x80E1
#endif

#include "engine.h"

#include <GL/freeglut.h>
#include <glm/glm.hpp>
#include <glm/gtx/string_cast.hpp>
#include <iostream>
#include <spdlog/spdlog.h>
#ifdef __APPLE__
#include <OpenGL/gl.h>
#else
#include <GL/gl.h>
#endif
#include <FreeImage.h>
#include <cstdio>
#include <glm/glm.hpp>
#include <spdlog/spdlog.h>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif

static GLuint tex = 0;

static void makeTexture() {
    // 64x64 32-bit bitmap (BGRA), red/blue checkerboard
    FIBITMAP* img = FreeImage_Allocate(64, 64, 32);
    for (unsigned y = 0; y < 64; ++y)
        for (unsigned x = 0; x < 64; ++x) {
            BYTE v = ((x / 8 + y / 8) % 2) ? 255 : 40;
            RGBQUAD c = {v, 0, (BYTE)(255 - v), 255}; // B, G, R, A
            FreeImage_SetPixelColor(img, x, y, &c);
        }

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 64, 64, 0, GL_BGRA, GL_UNSIGNED_BYTE,
                 FreeImage_GetBits(img));
    FreeImage_Unload(img);
}

static void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    // Gradient triangle (red, green, blue corners)
    glDisable(GL_TEXTURE_2D);
    glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0);
    glVertex2f(-0.6f, -0.6f);
    glColor3f(0, 1, 0);
    glVertex2f(0.6f, -0.6f);
    glColor3f(0, 0, 1);
    glVertex2f(0.0f, 0.7f);
    glEnd();

    // Small textured quad in the bottom-left corner (FreeImage texture)
    glEnable(GL_TEXTURE_2D);
    glColor3f(1, 1, 1);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0);
    glVertex2f(-0.95f, -0.95f);
    glTexCoord2f(1, 0);
    glVertex2f(-0.65f, -0.95f);
    glTexCoord2f(1, 1);
    glVertex2f(-0.65f, -0.65f);
    glTexCoord2f(0, 1);
    glVertex2f(-0.95f, -0.65f);
    glEnd();

    GLenum err = glGetError();
    if (err != GL_NO_ERROR)
        std::printf("GL error: 0x%x\n", err);

    glutSwapBuffers();
}

static void reshape(int w, int h) {
    glViewport(0, 0, w, h);
}
static void idle() {
    glutPostRedisplay();
}

int main(int argc, char* argv[]) {
#ifdef _DEBUG
    spdlog::set_level(spdlog::level::debug);
#endif

    // Credits:
    std::cout << "Client application, D. Donofrio - G. Grasso - I. Trentin (C) SUPSI" << std::endl;
    std::cout << std::endl;

    // Init engine:
    Eng::Base& eng = Eng::Base::getInstance();
    eng.init();

    spdlog::info("using glm: {}", glm::to_string(glm::vec3{1, 2, 3}));
    FreeImage_Initialise();

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(640, 480);
    glutCreateWindow("freeglut + FreeImage test");

    spdlog::info("GL_VERSION: {}", (const char*)glGetString(GL_VERSION));
    spdlog::info("GL_RENDERER: {}", (const char*)glGetString(GL_RENDERER));
    spdlog::info("FreeImage: {}", FreeImage_GetVersion());

    glClearColor(0.15f, 0.15f, 0.15f, 1.0f);
    makeTexture();

    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);

    // Return from glutMainLoop() when the window is closed, so cleanup runs
    glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_CONTINUE_EXECUTION);
    glutMainLoop();

    FreeImage_DeInitialise();

    // Release engine:
    eng.free();

    // Done:
    spdlog::info("[application terminated]");

    return 0;
}
