/**
 * @file		engine.h
 * @brief	Graphics engine main include file
 *
 * @author Dennis Donofrio [dennis.donofrio@student.supsi.ch]
 * @author Gianni Grasso   [gianni.grasso@student.supsi.ch]
 * @author Ismael Trentin  [ismael.trentin@student.supsi.ch]
 */
#pragma once

// Lib info
#ifdef _DEBUG
#define LIB_NAME "My Graphics Engine v0.1a (debug)"
#else
#define LIB_NAME "My Graphics Engine v0.1a"
#endif
#define LIB_VERSION 10

// Export API:
#ifdef _WINDOWS
// Specifies i/o linkage (VC++ spec):
#ifdef GRAPHICS_ENGINE_EXPORTS
#define ENG_API __declspec(dllexport)
#else
#define ENG_API __declspec(dllimport)
#endif

// Get rid of annoying warnings:
#pragma warning(disable : 4251)
#else // Under linux
#define ENG_API
#endif

#include <memory>

namespace Eng {

/**
 * @brief Base engine main class. This class is a singleton.
 */
class ENG_API Base final {
public:
    Base(Base const&) = delete;
    ~Base();

    void operator=(Base const&) = delete;

    static Base& getInstance();

    bool init();
    bool free();

private:
    struct Reserved;
    std::unique_ptr<Reserved> reserved;

    Base();
};

}; // namespace Eng
