vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ohhmm/openmind-omnn-rt
    REF eeb8a6e1accadef3aeaf68b08f089e69e813b8e5
    SHA512 d92028a705e8e8c6de6c7b0d1ef8491428730783ede7412202e5dc1c7b2a7e960c8814fd0e4ad7bdce231ee70552ca7ff271137b6fb063659d574c5352ff5ff6
    HEAD_REF main
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DOPENMIND_RT_BUILD_TESTS=OFF
)

vcpkg_install_cmake()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# Remove debug includes
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Create a simple config file for find_package support
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/${PORT}-config.cmake" [[
# omnn-rt-config.cmake - package configuration file

get_filename_component(SELF_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(SELF_DIR "${SELF_DIR}" PATH)
get_filename_component(SELF_DIR "${SELF_DIR}" PATH)

set(OMNN_RT_INCLUDE_DIRS "${SELF_DIR}/include")

if(NOT TARGET omnn::rt)
    add_library(omnn::rt INTERFACE IMPORTED)
    set_target_properties(omnn::rt PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${OMNN_RT_INCLUDE_DIRS}"
    )
    
    # Add dependencies
    find_package(Boost REQUIRED COMPONENTS filesystem system)
    target_link_libraries(omnn::rt INTERFACE Boost::filesystem Boost::system)
endif()
]])

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/${PORT}-config-version.cmake" [[
# omnn-rt-config-version.cmake - package version file

set(PACKAGE_VERSION "0.1.0")

if(PACKAGE_FIND_VERSION VERSION_GREATER PACKAGE_VERSION)
    set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
    set(PACKAGE_VERSION_COMPATIBLE TRUE)
    if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)
        set(PACKAGE_VERSION_EXACT TRUE)
    endif()
endif()
]])

vcpkg_copy_pdbs()
