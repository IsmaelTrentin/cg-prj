#include "engine.h"

#include <gtest/gtest.h>

TEST(EngineTest, GetInstanceReturnsValidRef) {
    Eng::Base& inst = Eng::Base::getInstance();
    inst.init();

    SUCCEED();

    inst.free();
}

TEST(EngineTest, EngineIsSingleton) {
    Eng::Base& inst1 = Eng::Base::getInstance();
    Eng::Base& inst2 = Eng::Base::getInstance();

    EXPECT_EQ(&inst1, &inst2);


    inst1.init();
    EXPECT_EQ(&inst1, &inst2);

    inst1.free();
    EXPECT_EQ(&inst1, &inst2);
}
