set(
    EASY_INSTALL_CONFIG_FILE
    "${CMAKE_CURRENT_LIST_DIR}/EasyInstallConfig.cmake.in"
)

macro(EASY_INSTALL)
    include(CMakePackageConfigHelpers)
    include(GNUInstallDirs)

    foreach(target ${ARGN})
        get_target_property(target_type ${target} TYPE)

        if(target_type STREQUAL SHARED_LIBRARY)
            set_target_properties(${target} PROPERTIES
                VERSION ${PROJECT_VERSION}
                SOVERSION ${PROJECT_VERSION_MAJOR}
            )
        endif()
    endforeach()

    set(CMAKE_INSTALL_MODDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

    set(project_config ${PROJECT_NAME}-config.cmake)
    set(version_config ${PROJECT_NAME}-config-version.cmake)
    set(targets_export_name ${PROJECT_NAME}-targets)

    install(
        TARGETS ${ARGN}
        EXPORT ${targets_export_name}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        FILE_SET HEADERS
    )

    export(
        EXPORT ${targets_export_name}
        NAMESPACE ${PROJECT_NAME}::
        FILE ${targets_export_name}.cmake
    )

    configure_package_config_file(
        "${EASY_INSTALL_CONFIG_FILE}"
        ${project_config}
        INSTALL_DESTINATION ${CMAKE_INSTALL_MODDIR}
    )

    write_basic_package_version_file(
        ${version_config}
        VERSION ${PACKAGE_VERSION}
        COMPATIBILITY AnyNewerVersion
    )

    install(
        FILES
            "${PROJECT_BINARY_DIR}/${project_config}"
            "${PROJECT_BINARY_DIR}/${version_config}"
        DESTINATION ${CMAKE_INSTALL_MODDIR}
    )
    install(
        EXPORT ${targets_export_name}
        DESTINATION ${CMAKE_INSTALL_MODDIR}
        NAMESPACE ${PROJECT_NAME}::
    )

    export(PACKAGE ${PROJECT_NAME})

    set(CPACK_SOURCE_PACKAGE_FILE_NAME ${PROJECT_NAME}-${GIT_VERSION_FULL})
    include(CPackGitIgnore)
    include(CPack)
endmacro()
