# Simplified version of bins.cmake for rt module
include(CMakeParseArguments)

macro(get_target_name)
    get_filename_component(${ARGN} ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    set(${ARGN} ${${ARGN}})
endmacro(get_target_name)

macro(glob_add_dir_source_files)
    if(${ARGN} STREQUAL ".")
        set(varnameprefix)
    else()
        set(varnameprefix ${ARGN}_)
    endif()

    if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${ARGN}
        AND (NOT varnameprefix OR NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGN}/CMakeLists.txt)
        )

        file(GLOB ${varnameprefix}headers ${ARGN}/*.h ${ARGN}/*.hpp ${ARGN}/*.inc ${ARGN}/*.hxx)
        file(GLOB ${varnameprefix}src ${ARGN}/*.cpp ${ARGN}/*.c)
        list(APPEND ${varnameprefix}all_source_files
            ${${varnameprefix}headers}
            ${${varnameprefix}src}
            )
        if(varnameprefix)
            list(APPEND headers ${${varnameprefix}headers})
            list(APPEND src ${${varnameprefix}src})
            list(APPEND all_source_files ${${varnameprefix}all_source_files})
        endif(varnameprefix)
    else()
        unset(${varnameprefix}all_source_files)
        unset(${varnameprefix}headers)
        unset(${varnameprefix}src)
    endif()
endmacro(glob_add_dir_source_files)

macro(glob_source_files)
    glob_add_dir_source_files(.)
    glob_add_dir_source_files(src)
    glob_add_dir_source_files(tests)
    SET_SOURCE_FILES_PROPERTIES(${headers} PROPERTIES HEADER_FILE_ONLY ON)
endmacro(glob_source_files)

function(apply_target_commons this_target)
    target_compile_features(${this_target} PUBLIC cxx_std_23)
    set_target_properties(${this_target} PROPERTIES
        CMAKE_CXX_STANDARD 23
        CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON
        POSITION_INDEPENDENT_CODE ON
    )
    
    target_include_directories(${this_target} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
    )
endfunction(apply_target_commons)

macro(lib)
    string(STRIP "${ARGN}" deps)
    get_target_name(this_target)
    project(${this_target})
    message("\nCreating Library: ${this_target}")
    glob_source_files()
    add_library(${this_target} ${all_source_files})
    apply_target_commons(${this_target})
    
    # Link dependencies
    foreach(dep ${deps})
        target_link_libraries(${this_target} PUBLIC ${dep})
    endforeach()
endmacro(lib)

function(test)
    string(STRIP "${ARGN}" test_libs)
    get_filename_component(parent_target ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)
    get_filename_component(parent_target ${parent_target} NAME)
    project(${parent_target})
    message("\nCreating Tests for ${parent_target}")
    glob_source_files()
    set(libs ${test_libs})
    
    foreach(TEST ${src})
        get_filename_component(TEST_NAME ${TEST} NAME_WE)
        message("test ${TEST_NAME}: ${TEST}")
        add_executable(${TEST_NAME} ${TEST})
        
        target_include_directories(${TEST_NAME} PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}/..
            ${CMAKE_SOURCE_DIR}
        )
        
        target_compile_features(${TEST_NAME} PUBLIC cxx_std_23)
        
        target_link_libraries(${TEST_NAME} PUBLIC
            ${parent_target}
            Boost::unit_test_framework
            ${libs}
        )
        
        add_test(NAME ${TEST_NAME}
            COMMAND ${TEST_NAME} --log_level=all
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
    endforeach()
endfunction(test)
