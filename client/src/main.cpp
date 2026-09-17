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

#define GL_SILENCE_DEPRECATION
#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/freeglut.h>
#endif

#include <FreeImage.h>
#include <glm/glm.hpp>
#include <spdlog/spdlog.h>

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0);
    glVertex2f(-0.5f, -0.5f);
    glColor3f(0, 1, 0);
    glVertex2f(0.5f, -0.5f);
    glColor3f(0, 0, 1);
    glVertex2f(0.0f, 0.5f);
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
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowSize(640, 480);
    glutCreateWindow("OpenGL 1.x on macOS (premake5)");
    glutDisplayFunc(display);

    eng.test();
    glutMainLoop();

    // Release engine:
    eng.free();

    // Done:
    std::cout << "\n[application terminated]" << std::endl;
    return 0;
}
