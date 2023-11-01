block()
    set(gitignore "${PROJECT_SOURCE_DIR}/.gitignore")
    set(ignore_files "")

    if (EXISTS ${gitignore})
        file(STRINGS ${gitignore} lines)
        foreach(line ${lines})
            string(REPLACE "." "[.]" line "${line}")
            string(REPLACE "*" ".*" line "${line}")
            list(APPEND ignore_files "${line}$" "${line}/")
        endforeach()
    endif()

    list(APPEND ignore_files "\.git/")
    list(APPEND ignore_files "\.git$")
    list(APPEND ignore_files "\.gitmodules$")

    set(CPACK_SOURCE_IGNORE_FILES ${ignore_files} PARENT_SCOPE)
endblock()
