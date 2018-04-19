mkdir cmake-build-debug
cd cmake-build-debug
cmake -DSTM32_CHIP=STM32F103C8 -DCMAKE_TOOLCHAIN_FILE=cmake/gcc_stm32.cmake -DCMAKE_BUILD_TYPE=Debug -G "CodeBlocks - Unix Makefiles" ..
cd ..

mkdir cmake-build-release
cd cmake-build-release
cmake -DSTM32_CHIP=STM32F103C8 -DCMAKE_TOOLCHAIN_FILE=cmake/gcc_stm32.cmake -DCMAKE_BUILD_TYPE=Release -G "CodeBlocks - Unix Makefiles" ./cmake-build-release/
cd ..