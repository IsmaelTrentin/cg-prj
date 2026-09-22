/**
 * @file        engine.cpp
 * @brief   Graphics engine main file
 *
 * @author Dennis Donofrio [dennis.donofrio@student.supsi.ch]
 * @author Gianni Grasso   [gianni.grasso@student.supsi.ch]
 * @author Ismael Trentin  [ismael.trentin@student.supsi.ch]
 */

#include "engine.h"

#include <source_location>
#include <spdlog/spdlog.h>

/**
 * @brief Base class reserved structure (using PIMPL/Bridge design pattern
 * https://en.wikipedia.org/wiki/Opaque_pointer).
 */
struct Eng::Base::Reserved {
    Reserved()
        : initFlag{false} {
        // since spdlog is statically linked, on windows we have an 'instance' for each use of the lib.
        // Therefore we have 2 states for the log level that must be set independently.
#ifdef _DEBUG
        spdlog::set_level(spdlog::level::debug);
#endif 
    }

    bool initFlag;
};

ENG_API Eng::Base::Base()
    : reserved(std::make_unique<Eng::Base::Reserved>()) {
    spdlog::debug("[+] {} invoked", std::source_location::current().function_name());
}

ENG_API Eng::Base::~Base() {
    spdlog::debug("[-] {} invoked", std::source_location::current().function_name());
}

/**
 * Gets a reference to the (unique) singleton instance.
 *
 * @return reference to singleton instance
 */
Eng::Base ENG_API& Eng::Base::getInstance() {
    static Base instance;
    return instance;
}

/**
 * Init internal components.
 *
 * @return TF
 */
bool ENG_API Eng::Base::init() {
    // Already initialized?
    if (reserved->initFlag) {
        spdlog::error("engine already initialized");
        return false;
    }

    // Here you can initialize most of the graphics engine's dependencies and
    // default settings...

    // Done:
    spdlog::debug("[>] {} initialized", LIB_NAME);
    reserved->initFlag = true;
    return true;
}

/**
 * Free internal components.
 *
 * @return TF
 */
bool ENG_API Eng::Base::free() {
    // Not initialized?
    if (!reserved->initFlag) {
        spdlog::error("engine not initialized");
        return false;
    }

    // Here you can properly dispose of any allocated resource (including
    // third-party dependencies)...

    // Done:
    spdlog::debug("[<] {} deinitialized", LIB_NAME);
    reserved->initFlag = false;
    return true;
}
