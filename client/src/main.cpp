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

#include <spdlog/spdlog.h>

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

    // Release engine:
    eng.free();

    // Done:
    std::cout << "\n[application terminated]" << std::endl;
    return 0;
}
