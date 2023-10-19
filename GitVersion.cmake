if(NOT DEFINED GIT_EXECUTABLE)
    find_package(Git QUIET)
endif()

function(GIT OUT)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} ${ARGN}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE output
        ERROR_VARIABLE err
        RESULT_VARIABLE result
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    if(result EQUAL 0)
        set(${OUT} ${output} PARENT_SCOPE)
        return()
    endif()

    if(result MATCHES "^[0-9]+$")
        set(failure "exited with code (${result}):\n${err}")
    else()
        set(failure "failed to run:\n${result}")
    endif()

    message(DEBUG "'${GIT_EXECUTABLE} ${ARGN}' ${failure}")
endfunction()

function(DESCRIBE OUT)
    git(result describe --match "v*" ${ARGN})

    if(DEFINED result)
        string(REGEX REPLACE "^v" "" result ${result})
        set(${OUT} ${result} PARENT_SCOPE)
    endif()
endfunction()

if(GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
    describe(GIT_VERSION_ABBREV --abbrev=0)

    if(DEFINED GIT_VERSION_ABBREV)
        describe(GIT_VERSION_FULL)
    endif()
endif()

if(
    NOT DEFINED GIT_VERSION_ABBREV AND
    EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION"
)
    file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" GIT_VERSION_ABBREV)
endif()

if(NOT DEFINED GIT_VERSION_ABBREV)
    set(GIT_VERSION_ABBREV 0.0.0)
endif()

if(NOT DEFINED GIT_VERSION_FULL)
    set(GIT_VERSION_FULL ${GIT_VERSION_ABBREV})
endif()
