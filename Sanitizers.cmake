function(enable_asan)
    set(ASAN_FLAGS -fsanitize=address -fno-omit-frame-pointer)

    if(ARGC EQUAL 0)
        get_property(targets
            DIRECTORY ${PROJECT_SOURCE_DIR}
            PROPERTY BUILDSYSTEM_TARGETS
        )
    else()
        set(targets ${ARGN})
    endif()

    foreach(target ${targets})
        get_target_property(target_type ${target} TYPE)

        if(target_type STREQUAL "UTILITY")
            continue()
        endif()

        target_compile_options(${target}
            PRIVATE $<$<CONFIG:Debug>:${ASAN_FLAGS}>
        )
        target_link_options(${target}
            PRIVATE $<$<CONFIG:Debug>:${ASAN_FLAGS}>
        )
    endforeach()
endfunction()
