cmake_minimum_required(VERSION 3.14)

project(openmind-omnn-rt VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/"
)

# Include modules from cmake directory
include(cmake/bins.cmake)

option(OPENMIND_RT_BUILD_TESTS "Build tests" ON)
option(OPENMIND_RT_USE_OPENCL "Use OpenCL calculations" OFF)

# Define include directories
set(OPENMIND_RT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# Find dependencies
find_package(Boost REQUIRED COMPONENTS filesystem system)
if(OPENMIND_RT_BUILD_TESTS)
    find_package(Boost REQUIRED COMPONENTS unit_test_framework)
endif()
# Boost multiprecision is header-only and doesn't need a separate component

if(OPENMIND_RT_USE_OPENCL)
    find_package(OpenCL REQUIRED)
    add_definitions(-DOPENMIND_USE_OPENCL)
    
    if(OpenCL_FOUND)
        find_package(Boost REQUIRED COMPONENTS compute)
    endif()
endif()

# Add subdirectories
add_subdirectory(omnn/rt)

if(OPENMIND_RT_BUILD_TESTS)
    enable_testing()
    include(CTest)
endif()

# Installation settings
include(GNUInstallDirs)
install(DIRECTORY omnn/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/omnn
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.inc"
)

# Export targets
install(
    EXPORT omnn-rt-targets
    FILE omnn-rt-targets.cmake
    NAMESPACE omnn::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/omnn-rt
)

# Create and install package configuration files
include(CMakePackageConfigHelpers)
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/omnn-rt-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/omnn-rt-config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/omnn-rt
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/omnn-rt-config-version.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/omnn-rt-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/omnn-rt-config-version.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/omnn-rt
)
