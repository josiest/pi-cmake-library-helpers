include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

function(install_pi_interface_targets TARGET_NAME)
    target_include_directories(pi-${TARGET_NAME} INTERFACE
            "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")

    install(TARGETS pi-${TARGET_NAME}
            EXPORT pi-${TARGET_NAME}-targets
            FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endfunction()

function(install_pi_static_targets TARGET_NAME)
    target_include_directories(pi-${TARGET_NAME} PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALLL_INCLUDE_DIR}>")

    install(TARGETS pi-${TARGET_NAME}
            EXPORT pi-${TARGET_NAME}-targets
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            FILE_SET HEADERS DESTINATINO ${CMAKE_INSTALL_INCLUDEDIR})
endfunction()

function(install_pi_package TARGET_NAME)
    get_target_property(pi_target_type pi-${TARGET_NAME} TYPE)
    if (${pi_target_type} STREQUAL INTERFACE_LIBRARY)
        install_pi_interface_targets(${TARGET_NAME})
    elseif(${pi_target_type} STREQUAL STATIC_LIBRARY)
        install_pi_static_targets(${TARGET_NAME})
    endif()

    install(EXPORT pi-${TARGET_NAME}-targets
            FILE pi-${TARGET_NAME}-targets.cmake
            NAMESPACE pi::
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pi-${TARGET_NAME})

    set(pi_library_version_filepath "${CMAKE_CURRENT_BINARY_DIR}/pi-${TARGET_NAME}-config-version.cmake")
    write_basic_package_version_file(${pi_library_version_filepath}
                                     VERSION ${PROJECT_VERSION}
                                     COMPATIBILITY AnyNewerVersion)

    install(FILES
                pi-${TARGET_NAME}-config.cmake
                ${pi_library_version_filepath}
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pi-${TARGET_NAME})
endfunction()
