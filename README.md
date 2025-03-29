# OpenMind Neural Networks - Runtime Utilities

This repository contains the runtime utilities extracted from the [OpenMind Neural Networks](https://github.com/ohhmm/openmind) project as a standalone library.

## Features

- Task queue management
- Prime number utilities
- String hashing
- Memory management
- Architecture detection
- Various utility functions and templates

## Building

### Prerequisites

- CMake 3.14 or higher
- C++ compiler with C++23 support
- Boost libraries (filesystem, multiprecision, system)
- Optionally: OpenCL

### Building with vcpkg

```bash
git clone https://github.com/ohhmm/openmind-omnn-rt.git
cd openmind-omnn-rt
mkdir build && cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=[path to vcpkg]/scripts/buildsystems/vcpkg.cmake
cmake --build .
```

### Building with OpenCL support

```bash
cmake .. -DCMAKE_TOOLCHAIN_FILE=[path to vcpkg]/scripts/buildsystems/vcpkg.cmake -DOPENMIND_RT_USE_OPENCL=ON
cmake --build .
```

### Running tests

```bash
cmake .. -DCMAKE_TOOLCHAIN_FILE=[path to vcpkg]/scripts/buildsystems/vcpkg.cmake -DOPENMIND_RT_BUILD_TESTS=ON
cmake --build .
ctest
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
