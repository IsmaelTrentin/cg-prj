#include "engine.h"

#include <gtest/gtest.h>

TEST(EngineTest, GetInstanceReturnsValidRef) {
    Eng::Base& inst = Eng::Base::getInstance();

    SUCCEED();
}

TEST(EngineTest, EngineIsSingleton) {
    Eng::Base& inst1 = Eng::Base::getInstance();
    Eng::Base& inst2 = Eng::Base::getInstance();

    EXPECT_EQ(&inst1, &inst2);
}
