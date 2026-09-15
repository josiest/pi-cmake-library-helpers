include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

function(install_pi_interface_targets TARGET_NAME)
    target_include_directories(
            pi-${TARGET_NAME} INTERFACE
            "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")

    install(TARGETS pi-${TARGET_NAME}
            EXPORT pi-${TARGET_NAME}-targets
            FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endfunction()

function(install_pi_package TARGET_NAME)
    get_target_property(pi_target_type pi-${TARGET_NAME} TYPE)
    if (${pi_target_type} STREQUAL INTERFACE_LIBRARY)
        install_pi_interface_targets(${TARGET_NAME})
    endif()

    install(EXPORT pi-${TARGET_NAME}-targets
            FILE pi-${TARGET_NAME}-targets.cmake
            NAMESPACE pi::
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pi-${TARGET_NAME})

    write_basic_package_version_file(
            ${CMAKE_CURRENT_BINARY_DIR}/pi-${TARGET_NAME}-config-version.cmake
            VERSION ${PROJECT_VERSION}
            COMPATIBILITY AnyNewerVersion)

    install(FILES
            ${CMAKE_CURRENT_BINARY_DIR}/pi-${TARGET_NAME}-config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/pi-${TARGET_NAME}-config-version.cmake
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pi-${TARGET_NAME})
endfunction()
