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

# Export the target
install(
    TARGETS rt
    EXPORT omnn-rt-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

if(OPENMIND_RT_BUILD_TESTS)
    add_subdirectory(tests)
endif()
