if (OPENMIND_RT_USE_OPENCL)
    set(DEPENDENCIES
        Boost::filesystem
        Boost::system
        OpenCL::OpenCL
        Boost::compute
    )
else()
    set(DEPENDENCIES
        Boost::filesystem
        Boost::system
    )
endif()

lib(${DEPENDENCIES})

if(OPENMIND_RT_BUILD_TESTS)
    add_subdirectory(tests)
endif()
