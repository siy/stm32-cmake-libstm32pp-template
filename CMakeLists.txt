PROJECT(stm32-template)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
ENABLE_LANGUAGE(ASM)

### COMPILATION OPTIONS #######################################################
## Linker
# use newlib-nano - minimal implementation of libc that removes unneeded features
SET(LINKER_SPECS "--specs=nano.specs --specs=nosys.specs")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${LINKER_SPECS}")
SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${LINKER_SPECS}")
SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${LINKER_SPECS}")

## Compiler
# disable c++ exceptions and runtime type info (they're too expensive for embedded)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fno-rtti")

INCLUDE_DIRECTORIES(
    ${CMAKE_CURRENT_SOURCE_DIR}
    src
    src/include
    libstm32pp/include
    libstm32pp/bits
    libstm32pp/memorymap
    libstm32pp/include
)

SET(PROJECT_SOURCES
    src/main.cpp
    src/interrupt.cpp
)

SET(STM32_LINKER_SCRIPT ${CMSIS_LINKER_SCRIPT})

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME} ${PROJECT_SOURCES} ${CMSIS_SOURCES}) # ${STM32HAL_SOURCES}

STM32_SET_TARGET_PROPERTIES(${CMAKE_PROJECT_NAME})
STM32_ADD_HEX_BIN_TARGETS(${CMAKE_PROJECT_NAME})
STM32_PRINT_SIZE_OF_TARGETS(${CMAKE_PROJECT_NAME})
