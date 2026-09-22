/**
 * @file        main.cpp
 * @brief   Client application (that uses the graphics engine)
 *
 * @author Dennis Donofrio [dennis.donofrio@student.supsi.ch]
 * @author Gianni Grasso   [gianni.grasso@student.supsi.ch]
 * @author Ismael Trentin  [ismael.trentin@student.supsi.ch]
 */

#define GLM_ENABLE_EXPERIMENTAL

#include "engine.h"

#include <glm/glm.hpp>
#include <glm/gtx/string_cast.hpp>
#include <iostream>
#include <spdlog/spdlog.h>

/**
 * Application entry point.
 *
 * @param argc number of command-line arguments passed
 * @param argv array containing up to argc passed arguments
 * @return error code (0 on success, error code otherwise)
 */
int main(int argc, char* argv[]) {
#ifdef DEBUG
    spdlog::set_level(spdlog::level::debug);
#endif

    // Credits:
    std::cout << "Client application, D. Donofrio - G. Grasso - I. Trentin (C) SUPSI" << std::endl;
    std::cout << std::endl;

    // Init engine:
    Eng::Base& eng = Eng::Base::getInstance();
    eng.init();

    spdlog::info("using glm: {}", glm::to_string(glm::vec3{1, 2, 3}));

    // Release engine:
    eng.free();

    // Done:
    spdlog::info("[application terminated]");

    return 0;
}
